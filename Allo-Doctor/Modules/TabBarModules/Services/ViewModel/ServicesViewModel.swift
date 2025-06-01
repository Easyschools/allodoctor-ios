//
//  ServicesViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/09/2024.
//

import UIKit

class ServicesViewModel {
    @Published var currentImageIndex: Int = 0
    @Published var images: [UIImage] = []
    @Published var services: [Service] = []
    @Published var errorMessage: String?
    @Published var banners: [Banner]?
    private var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    private var apiClient = APIClient()
    private var timer: AnyCancellable?
    private let autoScrollInterval: TimeInterval = 7
    
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
    
    func startAutoScroll() {
        stopAutoScroll() // Ensure any existing timer is cancelled
        guard banners?.count ?? 0 > 1 else { return }
        timer = Timer.publish(every: autoScrollInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.scrollToNextImage()
            }
    }
    
    func stopAutoScroll() {
        timer?.cancel()
        timer = nil
    }
    
    private func scrollToNextImage() {
        currentImageIndex = (currentImageIndex + 1) % (banners?.count ?? 0)
    }
    
    func updateCurrentIndex(to index: Int) {
        currentImageIndex = index
    }
    
    func fetchServices() {
        let router = APIRouter.fetchServices(isPaginate: 15)
        apiClient.fetchData(from: router.url, as: ServiceResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                   break
                case .failure(let error):
                    self.errorMessage = "Failed to fetch Services: \(error.localizedDescription)"
                }
            }, receiveValue: { serviceResponse in
                self.services = serviceResponse.data
            })
            .store(in: &cancellables)
        
    }
   
}


extension ServicesViewModel{
    func navToSubServiceScreen(){
        print("called")
        coordinator?.showSubServicesVC()
    }
    func navToSearchScreen() {
        coordinator?.showSearchScreen()
       
    }
    func navtoclinicsSearch (){
        coordinator?.showClinicsSearch()
    }
    func navToLabsAndScanSearchScreen(screenId:String){
       coordinator?.navToLabsAndScanSearchScreen(type: screenId)
    }
    func navToPharmacyHome(){
        coordinator?.showPharmacyHome(lat: "", long: "")
  
    }
    func navToHomeVisit(){
        coordinator?.showHomeVisit()
    }
    func navTohomeNursing(){
        coordinator?.showHomeNursing()
    }
    func showEmergency(){
        coordinator?.showEmergency()
    }
    func showChatwithUs(){
        coordinator?.showSelectChatTypeViewController()
//        coordinator?.showChatViewController()
    }
}
extension ServicesViewModel{
    func getAllOffers() {
        let router = APIRouter.fetchBanners
        apiClient.fetchData(from: router.url, as: BannerResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Failed to fetch Offers: \(error.localizedDescription)"
                }
            }, receiveValue: { banners in
                self.banners = banners.data ?? []
            })
            .store(in: &cancellables)
    }
}









