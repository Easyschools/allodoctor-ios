//
//  BookingLabsAndScanViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/10/2024.
//

import UIKit
import PhotosUI

class BookingLabsAndScanViewController: BaseViewController<BookingLabsAndScanViewModel> {
    // MARK: - Outlets
    @IBOutlet weak var typeOfNavBackButton: CustomNavigationBackButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var deleteImageButton: UIButton!
    @IBOutlet weak var reportImage: UIImageView!
    @IBOutlet weak var textView: CustomTextView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var adressTextfield: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    
   
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func bindViewModel() {
        bindTextFields()
        setupBindings()
    }
    override func viewDidLayoutSubviews() {
        setupUIViewController()
    }
    
    // MARK: - Setup
    override func setupUI() {
        loadSavedImage()
//        textView.placeholder = "Write Symptoms"
        deleteImageButton.isHidden = true
        reportImage.contentMode = .scaleAspectFill
        reportImage.clipsToBounds = true
        reportImage.layer.cornerRadius = 8
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(reportImageTapped))
        reportImage.addGestureRecognizer(tapGesture)
        reportImage.isUserInteractionEnabled = true
   
    }
    
    
    private func setupBindings() {
        handleViewModelResponse()
        // Bind to selectedImage updates
        viewModel.$selectedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.updateUIWithImage(image)
            }
            .store(in: &cancellables)
        
        // Bind to error messages
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
              
            }
            .store(in: &cancellables)
    }
    
    private func loadSavedImage() {
        viewModel.loadSavedImage()
    }
    
    private func updateUIWithImage(_ image: UIImage?) {
        reportImage.image = image
        deleteImageButton.isHidden = image == nil
    }
    
    // MARK: - Actions
    @IBAction func uploadImageAction(_ sender: Any) {
        openImagePicker()
    }
    
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.coordinator?.navigateBack()
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        viewModel.deleteImage()
    }
    
    @IBAction func bookingConfirmationAction(_ sender: Any) {
        guard validateInputs() else { return }
        viewModel.createBooking()
    }
    
    @objc private func reportImageTapped() {
        openImagePicker()
    }
    

    
}

// MARK: - UI Setup
extension BookingLabsAndScanViewController {
    private func setupUIViewController() {
        upperView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: Dimensions.upperViewBorderRaduis.rawValue)
        
    }
}

// MARK: - Image Picker
extension BookingLabsAndScanViewController: PHPickerViewControllerDelegate {
    private func openImagePicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        
      
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            DispatchQueue.main.async {
               
                
                if let error = error {
                   
                    return
                }
                
                if let image = object as? UIImage {
                    let compressedImage = self?.compressImage(image)
                    self?.viewModel.saveImage(compressedImage ?? image)
                }
            }
        }
    }
    
    private func compressImage(_ image: UIImage) -> UIImage {
        let maxSize: CGFloat = 1024
        let scale = min(maxSize/image.size.width, maxSize/image.size.height)
        
        if scale >= 1 {
            return image
        }
        
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
}

// MARK: - Loading & Error Handling
extension BookingLabsAndScanViewController {
   
    
   
}
extension BookingLabsAndScanViewController {
    private func handleViewModelResponse(){
        viewModel.$bookingStatus
            .receive(on: DispatchQueue.main)
            .sink { status in
                guard let status = status else { return }
                switch status {
                case .success:
                    self.handleSucessViews()
                case .failure:
                    AlertManager.showAlert(on: self, title: AppLocalizedKeys.error.localized, message: AppLocalizedKeys.somethingHappen.localized)
                }
            }
            .store(in: &cancellables)
    }
    private func handleSucessViews(){
        let confirmationView = ConfirmationView(frame: view.bounds)
        confirmationView.proceedActionPublisher
            .sink { [weak self] _ in
                self?.viewModel.navToHome()
            }
            .store(in: &cancellables)
        // Add it to the view controller's view
        view.addSubview(confirmationView)
    }
    private func bindTextFields()
    {
        nameTextField.bindText(to: viewModel.name, storeIn: &cancellables)
        mobileNumberTextField.bindText(to: viewModel.phone, storeIn: &cancellables)
        adressTextfield.bindText(to: viewModel.address, storeIn: &cancellables)
        textView.bindText(to: viewModel.symptoms, storeIn: &cancellables)
    }
}
extension BookingLabsAndScanViewController{
    private func validateInputs() -> Bool {
        // Validate name
        guard let name = nameTextField.text, !name.isEmpty else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidName.localized, message: AppLocalizedKeys.nameEmpty.localized)
            return false
        }
        
        let nameRegex = "^[a-zA-Z ]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        guard namePredicate.evaluate(with: name) else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidName.localized, message: AppLocalizedKeys.NameRejecs.localized)
            return false
        }
        
        // Validate phone number
        guard let phone = mobileNumberTextField.text, !phone.isEmpty else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidNumber.localized, message: AppLocalizedKeys.phoneEmpty.localized)
            return false
        }
     
        guard phone.isValidEgyptianNumber else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidNumber.localized, message: AppLocalizedKeys.phoneRejecs.localized)
            return false
        }
       
        // Validate area selection
        guard let address = adressTextfield.text, !address.isEmpty else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidAddress.localized, message: AppLocalizedKeys.addressEmpty.localized)
            return false
        }
      
        guard reportImage.image != nil else {
            AlertManager.showAlert(on: self, title: "Error", message: "Please Upload Report.")
            return false
        }
        
        return true
    }
}
