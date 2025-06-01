//
//  OperationSearchViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/11/2024.
//
import Foundation
class OperationSearchViewModel {
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var operations: [Operation]?
    @Published var isLoading = false
    
    private var apiClient: APIClient
    private var currentPageURL: URL?
    
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
    
    func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.getOperations(searchedText: searchText)
            }
            .store(in: &cancellables)
    }
    
    func getOperations(searchedText: String) {
        
        let router = APIRouter.fetchOperations(isPaginate: 10, search: searchedText)
        currentPageURL = router.url
        
        apiClient.fetchData(from: router.url, as: OperationsResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch operations: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                self?.operations = response.data
                self?.currentPageURL = response.links?.next.flatMap { URL(string: $0) }
            })
            .store(in: &cancellables)
    }
    func clearSearchResults() {
        operations = []
    }
    func loadMoreOperations() {
        guard !isLoading, let nextURL = currentPageURL else { return }
        isLoading = true
        apiClient.fetchData(from: nextURL, as: OperationsResponse.self)
            .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread.
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch more operations: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                self?.operations?.append(contentsOf: response.data ?? [])
                self?.currentPageURL = response.links?.next.flatMap { URL(string: $0) }
            })
            .store(in: &cancellables)
    }
}
extension OperationSearchViewModel{
    internal func navToOperationHospitals (operationID:Int){
        coordinator?.showOpertionHospitals(operationID: operationID)
    }
  func navBack(){
      coordinator?.navigateBack()
    }
    
}
