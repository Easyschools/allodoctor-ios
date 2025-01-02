//
//  PharmacyCartViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/10/2024.
//
import UIKit

class PharmacyCartViewModel {
    // MARK: - Proprties
    private var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    @Published var pharmacyId: Int?
    @Published var pharmacyCart: PharmacyCartData?
    @Published var totalPrice: Double = 0.0
    @Published var categoryId: Int?
    @Published var quantity: Int? = 1
    // MARK: - ViewModel init
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), pharmacyId: Int) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.pharmacyId = pharmacyId
    }
}

// MARK: - Fetching Pharmacy Cart
extension PharmacyCartViewModel {
    func getPharmacyCart() {
        getPharmacyCart(pharmacyId: pharmacyId ?? 0)
    }
    
    private func getPharmacyCart(pharmacyId: Int) {
        let router = APIRouter.fetchPharmacyCart(pharmacyId: pharmacyId)
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
                self?.pharmacyCart = cart.data[0]
            })
            .store(in: &cancellables)
    }
}

// MARK: - Presentation Logic
extension PharmacyCartViewModel {
    internal func productDetailsPresent(product: Product) {
        coordinator?.showProductDetailsViewController(pharmacyId: pharmacyId ?? 0, categoryId: categoryId ?? 0, product: product)
    }
    
    internal func dismissView(viewController: UIViewController) {
        coordinator?.dismissPresnetiontabBarNav(viewController)
    }
}

// MARK: - Cart Item Quantity Update
extension PharmacyCartViewModel {
    func updateItemQuantity(itemId: Int, newQuantity: Int) {
        // Update local data
        if let itemIndex = pharmacyCart?.items.firstIndex(where: { $0.id == itemId }) {
            pharmacyCart?.items[itemIndex].quantity = newQuantity
            updateCartItemQuantitiy(newQuaintity: newQuantity, itemIndex: itemIndex)
            recalculateTotalQuantity()
        }
    }
    
    private func recalculateTotalQuantity() {
        let newTotalQuantity = pharmacyCart?.items.reduce(0) { $0 + $1.quantity } ?? 0
        pharmacyCart?.totalQuantity = newTotalQuantity
    }
    
   private func updateCartItemQuantitiy(newQuaintity:Int,itemIndex:Int) {
          let product = pharmacyCart?.items[itemIndex]
          let updateCartRequest = AddProductToCart(
              pharmacy_id: String(pharmacyCart?.pharmacyId ?? 1),
              category_id: String(product?.category.id ?? 1),
              medication_pharmacy_id: String(product?.medicationPharmacy ?? 1),
              medication_id:String(product?.medication?.id ?? 1), quantity: String(newQuaintity)
          )
          updateCartItemQuantitiy(request: updateCartRequest)
          print(updateCartRequest)
          
      }
    
    private func updateCartItemQuantitiy(request: AddProductToCart) {
        let router = APIRouter.addToCart(request)
        apiClient.postData(to: router.url, body: request, as: AddToCartResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }, receiveValue: { response in
                print("Response: \(response)")
            })
            .store(in: &cancellables)
    }

}
extension PharmacyCartViewModel{
    func dissmissView(viewController: UIViewController) {
        coordinator?.dismissPresnetiontabBarNav(viewController)
    }
    func navToCheckOut(){
        coordinator?.showOrdersScreens()
    }
}
