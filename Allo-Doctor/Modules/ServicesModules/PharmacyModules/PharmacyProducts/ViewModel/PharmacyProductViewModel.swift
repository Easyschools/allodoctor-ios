//
//  PharmacyProductViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 22/10/2024.
//

import Foundation
import UIKit
// MARK: - PharmacyProductViewModel
class PharmacyProductViewModel {
    // MARK: - Private Properties
    private var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published private var errorMessage: String?
    private var apiClient = APIClient()
    @Published private var pharmacyId: Int?
    @Published var products: [Product]?
    @Published var grandTotalData: PharmacyCartData?
    @Published var categoryId: Int?
    @Published var searchText = ""
    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil,
         apiClient: APIClient = APIClient(),
         pharmacyId: Int,
         categoryId: Int? = nil) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.pharmacyId = pharmacyId
        self.categoryId = categoryId
        setupSearchSubscription()
    }

    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.getProducts(pharmacyId:self?.pharmacyId ?? 1, categoryIds:self?.categoryId ?? 0, search: searchText)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Product Fetching
extension PharmacyProductViewModel {
    // MARK: - Public Method
    func getProducts() {
        if categoryId == nil {
            getProducts(pharmacyId: pharmacyId ?? 1, categoryIds: categoryId ?? 0, search: "")
        }
        else{
            getProducts(pharmacyId: pharmacyId ?? 1, categoryIds: categoryId ?? 0, search: "")}
    }

    // MARK: - Private Method
    private func getProducts(pharmacyId: Int, categoryIds: Int?, search: String) {
        let router: APIRouter
        
        if let categoryId = categoryId {
            // Use categoryId if it's not nil
            router = APIRouter.fetchProducts(isPaginate: 15, categoryId: categoryId, pharmacyId: pharmacyId, search: search)
        } else {
            // Fetch all products if categoryId is nil
            router = APIRouter.fetchAllProducts(isPaginate: 15, pharmacyId: pharmacyId, search: search)
        }
        
        print(router.url)
        
        apiClient.fetchData(from: router.url, as: ProductResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch Pharmacy: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] products in
                self?.products = products.data
                print(self?.products?.count ?? 0)
            })
            .store(in: &cancellables)
    }

}

// MARK: - Cart Fetching
extension PharmacyProductViewModel {
    // MARK: - Public Method
    func getGrandTotal() {
        getGrandTotal(pharmacyId: pharmacyId ?? 1)
        print (pharmacyId ?? 0)
    }

    // MARK: - Private Method
    private func getGrandTotal(pharmacyId: Int) {
        let router = APIRouter.fetchPharmacyCart(pharmacyId: pharmacyId, couponId: "")
        apiClient.fetchData(from: router.url, as: PharmacyCartResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error cart: \(error)")
                    self?.errorMessage = "Failed to fetch cart: \(error.localizedDescription)"
                
                    print (error)
                }
            }, receiveValue: { [weak self] cart in
                if cart.data?.count ?? 0 > 0{
                    self?.grandTotalData = cart.data?[0]}
                else {
                    return
                }
            })
            .store(in: &cancellables)
    }
}

// MARK: - Navigation
extension PharmacyProductViewModel {
    // MARK: - Public Methods
    func productDetailsPresent(product: Product,viewController:UIViewController) {
        coordinator?.showProductDetailsViewController(pharmacyId: pharmacyId ?? 0, categoryId: categoryId ?? 0, product: product, viewControllerDelgate: viewController)
    }

    func navToPharmacyCart() {
        let safePharmacyId = pharmacyId ?? 1
        guard safePharmacyId > 0 else {
            // Handle invalid pharmacyId value
            return
        }
        coordinator?.showPharmacyCart(pharmacyId: safePharmacyId)
    }
    func navBack(){
        coordinator?.navigateBack()
    }
}

