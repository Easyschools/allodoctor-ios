//
//  ExternalClinicHospitalsViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/11/2024.
//

import Foundation
class ExternalClinicHospitalsViewModel{  
    // MARK: - Proprties
    @Published var cities: [City] = []
     var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    @Published var externalClinicId: Int?
    @Published var externalClinicData:ExternalClinicData?
    // MARK: - ViewModel init
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), externalClinicId: Int) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.externalClinicId = externalClinicId
    }
}

// MARK: - Fetching Pharmacy Cart
extension ExternalClinicHospitalsViewModel {
   internal func getExternalClinicHospitals() {
       getExternalClinicHospitals(externalClinicId: externalClinicId ?? 0, search: "", districtId: "")
    }
    
    private func getExternalClinicHospitals(externalClinicId: Int,search:String,districtId:String) {
        let router = APIRouter.fetchExternalClinicData(externalClinicId: externalClinicId)
        apiClient.fetchData(from: router.url, as: ExternalClinicDataResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch ExternalClinics: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] externalClinic in
                self?.externalClinicData = externalClinic.data
            })
            .store(in: &cancellables)
    }}
extension ExternalClinicHospitalsViewModel{
   func navBack()
    {
        coordinator?.navigateBack()
    }
    func navToDoctors(){
        coordinator?.showDoctorSearch(specialityId:"", externalClinicServiceId: externalClinicData?.infoServices?[0].clinicInfo?.externalClinicServicesId?.toString() ?? "")
    }
}
extension ExternalClinicHospitalsViewModel{
    func getAllAreaOfResidence() {
        let router = APIRouter.fetchCities
        apiClient.fetchData(from: router.url, as: CityDataResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Failed to fetch Cities: \(error.localizedDescription)"
                }
            }, receiveValue: { citiesResponse in
                self.cities = citiesResponse.data ?? []
            })
            .store(in: &cancellables)
    }}
