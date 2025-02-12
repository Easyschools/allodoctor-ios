//
//  IncubationsViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/11/2024.
//
import UIKit

import Foundation


class IncubationsViewModel {
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var cities: [City] = []
    // Reactive properties for form fields
    private var apiClient = APIClient()
    internal var name = CurrentValueSubject<String, Never>("")
    internal var districtId = CurrentValueSubject<Int, Never>(0)
    internal var day = CurrentValueSubject<String, Never>("")
    internal var month = CurrentValueSubject<String, Never>("")
    internal var year = CurrentValueSubject<String, Never>("")
    internal var phone = CurrentValueSubject<String, Never>("")
    @Published var status: BookingStatus?
    // Image management
    private let imageFileName = "documentImage.png"
    @Published var selectedImage: UIImage?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    

    // Initializer
    init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }

  
    func confirmBooking(){
     let body = IncubtionsAndIntensiveCareModel(
           name:name.value,
           district_id:districtId.value,
             accept_terms :1 ,
           phone: phone.value,
           birthdate:"2000-02-17"
        )
   
      uploadImage(request:body)
    }
}
extension IncubationsViewModel {


// MARK: - Input Properties

func uploadImage(request:IncubtionsAndIntensiveCareModel) {
  

    guard let imgData = getSavedImageData() else {
        print("Error: Failed to retrieve image data.")
        return
    }

    guard let imageName = getSavedImageName() else {
        print("Error: Failed to retrieve image name.")
        return
    }

    let imageKey = "document"

    // Use imgData, imageName, and imageKey safely here

    NetworkManagerAlamofire.shared.uploadImage(
        endpoint: "/admin/incubator/create",
        imgType: "jpeg",
        imgData: imgData,
        imageName: imageName,
        imageKey: imageKey,
        additionalParams: request,
        responseType: LaravelResponse.self
    ) { result in
        switch result {
        case .success(let response):
            print("Upload successful: \(response)")
            self.status = .success
            self.clearForm()
        case .failure(let error):
            print("Error during upload: \(error.localizedDescription)")
            self.status = .failure
        }
    }

       
}

// MARK: - Image Management
func getDocumentsDirectory() -> URL {
       FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
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

private func clearForm() {
   
    selectedImage = nil
    deleteImage()
}




func navBack(){
  coordinator?.navigateBack()
}
    func navToHome(){
      coordinator?.navigateToRoot()
    }
}


extension IncubationsViewModel {
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


