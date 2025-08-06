//
//  ImageUploadManager.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/06/2025.
//
import UIKit
import Photos
import AVFoundation

class ImageUploadViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let instructionLabel = UILabel()
    private let imageStackView = UIStackView()
    private let addPhotoButton = UIButton(type: .system)
    private let uploadButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let statusLabel = UILabel()
    private let dismissButton = UIButton(type: .system) // 🔁 Dismiss button inside view

    private var id: Int

    // MARK: - Properties
    private var selectedImages: [UIImage] = []
    private let maxImageCount = 3
    private var imageViews: [UIImageView] = []
    private var removeButtons: [UIButton] = []
    private var isUploading = false

    // MARK: - Custom Initializer
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Required Initializer
    required init?(coder: NSCoder) {
        self.id = 0
        super.init(coder: coder)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupImageStackView()
        updateUI()
    }

    // MARK: - Navigation Bar Setup
    private func setupNavigationBar() {
        title = AppLocalizedKeys.uploadPhotos.localized
        let dismissBarButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(dismissButtonTapped)
        )
        dismissBarButton.tintColor = .label
        navigationItem.leftBarButtonItem = dismissBarButton
    }
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = AppLocalizedKeys.images.localized
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        instructionLabel.text = AppLocalizedKeys.pleaseUploadMedical.localized
        instructionLabel.font = UIFont.systemFont(ofSize: 16)
        instructionLabel.textColor = .secondaryLabel
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageStackView.axis = .vertical
        imageStackView.spacing = 16
        imageStackView.alignment = .fill
        imageStackView.distribution = .equalSpacing
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addPhotoButton.setTitle(AppLocalizedKeys.addPhotos.localized, for: .normal)
        addPhotoButton.backgroundColor = .systemBlue
        addPhotoButton.setTitleColor(.white, for: .normal)
        addPhotoButton.layer.cornerRadius = 12
        addPhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
        
        uploadButton.setTitle(AppLocalizedKeys.uploadPhotos.localized, for: .normal)
        uploadButton.backgroundColor = .systemGreen
        uploadButton.setTitleColor(.white, for: .normal)
        uploadButton.layer.cornerRadius = 12
        uploadButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        uploadButton.isEnabled = false
        uploadButton.alpha = 0.6
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        
        progressView.isHidden = true
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = .systemGray5
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        statusLabel.text = ""
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.textColor = .secondaryLabel
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // ✅ Configure view dismiss button
        dismissButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        dismissButton.tintColor = .secondaryLabel
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(instructionLabel)
        contentView.addSubview(imageStackView)
        contentView.addSubview(addPhotoButton)
        contentView.addSubview(uploadButton)
        contentView.addSubview(progressView)
        contentView.addSubview(statusLabel)
        contentView.addSubview(dismissButton) // ✅ Add button inside view
    }

    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            instructionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            imageStackView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 24),
            imageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            addPhotoButton.topAnchor.constraint(equalTo: imageStackView.bottomAnchor, constant: 24),
            addPhotoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addPhotoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 50),

            uploadButton.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 16),
            uploadButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            uploadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            uploadButton.heightAnchor.constraint(equalToConstant: 50),

            progressView.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: 16),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            progressView.heightAnchor.constraint(equalToConstant: 4),

            statusLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 12),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            // ✅ Dismiss button (in-view) constraints
            dismissButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dismissButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            dismissButton.widthAnchor.constraint(equalToConstant: 30),
            dismissButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    
    private func setupImageStackView() {
        // Clear existing views
        imageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
        removeButtons.removeAll()
        
        // Create image container views
        for i in 0..<maxImageCount {
            let containerView = createImageContainerView(at: i)
            imageStackView.addArrangedSubview(containerView)
        }
    }
    
    private func createImageContainerView(at index: Int) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Image view
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Placeholder label
        let placeholderLabel = UILabel()
        placeholderLabel.text = AppLocalizedKeys.images.localized.appendingWithSpace("\(index + 1)")
        placeholderLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        placeholderLabel.textColor = .secondaryLabel
        placeholderLabel.textAlignment = .center
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Remove button
        let removeButton = UIButton(type: .custom)
        removeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        removeButton.tintColor = .systemRed
        removeButton.backgroundColor = .white
        removeButton.layer.cornerRadius = 12
        removeButton.isHidden = true
        removeButton.tag = index
        removeButton.addTarget(self, action: #selector(removeImageTapped(_:)), for: .touchUpInside)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(imageView)
        containerView.addSubview(placeholderLabel)
        containerView.addSubview(removeButton)
        
        imageViews.append(imageView)
        removeButtons.append(removeButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 120),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            removeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            removeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            removeButton.widthAnchor.constraint(equalToConstant: 24),
            removeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return containerView
    }
    
    // MARK: - Actions
    @objc private func addPhotoButtonTapped() {
        guard selectedImages.count < maxImageCount else {
            showAlert(title: AppLocalizedKeys.maximumPhotosReached.localized, message: AppLocalizedKeys.uploadLimitWarning.localized)
            return
        }
        
        showImagePickerOptions()
    }
    
    @objc private func uploadButtonTapped() {
        guard !selectedImages.isEmpty else { return }
        
        uploadMultipleImages()
    }
    
    @objc private func removeImageTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index < selectedImages.count else { return }
        
        selectedImages.remove(at: index)
        updateImageViews()
        updateUI()
    }
    
    // MARK: - Image Picker
    private func showImagePickerOptions() {
        let alert = UIAlertController(title: AppLocalizedKeys.selectPhotos.localized, message: "", preferredStyle: .actionSheet)
        
        // Camera option
        alert.addAction(UIAlertAction(title: AppLocalizedKeys.camera.localized, style: .default) { _ in
            self.checkCameraPermissionAndOpen()
        })
        
        // Photo library option
        alert.addAction(UIAlertAction(title: AppLocalizedKeys.photoLibrary.localized, style: .default) { _ in
            self.checkPhotoLibraryPermissionAndOpen()
        })
        
        alert.addAction(UIAlertAction(title: AppLocalizedKeys.cancelled.localized, style: .cancel))
        
        // For iPad support
        if let popover = alert.popoverPresentationController {
            popover.sourceView = addPhotoButton
            popover.sourceRect = addPhotoButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - Camera Permission and Access
    private func checkCameraPermissionAndOpen() {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthStatus {
        case .authorized:
            openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.openCamera()
                    } else {
                        self?.showCameraPermissionAlert()
                    }
                }
            }
        case .denied, .restricted:
            showCameraPermissionAlert()
        @unknown default:
            showCameraPermissionAlert()
        }
    }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "Camera Not Available", message: "Camera is not available on this device.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        
        present(imagePicker, animated: true)
    }
    
    private func showCameraPermissionAlert() {
        let alert = UIAlertController(
            title: "Camera Permission Required",
            message: "Please allow camera access in Settings to take photos.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    // MARK: - Photo Library Permission and Access
    private func checkPhotoLibraryPermissionAndOpen() {
        let photoAuthStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthStatus {
        case .authorized, .limited:
            openPhotoLibrary()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        self?.openPhotoLibrary()
                    } else {
                        self?.showPhotoLibraryPermissionAlert()
                    }
                }
            }
        case .denied, .restricted:
            showPhotoLibraryPermissionAlert()
        @unknown default:
            showPhotoLibraryPermissionAlert()
        }
    }
    
    private func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        
        present(imagePicker, animated: true)
    }
    
    private func showPhotoLibraryPermissionAlert() {
        let alert = UIAlertController(
            title: "Photo Library Permission Required",
            message: "Please allow photo library access in Settings to select photos.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    // MARK: - Image Management
    private func addImage(_ image: UIImage) {
        guard selectedImages.count < maxImageCount else { return }
        
        selectedImages.append(image)
        updateImageViews()
        updateUI()
    }
    
    private func updateImageViews() {
        for (index, imageView) in imageViews.enumerated() {
            if index < selectedImages.count {
                imageView.image = selectedImages[index]
                removeButtons[index].isHidden = false
                imageView.superview?.subviews.first(where: { $0 is UILabel })?.isHidden = true
            } else {
                imageView.image = nil
                removeButtons[index].isHidden = true
                imageView.superview?.subviews.first(where: { $0 is UILabel })?.isHidden = false
            }
        }
    }
    
    private func updateUI() {
        let hasImages = !selectedImages.isEmpty
        let canAddMore = selectedImages.count < maxImageCount
        
        uploadButton.isEnabled = hasImages && !isUploading
        uploadButton.alpha = uploadButton.isEnabled ? 1.0 : 0.6
        
        addPhotoButton.isEnabled = canAddMore && !isUploading
        addPhotoButton.alpha = addPhotoButton.isEnabled ? 1.0 : 0.6
        
        if canAddMore {
            addPhotoButton.setTitle("Add Photos (\(selectedImages.count)/\(maxImageCount))", for: .normal)
        } else {
            addPhotoButton.setTitle(AppLocalizedKeys.maximumPhotosAdded.localized, for: .normal)
        }
        
        if hasImages {
            uploadButton.setTitle(AppLocalizedKeys.uploadPhotos.localized.appendingWithSpace("\(selectedImages.count > 1 ? "" : "")"), for: .normal)
        } else {
            uploadButton.setTitle(AppLocalizedKeys.uploadPhotos.localized, for: .normal)
        }
    }
    
    // MARK: - Upload Functions
    private func uploadMultipleImages() {
        guard !selectedImages.isEmpty else { return }
        
        setUploadingState(true)
        statusLabel.text = AppLocalizedKeys.uploadingAllPhotos.localized
        
        // Add multiple photos upload function to NetworkService
        NetworkService.shared.uploadMultipleImages(
            endpoint: "admin/medical-info/update",
            images: selectedImages,
            imageParameterName: "images", // Server expects array of images
            parameters: ["id": self.id.toString()] // Add any additional parameters
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.setUploadingState(false)
                
                switch result {
                case .success(let data):
                    self?.handleUploadSuccess(data: data, message: AppLocalizedKeys.medicalInfoUpdatedSuccesfully.localized)
                case .failure(let error):
                    self?.handleUploadError(error: error)
                }
            }
        }
    }
    
    // MARK: - Upload State Management
    private func setUploadingState(_ uploading: Bool) {
        isUploading = uploading
        progressView.isHidden = !uploading
        
        if uploading {
            progressView.setProgress(0, animated: false)
            statusLabel.textColor = .systemBlue
        } else {
            progressView.setProgress(0, animated: false)
        }
        
        updateUI()
    }
    
    private func handleUploadSuccess(data: Data, message: String) {
        statusLabel.text = message
        statusLabel.textColor = .systemGreen
        
        // Clear images after successful upload
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.clearAllImages()
            self.dismiss(animated: true)
        }
        
        showAlert(title: AppLocalizedKeys.medicalInfoUpdatedSuccesfully.localized, message: message)
    }
    
    private func handleUploadError(error: NetworkError) {
        let errorMessage: String
        
        switch error {
        case .unauthorized:
            errorMessage = "Authentication required. Please log in again."
        case .invalidImage:
            errorMessage = "Invalid image format. Please try again."
        case .serverError(let message):
            errorMessage = message
        case .networkError(let message):
            errorMessage = "Network error: \(message)"
        case .invalidResponse:
            errorMessage = "Invalid server response. Please try again."
        case .invalidData:
            errorMessage = "Invalid data. Please try again."
        }
        
        statusLabel.text = "Upload failed: \(errorMessage)"
        statusLabel.textColor = .systemRed
        
        showAlert(title: "Upload Failed", message: errorMessage)
    }
    
    private func clearAllImages() {
        selectedImages.removeAll()
        updateImageViews()
        updateUI()
        statusLabel.text = ""
    }
    
    // MARK: - Utility
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppLocalizedKeys.ok.localized, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ImageUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            if let editedImage = info[.editedImage] as? UIImage {
                self?.addImage(editedImage)
            } else if let originalImage = info[.originalImage] as? UIImage {
                self?.addImage(originalImage)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
