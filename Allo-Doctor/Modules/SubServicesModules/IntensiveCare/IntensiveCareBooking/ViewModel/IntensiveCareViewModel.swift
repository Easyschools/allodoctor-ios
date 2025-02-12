//
//  IntensiveCareViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 18/11/2024.
//

import Foundation
import UIKit
class IntensiveCareViewModel{
   var coordinator: HomeCoordinatorContact?
   private var cancellables = Set<AnyCancellable>()
   @Published var errorMessage: String?
   internal var name = CurrentValueSubject<String, Never>("")
   internal var phone = CurrentValueSubject<String, Never>("")
   internal var address = CurrentValueSubject<String, Never>("")
    @Published var cities: [City] = []
    @Published var bookingStatus: BookingStatus?
    internal var districtId = CurrentValueSubject<Int, Never>(0)
    internal var day = CurrentValueSubject<String, Never>("")
    internal var month = CurrentValueSubject<String, Never>("")
    internal var year = CurrentValueSubject<String, Never>("")
    private var  selectedUnit : String?
    @Published var selectedImage: UIImage?
    @Published var status: BookingStatus?
    @Published var isLoading: Bool = false
    @Published var uploadProgress: Float = 0.0
    @Published var isUploadSuccess: Bool = false
    
    // MARK: - Private Properties
    private let imageFileName = "reportedImage.png"
         private var apiClient = APIClient()
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(),selectedUnit:String) {
           self.coordinator = coordinator
        self.apiClient = apiClient
        self.selectedUnit = selectedUnit
        }
    }
      extension IntensiveCareViewModel{
        func confirmBooking(){
               let confirmOrderRequest = IntensiveCareBody(
                name : name.value,
                phone : phone.value,
                district_id:districtId.value, birthdate: "\(year.value)-\(month.value.monthNumber() ?? 2)-\(day.value)",
                type : selectedUnit ?? "", accept_terms : 1
               )
            print(confirmOrderRequest)
          uploadImage(request:confirmOrderRequest)
           }
          func uploadImage(request:IntensiveCareBody) {
            

              let imgData =  getSavedImageData()!
              let imageName = getSavedImageName()
              let imageKey = "document"

              NetworkManagerAlamofire.shared.uploadImage(
                  endpoint: "/admin/intensive-care/create",
                  imgType: "jpg",
                  imgData: imgData,
                  imageName: imageName ?? "",
                  imageKey: imageKey,
                  additionalParams: request,
                  responseType: LaravelResponse.self
              ) { result in
                  switch result {
                  case .success(let response):
                      print("Upload successful: \(response)")
                      self.bookingStatus = .success
                      self.clearForm()
                  case .failure(let error):
                      print("Error during upload: \(error)")
                      self.bookingStatus = .failure
                  }
              }

                 
          }
          func saveImage(_ image: UIImage) {
              selectedImage = image
              
              DispatchQueue.global(qos: .background).async { [weak self] in
                  guard let data = image.jpegData(compressionQuality: 0.8),
                        let fileURL = self?.getDocumentsDirectory().appendingPathComponent(self?.imageFileName ?? "default.jpg") else {
                      DispatchQueue.main.async {
                          self?.errorMessage = "Failed to prepare the image for saving"
                      }
                      return
                  }
                  
                  do {
                      try data.write(to: fileURL)
                      print("Image saved at:", fileURL.path)
                  } catch {
                      DispatchQueue.main.async {
                          self?.errorMessage = "Failed to save image: \(error.localizedDescription)"
                      }
                  }
              }
          }
          func loadSavedImage() {
              guard selectedImage == nil else { return }
              
              DispatchQueue.global(qos: .background).async { [weak self] in
                  guard let fileURL = self?.getDocumentsDirectory().appendingPathComponent(self?.imageFileName ?? "default.jpg") else { return }
                  if let savedImage = UIImage(contentsOfFile: fileURL.path) {
                      DispatchQueue.main.async {
                          self?.selectedImage = savedImage
                      }
                  }
              }
          }
          
          func getSavedImageName() -> String? {
              return imageFileName // Retrieve the saved image name
          }
          
          func getSavedImageData() -> Data? {
              let fileURL = getDocumentsDirectory().appendingPathComponent(imageFileName)
              return try? Data(contentsOf: fileURL) // Retrieve the saved image data
          }
      
       
       func deleteImage() {
           DispatchQueue.global(qos: .background).async { [weak self] in
               guard let fileURL = self?.getDocumentsDirectory().appendingPathComponent(self?.imageFileName ?? "default.jpg") else { return }
               try? FileManager.default.removeItem(at: fileURL)
               DispatchQueue.main.async {
                   self?.selectedImage = nil
               }
           }
       }
       
       // MARK: - Helper Methods
       private func handleSuccessfulUpload() {
           clearForm()
           
       }
          func getDocumentsDirectory() -> URL {
                 FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
             }
             
       
       private func clearForm() {
//           ag.send("")
//           insuranceId.send(0)
//           idNumber.send("")
           selectedImage = nil
           deleteImage()
       }
       
       
      
        }
extension IntensiveCareViewModel{
  func navBack(){
        coordinator?.navigateBack()
    }
  func  navToroot(){
        coordinator?.navigateToRoot()
    }
}
extension IntensiveCareViewModel {
    func getAllAreaOfResidence() {
        let router = APIRouter.fetchCities
        apiClient.fetchData(from: router.url, as: CityDataResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Failed to fetch Cities: \(error.localizedDescription)"
                }
            }, receiveValue: { citiesResponse in
                self.cities = citiesResponse.data ?? []
            })
            .store(in: &cancellables)
    }
}
