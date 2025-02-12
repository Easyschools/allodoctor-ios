//
//  PharmacyOrderViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 05/11/2024.
//

import Foundation
import Combine
import UIKit

class PharmacyOrderViewModel {
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    @Published var pharmacyId: Int?
    @Published var totalPrice: Double = 0.0
    @Published var remiderType: String?
    private var apiClient: APIClient
    @Published var pharmacyCart: PharmacyCartData?
    @Published var orderCheck:OrderStatusCheck?
    @Published var paymentType : String?
    @Published var Status: BookingStatus?
    @Published var coupounStatus: BookingStatus?
    @Published var message: Bool?
    var adressId: Int?
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), pharmacyId: Int) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.pharmacyId = pharmacyId
    }
}

extension PharmacyOrderViewModel {
    func createOrder() {
        let confirmOrderRequest = ConfirmOrderBody(
            payment_type: paymentType ?? "cash",
            address_id: 1,
            pharmacy_id: pharmacyId ?? 0 ,
            address_user_id: adressId ?? 0,
            order_status_id: 1, reminder_type: remiderType ?? ""
        )
        createOrder(request: confirmOrderRequest)
        print(confirmOrderRequest)
    }
    
    private func createOrder(request: ConfirmOrderBody) {
        NetworkService.shared.postData(endpoint: "admin/order/create", data: request) { result in
            switch result {
            case .success(let data):
                // Attempt to decode the data into OrderResponse
                do {
                    let decoder = JSONDecoder()
                    let order = try decoder.decode(OrderResponseData.self, from: data)
                    
                    self.handleSuccess(order.order)
                    if self.paymentType == "paymob"{self.urlHandle(url: order.payment_url ?? "",orderId:order.order.id ?? 0)}
                    else {
                        self.Status = .success
                    }
                    
                } catch {
                    self.errorMessage = "Failed to parse server response."
                    print("Decoding error: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                self.handleError(error)
            }
        }
    }

    
    private func handleSuccess(_ order: OrderResponse) {
     
        print("Order created successfully: \(order)")

    }
    private func urlHandle(url:String,orderId:Int){
        coordinator?.showPaymentWebKit(url:url, Delegete: self, orderId: orderId)
    }
    private func handleError(_ error: NetworkError) {
        switch error {
        case .serverError(let message):
            // Handle Laravel-style errors
            errorMessage = message
            print("Server error: \(message)")
            
        case .unauthorized:
            errorMessage = "Unauthorized: Please log in again."
            print("Unauthorized access.")
            
        case .invalidData:
            errorMessage = "Failed to parse server response."
            print("Invalid data received from server.")
            
        case .networkError(let message):
            errorMessage = "Network error: \(message)"
            print("Network error: \(message)")
    
        case .invalidResponse:
            errorMessage = "Unexpected server response."
            print("Invalid response from server.")
            
        case .invalidImage:
            break
        }
        
      
     
    }
}


// MARK: - Fetching Pharmacy Cart
extension PharmacyOrderViewModel {
func getPharmacyCart() {
    getPharmacyCart(pharmacyId: pharmacyId ?? 0)
}

 func getPharmacyCart(pharmacyId: Int) {
    let router = APIRouter.fetchPharmacyCart(pharmacyId: pharmacyId, couponId:"")
     print(router.url)
    apiClient.fetchData(from: router.url, as: PharmacyCartResponse.self)
        .sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("Error: \(error)")
                self?.errorMessage = "Failed to fetch cart: \(error.localizedDescription)"
                
                
            }
        }, receiveValue: { [weak self] cart in
            guard let strongSelf = self, let cartData = cart.data, !cartData.isEmpty else {
                return
            }
            strongSelf.pharmacyCart = cartData[0]
           
        })
        .store(in: &cancellables)
}
    func applyCoupoun(pharmacyId: Int,coupounId:String) {
       let router = APIRouter.fetchPharmacyCart(pharmacyId: pharmacyId, couponId:coupounId)
        print(router.url)
       apiClient.fetchData(from: router.url, as: PharmacyCartResponse.self)
           .sink(receiveCompletion: { [weak self] completion in
               switch completion {
               case .finished:
                   break
               case .failure(let error):
                   print("Error: \(error)")
                   self?.errorMessage = "Failed to fetch cart: \(error.localizedDescription)"
                   self?.handleCoupoun(sucess:false)
                   self?.coupounStatus = .failure
                   
               }
           }, receiveValue: { [weak self] cart in
               guard let strongSelf = self, let cartData = cart.data, !cartData.isEmpty else {
                   return
               }
               strongSelf.pharmacyCart = cartData[0]
               self?.coupounStatus = .success
               self?.handleCoupoun(sucess:true)
           })
           .store(in: &cancellables)
   }
func getStatusCheck(orderID:Int) {
        let router = APIRouter.fetchOrderStatus(orderId:orderID)
        apiClient.fetchData(from: router.url, as: OrderStatusResponse.self)
    
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch cart: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] data in
                self?.orderCheck = data.data.orderStatus
            })
            .store(in: &cancellables)
    }
}
extension PharmacyOrderViewModel {
    func   navBack(){
        coordinator?.navigationBack()
    }
    func showAddressAdd(){
        coordinator?.showMapView(screenType: .userAddress)
    }
}
extension PharmacyOrderViewModel:PaymentTaskHandling {
    func handlePaymentCompletion(orderId: Int) {
        getStatusCheck(orderID: orderId)
    }
    func handleCoupoun(sucess:Bool){
        DispatchQueue.main.async {
            if sucess == false{
                _ = Snackbar(
                    message: AppLocalizedKeys.InvalidCoupon.localized,
                    backgroundColor: UIColor.redE5001D,
                    textColor: UIColor.white,
                    duration: 3.0
                )
            }
           else  {
                _ = Snackbar(
                    message: AppLocalizedKeys.CouponAppliedsuccessfully.localized,
                    backgroundColor: UIColor.green4D932C,
                    textColor: UIColor.white,
                    duration: 3.0
                )
            }
          
        }
        
    }
}

