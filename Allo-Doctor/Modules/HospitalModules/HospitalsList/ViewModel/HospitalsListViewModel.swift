//
//  HospitalsListViewModel.swift
//  Allo-Doctor
//
//  Created by Assistant on 14/11/2025.
//

import Foundation
import Combine

class HospitalsListViewModel {
    // MARK: - Published Properties
    @Published var hospitals: [HospitalInfoService] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var banners: [Banner]?
    @Published var currentBannerIndex: Int = 0

    // MARK: - Properties
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    private var apiClient: APIClient
    private var bannerTimer: AnyCancellable?
    private let autoScrollInterval: TimeInterval = 7

    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }

    // MARK: - API Methods
    func fetchHospitals() {
        isLoading = true
        let router = APIRouter.fetchHospitals(isPaginate: 50, serviceId: 1)

        apiClient.fetchData(from: router.url, as: HospitalResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch hospitals: \(error.localizedDescription)"
                    print("Error fetching hospitals: \(error)")
                }
            }, receiveValue: { [weak self] hospitalResponse in
                self?.hospitals = hospitalResponse.data
                print("Fetched \(hospitalResponse.data.count) hospitals")
            })
            .store(in: &cancellables)
    }

    func fetchHospitalBanners() {
        let router = APIRouter.fetchOffers(offerType: "doctor")
        apiClient.fetchData(from: router.url, as: BannerResponse.self)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] response in
                      self?.banners = response.data ?? []
                  })
            .store(in: &cancellables)
    }

    // MARK: - Banner Auto-Scroll
    func startBannerAutoScroll() {
        stopBannerAutoScroll()
        guard banners?.count ?? 0 > 1 else { return }
        bannerTimer = Timer.publish(every: autoScrollInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.scrollToNextBanner() }
    }

    func stopBannerAutoScroll() {
        bannerTimer?.cancel()
        bannerTimer = nil
    }

    func updateCurrentBannerIndex(to index: Int) {
        currentBannerIndex = index
    }

    private func scrollToNextBanner() {
        currentBannerIndex = (currentBannerIndex + 1) % (banners?.count ?? 1)
    }

    // MARK: - Navigation Methods
    func navigateToHospitalSpecialties(hospital: HospitalInfoService) {
        coordinator?.showHospitalSpecialties(hospital: hospital)
    }

    func navigateBack() {
        coordinator?.navigateBack()
    }
}
