//
//  LabsAndScanProfileViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/10/2024.
//

import UIKit
class LabsAndScanProfileViewModel{
    private var coordinator: HomeCoordinatorContact?
    @Published var errorMessage: String?
    @Published var imageUrl : String?
    @Published var screenType : String?
    @Published var tests : [ScanType]?
    @Published var labsAndScans : LabAndScans?
    @Published var AddedItems: Set<ScanType> = []
    @Published var id : Int?
    private var cancellables = Set<AnyCancellable>()
    private var apiClient = APIClient()
    init(coordinator: HomeCoordinatorContact? = nil,imageUrl:String,apiClient:APIClient = APIClient(),screenType:String,id :Int) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.imageUrl = imageUrl
        self.screenType = screenType
        self.id = id
    }
}
extension LabsAndScanProfileViewModel{
    func getLabData(){
        let router = APIRouter.fetchLabsAndScanInfo(id: id ?? 1)
        apiClient.fetchData(from:router.url, as: LabAndScansResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print ("error")
                    self.errorMessage = "Failed to fetch Labs: \(error.localizedDescription)"
                    print (self.errorMessage!)
                }
            }, receiveValue: { labResponse in
                self.labsAndScans = labResponse.data
            })
            .store(in: &cancellables)
    }}
extension LabsAndScanProfileViewModel {
    func navigationBacK(){
        coordinator?.navigateBack()
    }
    func navToBookingTests(){
        let tests = Array(AddedItems)
        coordinator?.showLabsAndScanBookingAppointments()
    }
}

extension LabsAndScanProfileViewModel {
    func toggleAdded(test: ScanType) {
            if AddedItems.contains(test) {
                AddedItems.remove(test)
            } else {
                AddedItems.insert(test)
            }
        }
        
        func isAdded(test: ScanType) -> Bool {
            return AddedItems.contains(test)
        }
}
