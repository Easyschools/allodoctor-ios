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
    var infoServiceId: Int?

    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), infoServiceId: Int? = nil) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.infoServiceId = infoServiceId
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
        
        let router = APIRouter.fetchOperations(isPaginate: 10, search: searchedText, infoServiceId: infoServiceId)
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
    internal func navToOperationHospitals(operationID: Int) {
        if let infoServiceId = infoServiceId {
            // Try to extract data from already-fetched operations list first
            if let operation = operations?.first(where: { $0.id == operationID }),
               let listInfoService = operation.infoServices?.first(where: { $0.infoService?.id == infoServiceId }),
               let operationServiceId = listInfoService.operationInfo?.operationServiceId {
                // Build wrapper from list data and navigate directly to booking
                let wrapper = OperationInfoServiceWrapper(
                    operationServiceID: operationServiceId,
                    price: listInfoService.operationInfo?.price,
                    infoService: nil
                )
                coordinator?.showOperationBooking(operationServiceId: operationServiceId, date: "", hospitalData: wrapper, infoServiceId: infoServiceId)
            } else {
                // Fallback: fetch operation data via /operation/get then go to booking
                fetchOperationAndNavigateDirectly(operationID: operationID, infoServiceId: infoServiceId)
            }
        } else {
            coordinator?.showOpertionHospitals(operationID: operationID, infoServiceId: nil)
        }
    }

    private func fetchOperationAndNavigateDirectly(operationID: Int, infoServiceId: Int) {
        let router = APIRouter.fetchOperationData(operationId: operationID, search: "", districtId: "")
        apiClient.fetchData(from: router.url, as: OperationDataResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch operation data: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                let infoServices = response.data?.infoServices ?? []
                guard let hospital = infoServices.first(where: { $0.infoService?.id == infoServiceId }),
                      let operationServiceId = hospital.operationServiceID else {
                    self?.coordinator?.showOpertionHospitals(operationID: operationID, infoServiceId: infoServiceId)
                    return
                }
                self?.coordinator?.showOperationBooking(operationServiceId: operationServiceId, date: "", hospitalData: hospital, infoServiceId: infoServiceId)
            })
            .store(in: &cancellables)
    }

    func navBack(){
        coordinator?.navigateBack()
    }
}
