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
        internal var age = CurrentValueSubject<String, Never>("")
         internal var phone = CurrentValueSubject<String, Never>("")
         internal var note = CurrentValueSubject<String, Never>("")
          internal var address = CurrentValueSubject<String, Never>("")
         internal var districtId = CurrentValueSubject<Int, Never>(0)
    @Published var selectedImage: UIImage?

    @Published var isLoading: Bool = false
    @Published var uploadProgress: Float = 0.0
    @Published var isUploadSuccess: Bool = false
    
    // MARK: - Private Properties
    private let imageFileName = "selectedImage.png"
         private var apiClient = APIClient()
        init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
           self.coordinator = coordinator
           self.apiClient = apiClient
        }
    }
      extension IntensiveCareViewModel{
        func confirmBooking(){
               let confirmOrderRequest = BookingHomeBody(
                name : "Abdallah",
                phone : "01010459197",
                address : "305 NewCairo",
                district_id:159,
                accept_terms : 1,
                speciality_id:1
               )
            
          uploadImage(request:confirmOrderRequest)
           }
          func uploadImage(request:BookingHomeBody) {
            

              let imgData =  getSavedImageData()!
              let imageName = getSavedImageName()
              let imageKey = "document"

              NetworkManagerAlamofire.shared.uploadImage(
                  endpoint: "/admin/intensive-care/create",
                  imgType: "jpeg",
                  imgData: imgData,
                  imageName: imageName ?? "",
                  imageKey: imageKey,
                  additionalParams: request,
                  responseType: LaravelResponse.self
              ) { result in
                  switch result {
                  case .success(let response):
                      print("Upload successful: \(response)")
                  case .failure(let error):
                      print("Error during upload: \(error.localizedDescription)")
                  }
              }

                 
          }
//        private func confirmBooking(request: BookingHomeBody) {
//            let router = APIRouter.bookHomeVisit(request)
//            apiClient.postData(to: router.url,body:request, as: BookingHomeBodyResponse.self)
//                .sink(receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                       
//                        break
//                    case .failure(let error):
//                      return
//                    }
//                }, receiveValue: { [weak self] response in
//                   
//                  
//                   
//                })
//                .store(in: &cancellables)
//        }
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
           age.send("")
//           insuranceId.send(0)
//           idNumber.send("")
           selectedImage = nil
           deleteImage()
       }
       
       
      
        }
