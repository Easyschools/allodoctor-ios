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
    
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    private var apiClient = APIClient()
    private let imageARR = [UIImage(named: "offers"), UIImage(named: "offers"), UIImage(named: "offers")].compactMap { $0 }
    private var timer: AnyCancellable?
    private let autoScrollInterval: TimeInterval = 7
    
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.images = imageARR
    }
    
    func startAutoScroll() {
        stopAutoScroll() // Ensure any existing timer is cancelled
        guard imageARR.count > 1 else { return }
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
        currentImageIndex = (currentImageIndex + 1) % imageARR.count
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
 
}










