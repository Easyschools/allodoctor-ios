//
//  PharmacyGlobalSearchViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/11/2024.
//

import Foundation
class PharmacyGlobalSearchViewModel{    
    // MARK: - InitViewModel + Proprties
    var coordinator: HomeCoordinatorContact?
   private var cancellables = Set<AnyCancellable>()
   @Published var errorMessage: String?
   @Published var searchText: String = ""
   private var apiClient = APIClient()
   @Published var pharmacies: [Pharmacy]?
   @Published var products: [Product]?
   init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
       self.coordinator = coordinator
       self.apiClient = apiClient
   }

}
// MARK: - ApiCalls (Get All pharmacies)
extension PharmacyGlobalSearchViewModel{
 func setupSearchSubscription() {
     $searchText
         .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
         .removeDuplicates()
         .sink { [weak self] searchText in
             print("Search Text Updated: \(searchText)")
             self?.getProducts(search: searchText)
             self?.getPharmacies(lat: "", long: "", search: searchText)
         }
         .store(in: &cancellables)
}
 
    private func getPharmacies(lat:String,long:String,search:String){
        let encodedText = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let router = APIRouter.fetchPharmacies(isPaginate:2,lat:lat ,long:long, search: encodedText)
   apiClient.fetchData(from: router.url, as: PharmaciesResponse.self)
       .sink(receiveCompletion: { [weak self] completion in
           switch completion {
           case .finished:
               break
           case .failure(let error):
               print("Error: \(error)")
               self?.errorMessage = "Failed to fetch Pharmicies: \(error.localizedDescription)"}
       }, receiveValue: { [weak self]  pharmacyResponse in
           self?.pharmacies = pharmacyResponse.data
           print(pharmacyResponse.data.count)
           print("suiii")
       }).store(in: &cancellables)
   }
    // MARK: - Private Method
    private func getProducts(search:String) {
        let encodedText = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let router = APIRouter.fetchProductsGlobalSearch(isPaginate: 2, search: encodedText)
        print(router.url)
        apiClient.fetchData(from: router.url, as: ProductResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch Pharamcy: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] products in
                self?.products = products.data
            })
            .store(in: &cancellables)
    }
}
extension PharmacyGlobalSearchViewModel {
   func navigationToCategory(pharmacyId:Int){
       coordinator?.showPharmacyCategory(pharmacyId: pharmacyId)
   }
   func navigationBack(){
       coordinator?.navigateBack()
   }
}
