//
//  BookingLabsAndScanViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/10/2024.
//

import Foundation
class BookingLabsAndScanViewModel{
     var coordinator:HomeCoordinatorContact?
    @Published var tests : [Test]?
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private var apiClient = APIClient()
    init(coordinator: HomeCoordinatorContact? = nil,tests:[Test],apiClient:APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.tests = tests
    }
    
}
extension BookingLabsAndScanViewModel{
    func createBooking() {
        let bookingRequest = LabsAndScanBookingRequest(
           
            appointment_lab_id: "16", availability: "1", userID: "172", name: "abdallah", phone: "01010459197", location: "NewCairo", types:"1")
       bookingPost(bookingBody: bookingRequest)
        
    }
    func bookingPost(bookingBody:LabsAndScanBookingRequest){
        let url = URL(string:"https://allodoctor-backend.developnetwork.net/api/admin/lab-booking/create")!
        apiClient.postData(to:url, body:bookingBody , as: LabsAndScanBookingResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { response in
                print("booking Response: \(response)")
            })
            .store(in: &cancellables)
    }
    
}
