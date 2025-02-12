//
//  UserInsuranceViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/12/2024.
//


import Foundation
import UIKit
import Alamofire

enum UploadError: Error {
    case invalidInput(String)
    case networkError(String)
    case serverError(String)
}

class UserInsuranceViewModel {
    // MARK: - Properties
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    private let networkReachability = NetworkReachabilityManager()
    
    // MARK: - Input Properties
    internal var insuranceId = CurrentValueSubject<Int, Never>(0)
    internal var idNumber = CurrentValueSubject<String, Never>("")
    internal var age = CurrentValueSubject<String, Never>("")
    
    // MARK: - Output Properties
    @Published var selectedImage: UIImage?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var uploadProgress: Float = 0.0
    @Published var isUploadSuccess: Bool = false
    @Published var status: BookingStatus?
    
    // MARK: - Private Properties
    private let imageFileName = "selectedImage.png"
    private var uploadRetryCount = 0
    private let maxRetryAttempts = 3
    private let retryDelay: TimeInterval = 2.0
    
    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil) {
        self.coordinator = coordinator
      
    }
    
    // MARK: - Network Setup
     func UploadInsurance() {
         
    }
    func addInsurance() {
        let addInsurance = UserInsuranceModel(
            medical_insurance_id : insuranceId.value,
            id_number: idNumber.value,
            age: age.value
        )
       print(addInsurance)
        uploadImage(request:addInsurance)
        
    }
    func uploadImage(request:UserInsuranceModel) {
      

        let imgData =  getSavedImageData()!
        let imageName = getSavedImageName()
        let imageKey = "photo_of_medical_card"

        NetworkManagerAlamofire.shared.uploadImage(
            endpoint: "/admin/user-insurance/create",
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
                self.status = .success
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
        age.send("")
        insuranceId.send(0)
        idNumber.send("")
        selectedImage = nil
        deleteImage()
    }
    
    private func resetUploadState() {
        isLoading = false
        uploadProgress = 0.0
        uploadRetryCount = 0
    }
    
    
  func navBack(){
      coordinator?.navigateBack()
    }
}


