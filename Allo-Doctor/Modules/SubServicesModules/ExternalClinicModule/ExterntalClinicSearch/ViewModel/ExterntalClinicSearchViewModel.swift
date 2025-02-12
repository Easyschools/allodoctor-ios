//
//  ExterntalClinicSearchViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/11/2024.
//

import Foundation
class ExterntalClinicSearchViewModel{
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var externalClinics: [ExternalClinicsData]?
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
    func clearSearchResults() {
        externalClinics = []
    }
    func getOperations(searchedText: String) {
        guard !isLoading else { return }
        isLoading = true
        
        let router = APIRouter.fetchExternalClinics(isPaginate: 10, search: searchedText)
        currentPageURL = router.url
        
        apiClient.fetchData(from: router.url, as: ExternalClinicResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch operations: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                self?.externalClinics = response.data
                self?.currentPageURL = response.links?.next.flatMap { URL(string: $0) }
            })
            .store(in: &cancellables)
    }
  
//
//    func loadMoreOperations() {
//        guard !isLoading, let nextURL = currentPageURL else { return }
//        isLoading = true
//        print (nextURL)
//        apiClient.fetchData(from: nextURL, as: OperationsResponse.self)
//            .sink(receiveCompletion: { [weak self] completion in
//                self?.isLoading = false
//                if case .failure(let error) = completion {
//                    self?.errorMessage = "Failed to fetch more operations: \(error.localizedDescription)"
//                }
//            }, receiveValue: { [weak self] response in
//                if var currentOperations = self?.externalClinics {
//                    currentOperations.append(contentsOf: response.data ?? [])
//                    self?.externalClinics = currentOperations
//                }
//                self?.currentPageURL = response.links?.next.flatMap { URL(string: $0) }
//            })
//            .store(in: &cancellables)
//    }
}
extension ExterntalClinicSearchViewModel {
    internal func navToClinicHospitals (externalClinicId:Int){
        coordinator?.showExternalClinicHospitals(externalClinicId: externalClinicId)
    }
    func navBack(){
        coordinator?.navigateBack()
    }
}
