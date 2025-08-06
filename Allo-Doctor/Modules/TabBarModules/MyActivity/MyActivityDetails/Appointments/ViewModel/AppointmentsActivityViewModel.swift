//
//  AppointmentsActivityViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/01/2025.
//

import Foundation
class AppointmentsActivityViewModel{
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient: APIClient
    @Published var bookingData: MyBookings
    @Published var cancelStatus: BookingStatus?
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(),bookingData:MyBookings) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.bookingData = bookingData
        print(bookingData)
    }
}
extension AppointmentsActivityViewModel{
    func cancelReservation(){
        let router = APIRouter.cancelReservation(id: bookingData.id, type: bookingData.typeOfBooking ?? "")
        print(router.url)
        apiClient.deleteData(from: router.url, as: DeleteResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.cancelStatus = .success
                    print("Delete request completed successfully.")
                case .failure(let error):
                    self.cancelStatus = .failure
                    print("Error during delete request: \(error)")
                }
            }, receiveValue: { response in
                print("Message: \(response.Message)")
                print("Data: \(response.data)")
                print (response)
            })
        .store(in: &cancellables)}
}
extension AppointmentsActivityViewModel{
    func navBack(){
        coordinator?.navigateBack()
    }
    func navToReview(){
   
        coordinator?.presentReview(reviewType: bookingData.typeOfBooking ?? "", reviewId: bookingData.doctor?.doctorServiceSpecialty?.doctor?.id ?? 0)
    }
}
