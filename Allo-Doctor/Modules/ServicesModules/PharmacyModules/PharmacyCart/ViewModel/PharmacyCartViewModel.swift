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
        let router = APIRouter.fetchPharmacyCart(pharmacyId: pharmacyId, couponId: "")
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
    func deleteProduct(productId:Int){
        let router = APIRouter.deleteProductid(id: productId, pharmacyId: pharmacyId ?? 0)
        print(router.url)
        apiClient.deleteData(from: router.url, as: DeleteResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    
                    print("Delete request completed successfully.")
                case .failure(let error):
       
                    print("Error during delete request: \(error)")
                }
            }, receiveValue: { response in
                print("Message: \(response.Message)")
                print("Data: \(response.data)")
            })
        .store(in: &cancellables)}
}

// MARK: - Presentation Logic
extension PharmacyCartViewModel {
    internal func productDetailsPresent(product: Product,uiviewconutoller:UIViewController) {
        coordinator?.showProductDetailsViewController(pharmacyId: pharmacyId ?? 0, categoryId: categoryId ?? 0, product: product, viewControllerDelgate: uiviewconutoller)
    }
    
    internal func dismissView(viewController: UIViewController) {
        coordinator?.dismissPresnetiontabBarNav(viewController)
    }
}

// MARK: - Cart Item Quantity Update
extension PharmacyCartViewModel {
    func updateItemQuantity(itemId: Int, newQuantity: Int) {
        // Update local data
        if let itemIndex = pharmacyCart?.items?.firstIndex(where: { $0.id == itemId }) {
            self.pharmacyCart?.items?[itemIndex].quantity = newQuantity
            updateCartItemQuantitiy(newQuaintity: newQuantity, itemIndex: itemIndex)
            recalculateTotalQuantity()
            recalculateTotalPrice()
        }
    }
    

    
    private func updateCartItemQuantitiy(newQuaintity: Int, itemIndex: Int) {
        let product = pharmacyCart?.items?[itemIndex]
        let updateCartRequest = AddProductToCart(
            pharmacy_id: String(pharmacyCart?.pharmacyId ?? 1),
            category_id: String(product?.category?.id ?? 1),
            medication_id: String(product?.medication?.id ?? 1),
            quantity: String(newQuaintity)
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
        coordinator?.showOrdersScreens(pharmacyId: pharmacyId ?? 0)
    }
}
extension PharmacyCartViewModel {
    func deleteProduct(productId: Int, completion: @escaping (Bool) -> Void) {
        let router = APIRouter.deleteProductid(id: productId, pharmacyId: pharmacyId ?? 0)
        print("Delete URL: \(router.url)")
        
        apiClient.deleteData(from: router.url, as: DeleteResponse.self)
            .sink(receiveCompletion: { [weak self] networkCompletion in
                switch networkCompletion {
                case .finished:
                    print("Delete request completed successfully.")
                case .failure(let error):
                    print("Error during delete request: \(error)")
                    completion(false)
                }
            }, receiveValue: { [weak self] response in
                print("Delete Response - Message: \(response.Message)")
                print("Delete Response - Data: \(response.data)")
                
                // Remove the item from local data
                self?.removeItemFromCart(productId: productId)
                
                // Recalculate totals
                self?.recalculateTotalQuantity()
                self?.recalculateTotalPrice()
                
                completion(true)
            })
            .store(in: &cancellables)
    }
    
    private func removeItemFromCart(productId: Int) {
        pharmacyCart?.items?.removeAll { $0.id == productId }
    }
    
    // Make sure these methods are accessible (remove private if needed)
    func recalculateTotalQuantity() {
        let newTotalQuantity = pharmacyCart?.items?.reduce(0) { $0 + $1.quantity } ?? 0
        pharmacyCart?.totalQuantity = newTotalQuantity
    }
    
    func recalculateTotalPrice() {
        let newTotalPrice = pharmacyCart?.items?.reduce(0.0) { total, item in
            let itemPrice = Double(item.medicationPharmacy?.price ?? "0.0") ?? 0.0
            return total + (itemPrice * Double(item.quantity))
        } ?? 0.0
        pharmacyCart?.totalPrice = String(format: "%.2f", newTotalPrice)
    }
}
