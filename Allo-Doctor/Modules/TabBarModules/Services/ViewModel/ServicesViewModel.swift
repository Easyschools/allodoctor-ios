//
//  ServicesViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/09/2024.
//

import Foundation
import Combine
import UIKit
class ServicesViewModel{
    @Published var currentImageIndex: Int = 0
    @Published var images: [UIImage] = []
    @Published var services: [Service] = []
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
//    let router = APIRouter.fetchServices(isPaginate: 15)
    private let apiClient = APIClient()
    private let imageARR = [UIImage(named: "offers"),UIImage(named: "offers"),UIImage(named: "offers")].compactMap{$0}
    private var timer: AnyCancellable?
    private var currentIndex: Int = 0
    private let autoScrollInterval: TimeInterval = 4
    func startAutoScroll() {
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
          currentIndex = (currentIndex + 1) % imageARR.count
          currentImageIndex = currentIndex
      }
    func updateCurrentIndex(to index: Int) {
          currentIndex = index
          currentImageIndex = currentIndex
      }
    

    
}
extension ServicesViewModel{
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
