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
    @Published var categoryId:Int?
    
//    @Published var productId:Int?
    
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(),pharmacyId:Int,categoryId:Int,product:Product) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.pharmacyId = pharmacyId
        self.categoryId = categoryId
       
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
                        self?.errorMessage = "Failed to fetch Pharamcy: \(error.localizedDescription)"}
                }, receiveValue: { [weak self]  pharmacies in
                    
                }).store(in: &cancellables)
            
        }
    }

