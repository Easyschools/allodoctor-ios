//
//  PharmacyOrderViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 05/11/2024.
//

import Foundation
class PharmacyOrderViewModel{
     var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    @Published var pharmacyId: Int?
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(),pharmacyId:Int) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.pharmacyId = pharmacyId
    }
}
extension PharmacyOrderViewModel{
    func createOrder(){
       
            let confirmOrderRequest = ConfirmOrderBody(
                payment_type_id: pharmacyId ?? 1 ,
                address_id: 1 ,
                pharmacy_id: 1, address_user_id: 1
            )
            createOrder(request:confirmOrderRequest)
        }
    private func createOrder(request: ConfirmOrderBody) {
         let router = APIRouter.orderConfirm(request)
         apiClient.postData(to: router.url, body: request, as: ConfirmOrderBodyResponse.self)
             .sink(receiveCompletion: { completion in
                 switch completion {
                 case .finished:
                     break
                 case .failure(let error):
                   return
                 }
             }, receiveValue: { [weak self] response in
                 self?.handleResponse(response)
             })
             .store(in: &cancellables)
     }

     private func handleResponse(_ response: ConfirmOrderBodyResponse) {
         if response.statusCode == 200 {
            
         } else {
           
         }
     }
    }

