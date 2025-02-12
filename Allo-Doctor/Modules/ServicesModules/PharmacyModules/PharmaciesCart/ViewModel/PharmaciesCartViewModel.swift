//
//  PharmaciesCartViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 29/10/2024.
//

import Foundation
class PharmaciesCartViewModel{    
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    @Published var pharmacyId: Int?
    @Published var pharmacies: [Cart]?
    
//    @Published var productId:Int?
    
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
       
    }}
extension PharmaciesCartViewModel{
    func getPharmaciesCart(){
        let router = APIRouter.fetchBasketPharmacies
            apiClient.fetchData(from: router.url, as: CartResponse.self)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error: \(error)")
                        self?.errorMessage = "Failed to fetch Pharmacies: \(error.localizedDescription)"}
                }, receiveValue: { [weak self]  pharmacies in
                    self?.pharmacies = pharmacies.data
                }).store(in: &cancellables)
            
        }
    }

extension PharmaciesCartViewModel{
    func navBack() {
        coordinator?.navigateBack()
    }
    func navToPharmacyCart(pharmacyId:Int) {
     
        coordinator?.showPharmacyCart(pharmacyId: pharmacyId)
    }
}
