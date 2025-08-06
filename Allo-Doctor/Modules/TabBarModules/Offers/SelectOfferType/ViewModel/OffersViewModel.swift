//
//  OffersViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/09/2024.
//

import Foundation
class OffersViewModel{  
    @Published var labs: [LabInfo]?
    @Published var scans: [LabAndScans]?
    @Published var cities: [City] = []
    @Published var banners: [Banner]?
    var coordinator: HomeCoordinatorContact?
    var screenType : String?
    var url : URL?
    private var apiClient :APIClient?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
}
extension OffersViewModel{
    func getAllOffers() {
        let router = APIRouter.fetchOffers(offerType:screenType ?? "")
        apiClient?.fetchData(from: router.url, as: BannerResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Failed to fetch Offers: \(error.localizedDescription)"
                }
            }, receiveValue: { banners in
                self.banners = banners.data ?? []
                print(self.banners?.count)
            })
            .store(in: &cancellables)
    }
}
extension OffersViewModel{
    func navToDoctor(id:Int) {
        coordinator?.showDoctorProfile(doctorID:id.toString(), doctorPlace: .doctorClinics)
    }
    func navToPharmacy(id:Int){
        coordinator?.showPharmacyCategory(pharmacyId:id)
    }
    func navToOffers(screenType:String){
        coordinator?.showOffersBanners(screenType: screenType)
    }
}
