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
    @Published var favData: [FavData]?
    @Published var banners: [Banner]?
    @Published var currentBannerIndex: Int = 0
    private var bannerTimer: AnyCancellable?
    private let autoScrollInterval: TimeInterval = 7
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
    func addToFav() {
        let favRequest = FavouritesModel(favoritable_entity: "pharmacy", favoritable_id: pharmacyId ?? 0
        )
        print(favRequest)
        addToFav(request: favRequest)
        
    }
    func addToFav(request: FavouritesModel) {
        let router = APIRouter.addToFavoutites
        apiClient.postData(to: router.url, body: request, as: FavouritesModelResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                 
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    
                }
            }, receiveValue: { response in
                print("Registration Response: \(response)")
                
            })
            .store(in: &cancellables)
        
    }
    func fetchPharmacyFavourite() {
        let router = APIRouter.isFavourite(entity:"pharmacy", id: pharmacyId ?? 0)
        apiClient.fetchData(from: router.url, as: DoctorsFav.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                }
            }, receiveValue: { [weak self] doctorResponse in
                self?.favData = doctorResponse.data
                
            }).store(in: &cancellables)
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
            
        }).store(in: &cancellables)
    }
}

extension PharmacyCategoryViewModel{
     func navigateToProducts(pharmacyId:Int, categoryId: Int){
       coordinator?.showPharmacyProducts(pharmacyId: pharmacyId, categoryId: categoryId)
   }
    func  showUploadPrescription() {
        coordinator?.showUploadPharmacyPrescription(pharmacyId: pharmacyId ?? 0)
    }
    func navToPharmacyCart() {
        coordinator?.showPharmacyCart(pharmacyId: pharmacyId ?? 0)
    }
    func navToProductsSerarh(){
        coordinator?.showPharmacyProducts(pharmacyId: pharmacyId ?? 0, categoryId: nil)
    }
    func navBack(){
        coordinator?.navigateBack()
    }
    func navToPharmacyFromBanner(pharmacyId: Int) {
        coordinator?.showPharmacyCategory(pharmacyId: pharmacyId)
    }
}
// MARK: - Banner/Offers API
extension PharmacyCategoryViewModel {
    func getPharmacyOffers() {
        let router = APIRouter.fetchOffers(offerType: "pharmacy")
        apiClient.fetchData(from: router.url, as: BannerResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching pharmacy offers: \(error)")
                    self?.errorMessage = "Failed to fetch Pharmacy Offers: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                self?.banners = response.data ?? []
            })
            .store(in: &cancellables)
    }

    func startBannerAutoScroll() {
        stopBannerAutoScroll()
        guard banners?.count ?? 0 > 1 else { return }
        bannerTimer = Timer.publish(every: autoScrollInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.scrollToNextBanner()
            }
    }

    func stopBannerAutoScroll() {
        bannerTimer?.cancel()
        bannerTimer = nil
    }

    private func scrollToNextBanner() {
        currentBannerIndex = (currentBannerIndex + 1) % (banners?.count ?? 1)
    }

    func updateCurrentBannerIndex(to index: Int) {
        currentBannerIndex = index
    }
}

