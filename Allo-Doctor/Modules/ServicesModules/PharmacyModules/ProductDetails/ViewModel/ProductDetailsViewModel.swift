//
//  ProductDetailsViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 25/10/2024.
//

import Foundation
import UIKit
class ProductDetailsViewModel{
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    @Published var pharmacyId: Int?
    @Published var product: Product?
    @Published var categoryId:Int?
    @Published var quantity: Int = 1
    weak var delegate: addToCartTapped?
//    @Published var productId:Int?
    
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(),pharmacyId:Int,categoryId:Int,product:Product,uiviewcontrollerDelegate:UIViewController) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.pharmacyId = pharmacyId
        self.categoryId = categoryId
        self.product = product
        self.delegate = uiviewcontrollerDelegate as? any addToCartTapped
    }
}

extension ProductDetailsViewModel{
    func addTocart() {
        let addToCartRequest = AddProductToCart(
            pharmacy_id: String(pharmacyId ?? 0),
            category_id: String(product?.medicationPharmacies?[0].categoryId ?? 1),
            medication_id: String(product?.id ?? 1),
            quantity: String(quantity)
        )
       
        addToCart(request: addToCartRequest)
      print(addToCartRequest)
        
    }
    
   private func addToCart(request: AddProductToCart) {
   
        let router = APIRouter.addToCart(request)
        apiClient.postData(to: router.url, body: request, as: AddToCartResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.buttontapped()
                    break
                case .failure(let error):
                    print (error)
                  break
                }
            }, receiveValue: { response in
                print("Response: \(response)")
            })
            .store(in: &cancellables)
        
    }
}
extension ProductDetailsViewModel{
   func dismissView(){
       coordinator?.dismiss(completion: {
           return
       })
    }
    func buttontapped (){
        delegate?.didTapButton()
    }
}
