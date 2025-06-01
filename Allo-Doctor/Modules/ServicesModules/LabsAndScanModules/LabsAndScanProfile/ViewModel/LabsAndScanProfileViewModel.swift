//
//  LabsAndScanProfileViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/10/2024.
//

import UIKit

class LabsAndScanProfileViewModel: ObservableObject {
    // MARK: - Properties
    var coordinator: HomeCoordinatorContact?
    @Published var errorMessage: String?
    @Published var imageUrl: String?
    @Published var screenType: String?
    @Published var labsAndScans: LabData?
    @Published var AddedItems: Set<LabTestType> = []
    @Published var id: Int?
    @Published var searchText: String = ""
    @Published var filteredTests: [LabTestType] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var apiClient: APIClient
    
    var displayedTests: [LabTestType] {
        if searchText.isEmpty {
            return labsAndScans?.types ?? []
        }
        return filteredTests
    }
    
    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil,
         imageUrl: String,
         apiClient: APIClient = APIClient(),
         screenType: String,
         id: Int) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.imageUrl = imageUrl
        self.screenType = screenType
        self.id = id
    }
    
    // MARK: - Public Methods
    func getLabData() {
        let router = APIRouter.fetchLabsAndScanInfo(id: id ?? 1)
        apiClient.fetchData(from: router.url, as: LabsAndScanResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] labResponse in
                self?.labsAndScans = labResponse.data
            })
            .store(in: &cancellables)
    }
    
    func filterTests(with searchText: String) {
        self.searchText = searchText
        guard let allTests = labsAndScans?.types else { return }
        
        if searchText.isEmpty {
            filteredTests = allTests
        } else {
            filteredTests = allTests.filter { test in
                let nameEn = test.test.nameEn?.lowercased()
                let nameAr = test.test.nameAr?.lowercased()
                let searchQuery = searchText.lowercased()
                
                return nameEn?.contains(searchQuery) ?? true || ((nameAr?.contains(searchQuery)) != nil)
            }
        }
        objectWillChange.send()
    }
    
    func toggleAdded(test: LabTestType) {
        if AddedItems.contains(test) {
            AddedItems.remove(test)
        } else {
            AddedItems.insert(test)
        }
        objectWillChange.send()
    }
    
    func isAdded(test: LabTestType) -> Bool {
        return AddedItems.contains(test)
    }
}

// MARK: - Navigation Methods
extension LabsAndScanProfileViewModel {
    func navigationBacK() {
        coordinator?.navigateBack()
    }
    
    func showNumberView(uiviewController: UIViewController) {
        UIHelper.showCallActionSheet(phoneNumber: "010104561837", on: uiviewController)
    }
    
    func navToBookingAppointments() {
        let tests = Array(AddedItems)
        if !tests.isEmpty {
            coordinator?.showLabsAndScanBookingAppointments(
                labId: id ?? 0,
                tests: tests,
                type: screenType ?? "lab"
            )
        }
    }
    
    func navToUploadPresc() {
        coordinator?.showLabsAndScanBooking(
            tests: [],
            hourId: 1,
            dayId: 1,
            date: "",
            labId: id ?? 0,
            bookingType: screenType ?? "lab"
        )
    }
}
