//
//  OneDayCareHospitalsViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/12/2024.
//

import Foundation
class OneDayCareHospitalsViewModel{    
    // MARK: - Proprties
    private var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    @Published var searchText = ""
    @Published var externalClinicId: Int?
    @Published var hospitalsData:[OneDayCarHosptalsData]?
    // MARK: - ViewModel init
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.externalClinicId = externalClinicId
        self.setupSearchSubscription()

    }
}

// MARK: - Fetching Pharmacy Cart
extension OneDayCareHospitalsViewModel {
   internal func getAllHospitals() {
       getHospitals(search: "")
    }
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.getHospitals(search: searchText)
            }
            .store(in: &cancellables)
    }
    private func getHospitals(search:String) {
        let router = APIRouter.fetchAllOneDayCareHospitals(search: search)
        apiClient.fetchData(from: router.url, as:  OneDayCarHosptalsResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch ExternalClinics: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] externalClinic in
                self?.hospitalsData = externalClinic.data
            })
            .store(in: &cancellables)
    }}
extension OneDayCareHospitalsViewModel{
   func navBack()
    {
        coordinator?.navigateBack()
    }
    func showHospitalProfile(hospitalId:Int){
        coordinator?.showHospitalProfile(hospitalId: hospitalId)
    }
    
}
