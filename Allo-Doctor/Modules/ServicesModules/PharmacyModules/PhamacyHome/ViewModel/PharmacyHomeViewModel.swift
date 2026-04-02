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
    @Published var banners: [Banner]?
    @Published var currentBannerIndex: Int = 0
    private var bannerTimer: AnyCancellable?
    private let autoScrollInterval: TimeInterval = 7
    private var lat : String?
    private var long : String?
    private var currentPage = 1
    private var lastPage = 1
    @Published var isLoading = false
    private var pharmacyCancellable: AnyCancellable?
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
        // Cancel any in-flight pharmacy request to prevent race conditions
        pharmacyCancellable?.cancel()
        self.lat = lat
        self.long = long
        self.currentPage = 1
        self.lastPage = 1
        self.isLoading = false
        let router = APIRouter.fetchPharmacies(isPaginate: 10, lat: lat, long: long, search: "", page: 1)
        pharmacyCancellable = apiClient.fetchData(from: router.url, as: PharmaciesResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch Pharmicies: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self]  pharmacyResponse in
                self?.pharmacies = pharmacyResponse.data
                self?.currentPage = pharmacyResponse.meta?.currentPage ?? 1
                self?.lastPage = pharmacyResponse.meta?.lastPage ?? 1
            })
    }
    func loadMorePharmacies() {
        guard !isLoading, currentPage < lastPage else { return }
        isLoading = true
        let nextPage = currentPage + 1
        let router = APIRouter.fetchPharmacies(isPaginate: 10, lat: lat ?? "", long: long ?? "", search: "", page: nextPage)
        pharmacyCancellable = apiClient.fetchData(from: router.url, as: PharmaciesResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch more pharmacies: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] pharmacyResponse in
                self?.pharmacies?.append(contentsOf: pharmacyResponse.data)
                self?.currentPage = pharmacyResponse.meta?.currentPage ?? nextPage
                self?.lastPage = pharmacyResponse.meta?.lastPage ?? nextPage
            })
    }
}
// MARK: - Banner/Offers API
extension PharmacyHomeViewModel {
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
    func showSelectLocationMap(){
        coordinator?.showMapView(screenType: .pharmacyHome)
    }
    func  navToshowPharmaciesCartViewController() {
        coordinator?.showPharmaciesCartViewController()
    }
    func navToPharmacyFromBanner(pharmacyId: Int) {
        coordinator?.showPharmacyCategory(pharmacyId: pharmacyId)
    }
}
