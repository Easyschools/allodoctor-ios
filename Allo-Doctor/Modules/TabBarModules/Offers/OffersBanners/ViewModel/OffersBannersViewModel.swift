//
//  OffersBannersViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/12/2024.
//

import Foundation
class  OffersBannersViewModel{
    @Published var banners: [Banner]?
    var coordinator: HomeCoordinatorContact?
    var screenType : String?
    var url : URL?
    private var apiClient :APIClient?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient(),screenType:String) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.screenType = screenType
    }
}
extension OffersBannersViewModel{
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
            })
            .store(in: &cancellables)
    }
}
extension OffersBannersViewModel{
    func navToDoctor(id:Int) {
        coordinator?.showDoctorProfile(doctorID:id.toString(), doctorPlace: .doctorClinics)
    }
    func navToPharmacy(id:Int){
        coordinator?.showPharmacyCategory(pharmacyId:id)
    }
}
