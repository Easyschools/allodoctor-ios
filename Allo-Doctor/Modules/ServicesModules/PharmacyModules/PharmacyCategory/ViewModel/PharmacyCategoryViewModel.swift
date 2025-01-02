//
//  PharmacyCategoryViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 22/10/2024.
//

import Foundation
class PharmacyCategoryViewModel{
    private var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    @Published var pharmacyId: Int?
    @Published var pharmacy: Pharmacy?
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(),pharmacyId:Int) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.pharmacyId = pharmacyId
    }
}

extension PharmacyCategoryViewModel{
    func getPharmacy(){
     guard let pharmacyId = pharmacyId else {
         return
     }
     getPharmacy(id: pharmacyId)
     

 }
 private func getPharmacy(id:Int){
    let router = APIRouter.fetchPharmacy(id: id)
    apiClient.fetchData(from: router.url, as: PharmacyResponse.self)
        .sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("Error: \(error)")
                self?.errorMessage = "Failed to fetch Pharamcy: \(error.localizedDescription)"}
        }, receiveValue: { [weak self]  pharmacyResponse in
            
            self?.pharmacy = pharmacyResponse.data
            print(self?.pharmacy?.categories.count ?? 0)
            
        }).store(in: &cancellables)
    }
}

extension PharmacyCategoryViewModel{
     func navigateToProducts(pharmacyId:Int, categoryId: Int){
       coordinator?.showPharmacyProducts(pharmacyId: pharmacyId, categoryId: categoryId)
   }
}

