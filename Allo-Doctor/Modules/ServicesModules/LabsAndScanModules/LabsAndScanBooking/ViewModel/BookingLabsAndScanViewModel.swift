//
//  BookingLabsAndScanViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/10/2024.
//

import UIKit
import Combine

class BookingLabsAndScanViewModel {
    // MARK: - Properties
    var coordinator: HomeCoordinatorContact?
    @Published var tests: [LabTestType]?
    @Published var errorMessage: String?
    @Published var selectedImage: UIImage?  // Keeping this for VC compatibility
    @Published var selectedImages: [UIImage] = []  // Array for multiple images
    internal var insuranceId = CurrentValueSubject<Int, Never>(0)
    internal var idNumber = CurrentValueSubject<String, Never>("")
    internal var age = CurrentValueSubject<String, Never>("")
    internal var symptoms = CurrentValueSubject<String, Never>("")
    internal var districtId = CurrentValueSubject<Int, Never>(0)
    @Published var bookingStatus: BookingStatus?
    private let imageFileName = "selected_image.png"  // Keeping this for single image
    private var cancellables = Set<AnyCancellable>()
    private var apiClient: APIClient
    private var labId: Int
    private var hourId: Int?
    private var dayId: Int?
    private var date: String
    var bookingType: String?
    internal var name = CurrentValueSubject<String, Never>(  UserDefaultsManager.sharedInstance.getUserName() ?? "")
    internal var phone = CurrentValueSubject<String, Never>(  UserDefaultsManager.sharedInstance.getMobileNumber() ?? "")
    internal var address = CurrentValueSubject<String, Never>("")
    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil,
         tests: [LabTestType],
         apiClient: APIClient = APIClient(),
         hourId: Int?,
         dayId: Int?,
         date: String,
         labId: Int,
         bookingType: String?) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.tests = tests
        self.hourId = hourId
        self.dayId = dayId
        self.date = date
        self.labId = labId
        self.bookingType = bookingType
    }
}

// MARK: - API Handling
extension BookingLabsAndScanViewModel {
    func createBooking() {
        let typesIds = tests?.compactMap { $0.test.id } ?? []
        
        let bookingRequest = LabsAndScanBookingRequest(
            labId: labId,
            availability: 1,
            name: name.value,
            phone: phone.value,
            location: address.value,
            test_id: typesIds,
            hourId: hourId,
            dayId: dayId,
            date: date,
            bookingType:bookingType,
            symptoms: symptoms.value
        )
        print(bookingRequest)
        uploadImages(request: bookingRequest)
    }
    
    func uploadImages(request: LabsAndScanBookingRequest) {
        if let imagesData = getSavedImagesData(), !imagesData.isEmpty {
            let images = imagesData.enumerated().map { (index, data) in
                ImageUploadModel(
                    data: data,
                    name: "prescription_\(index).jpeg",
                    type: "jpeg"
                )
            }
            
            NetworkManagerAlamofire.shared.uploadImages(
                endpoint: "/admin/lab-booking/create",
                images: images,
                imageKey: "prescription",  // Remove the [] as it's handled in the NetworkManager
                additionalParams: request,
                responseType: LaravelResponse.self
            ) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.bookingStatus = .success
                    self?.clearForm()
                    print("Upload successful: \(response)")
                case .failure(let error):
                    self?.bookingStatus = .failure
                    self?.errorMessage = error.localizedDescription
                    print("Error during upload: \(error.localizedDescription)")
                }
            }
        } else if let imgData = getSavedImageData() {
            let imageName = getSavedImageName() ?? "prescription.jpeg"
            NetworkManagerAlamofire.shared.uploadImage(
                endpoint: "/admin/lab-booking/create",
                imgType: "jpeg",
                imgData: imgData,
                imageName: imageName,
                imageKey: "prescription",
                additionalParams: request,
                responseType: LaravelResponse.self
            ) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.bookingStatus = .success
                    self?.clearForm()
                    print("Upload successful: \(response)")
                case .failure(let error):
                    self?.bookingStatus = .failure
                    print("Error during upload: \(error.localizedDescription)")
                }
            }
        }
    }
    

    // MARK: - Single Image Management
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveImage(_ image: UIImage) {
        // Save for single image support
        selectedImage = image
        
        // Also add to multiple images array
        selectedImages.append(image)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = image.jpegData(compressionQuality: 0.8) else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to prepare the image for saving"
                }
                return
            }
            
            // Save single image
            if let fileURL = self?.getDocumentsDirectory().appendingPathComponent(self?.imageFileName ?? "default.jpg") {
                do {
                    try data.write(to: fileURL)
                    print("Single image saved at:", fileURL.path)
                } catch {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Failed to save image: \(error.localizedDescription)"
                    }
                }
            }
            
            // Save as part of multiple images
            let fileName = "prescription_\(self?.selectedImages.count ?? 1).jpeg"
            let multipleFileURL = self?.getDocumentsDirectory().appendingPathComponent(fileName)
            try? data.write(to: multipleFileURL!)
        }
    }
    
    func loadSavedImage() {
        guard selectedImage == nil else { return }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let fileURL = self?.getDocumentsDirectory().appendingPathComponent(self?.imageFileName ?? "default.jpg") else { return }
            if let savedImage = UIImage(contentsOfFile: fileURL.path) {
                DispatchQueue.main.async {
                    self?.selectedImage = savedImage
                    if ((self?.selectedImages.contains(savedImage)) == nil) {
                        self?.selectedImages.append(savedImage)
                    }
                }
            }
        }
    }
    
    func getSavedImageName() -> String? {
        return imageFileName
    }
    
    func getSavedImageData() -> Data? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(imageFileName)
        return try? Data(contentsOf: fileURL)
    }
    
    // MARK: - Multiple Images Management
    func getSavedImagesData() -> [Data]? {
        do {
            let fileManager = FileManager.default
            let documentsURL = getDocumentsDirectory()
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL,
                                                             includingPropertiesForKeys: nil)
            let imageURLs = fileURLs.filter { $0.pathExtension == "jpeg" }
            
            return try imageURLs.map { try Data(contentsOf: $0) }
        } catch {
            print("Error getting saved images data: \(error)")
            return nil
        }
    }

    func deleteImage() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let fileURL = self?.getDocumentsDirectory().appendingPathComponent(self?.imageFileName ?? "default.jpg") else { return }
            try? FileManager.default.removeItem(at: fileURL)
            DispatchQueue.main.async {
                self?.selectedImage = nil
                self?.selectedImages.removeAll()
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
        selectedImages.removeAll()
        deleteImage()
    }

    func navBack() {
        clearForm()
        coordinator?.navigateBack()
    }

    func navToHome() {
        clearForm()
        coordinator?.navigateToRoot()
    }

   
}
