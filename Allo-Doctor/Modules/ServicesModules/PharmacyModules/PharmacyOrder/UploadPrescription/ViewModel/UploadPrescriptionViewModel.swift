//
//  UploadPrescriptionViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/12/2024.
//

import UIKit

class UploadPrescriptionViewModel {
    private var cancellables = Set<AnyCancellable>()
    private var apiClient: APIClient
    private var pharmacyId: Int
    internal var insuranceId = CurrentValueSubject<Int, Never>(0)
    internal var idNumber = CurrentValueSubject<String, Never>("")
    internal var age = CurrentValueSubject<String, Never>("")
    internal var districtId = CurrentValueSubject<Int, Never>(0)
    @Published var bookingStatus: BookingStatus?
    var adressId: Int?
    @Published var cities: [City] = []
    // MARK: - Output Properties
    @Published var selectedImage: UIImage?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var uploadProgress: Float = 0.0
    @Published var isUploadSuccess: Bool = false

    // MARK: - Private Properties
    private let imageFileName = "prescriptionImage.png"
    var coordinator: HomeCoordinatorContact?
    init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient(), pharmacyId: Int) {
        self.apiClient = apiClient
        self.pharmacyId = pharmacyId
        self.coordinator = coordinator
    }

    func uploadPrescription(){
        let body = ConfirmUploadPrescriptionBody(
            address_id: adressId ?? 0,
            pharmacy_id: pharmacyId,
            address_user_id: adressId ?? 1,
            payment_type: "cash"
        )
     print (body)
      uploadImage(request:body)
    }
}
extension UploadPrescriptionViewModel {


// MARK: - Input Properties

func uploadImage(request:ConfirmUploadPrescriptionBody) {
  

    let imgData =  getSavedImageData()!
    let imageName = getSavedImageName()
    let imageKey = "prescription"

    NetworkManagerAlamofire.shared.uploadImage(
        endpoint: "/admin/order/create",
        imgType: "jpeg",
        imgData: imgData,
        imageName: imageName ?? "",
        imageKey: imageKey,
        additionalParams: request,
        responseType: LaravelResponse.self
    ) { result in
        switch result {
        case .success(let response):
            self.bookingStatus = .success
            print("Upload successful: \(response)")
        case .failure(let error):
            self.bookingStatus = .failure
            print("Error during upload: \(error.localizedDescription)")
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




func navBack(){
  coordinator?.navigateBack()
}
func showAddressAdd(){
        coordinator?.showMapView(screenType: .uploadPresription)
}

}


