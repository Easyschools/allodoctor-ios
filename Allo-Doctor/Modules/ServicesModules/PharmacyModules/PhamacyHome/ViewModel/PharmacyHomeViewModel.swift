//
//  PharmacyHomeViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/10/2024.
//

import Foundation

class PharmacyHomeViewModel{
    // MARK: - InitViewModel + Proprties
     var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    @Published var pharmacies: [Pharmacy]?
    private var lat : String?
    private var long : String?
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(),lat:String,long:String) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.lat = lat
        self.long = long
    }

}
// MARK: - ApiCalls (Get All pharmacies)
extension PharmacyHomeViewModel{
    func getPharmacies(){
        getPharmacies(lat: lat ?? "", long: long ?? "")
    }
    func getPharmacies(lat:String,long:String){
    let router = APIRouter.fetchPharmacies(isPaginate: 3,lat:lat ,long:long, search: "")
        print (router.url)
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
            let dis = self?.pharmacies?.first?.distance

          
            
        }).store(in: &cancellables)
    }
}
extension PharmacyHomeViewModel {
    func navigationToCategory(pharmacyId:Int){
        coordinator?.showPharmacyCategory(pharmacyId: pharmacyId)
        print ((pharmacyId).toString()+"pharmacyid")
    }
    func navigationBack(){
        coordinator?.navigateBack()
    }
    func navToSearchScreen(){
        coordinator?.showPharmacyGlobalSearch()
    }
    func  navToshowPharmaciesCartViewController() {
        coordinator?.showPharmaciesCartViewController()
    }
}
