//
//  UploadPrescriptionViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/12/2024.
//

import UIKit
import PhotosUI

class UploadPrescriptionViewController: BaseViewController<UploadPrescriptionViewModel>, UIImagePickerControllerDelegate & UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    @IBOutlet weak var navBackButton: CustomNavigationBackButton!

    // Outlets
    @IBOutlet weak var areaLabel: CairoSemiBold!
    @IBOutlet weak var deleteImage: UIButton!
    @IBOutlet weak var prescriptionImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func setupUI() {
        navBackButton.setTitle(AppLocalizedKeys.uploadPrescription.localized)
        navBackButton.setTitleColor(.black, for: .normal)
        navBackButton.tintColor =  .black
        
    }
    override func bindViewModel() {
        bindVM()
        handleViewModelResponse()
    }

    // Delete image action
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    @IBAction func deleteImageAction(_ sender: Any) {
        viewModel.deleteImage()
        deleteImage.isHidden = true
    }

    // Upload prescription action
    @IBAction func uploadPrescriptionAction(_ sender: Any) {
        LoadingIndicator.shared.show()
        viewModel.uploadPrescription()
    }

    // Confirmation button action
    @IBAction func confirmationButtonAction(_ sender: Any) {
        if viewModel.selectedImage == nil {
            AlertManager.showInternetAlert(on: self, message: AppLocalizedKeys.uploadPrescriptionFirst.localized)
        } else {
            uploadPrescriptionAction(sender)
        }
    }

    // Select image action
    @IBAction func selectImage(_ sender: Any) {
        openImagePicker()
    }

    @IBAction func addAddressAction(_ sender: Any) {
        let viewModel = UserAdressSelectViewModel()
        let contentViewController = UserAdressSelectViewController(viewModel: viewModel)
          
          // Subscribe to choosedAddress to get selected address name and ID
          contentViewController.choosedAddress
              .sink { [weak self] (addressName, addressID) in
                  self?.areaLabel.text = addressName
                  self?.viewModel.adressId = addressID
//                  self?.viewModel.handleSelectedAddress(name: addressName, id: addressID)
                  
              }
              .store(in: &cancellables)
        contentViewController.dismissalSubject
            .sink {
                self.viewModel.showAddressAdd()
            }
            .store(in: &cancellables)
          let sheetController = FWIPNSheetViewController(controller: contentViewController, sizes: [.percent(0.5)])
          present(sheetController, animated: true, completion: nil)
    }
}

extension UploadPrescriptionViewController {
    @objc private func openImagePicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            if let image = object as? UIImage {
                self?.viewModel.saveImage(image)
            }
        }
    }
}

extension UploadPrescriptionViewController {
    private func bindVM() {
        viewModel.$selectedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.prescriptionImage.image = image
                self?.deleteImage.isHidden = (image == nil)
            }
            .store(in: &cancellables)
    }
}



extension UploadPrescriptionViewController {
    private func handleViewModelResponse() {
        viewModel.$bookingStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                LoadingIndicator.shared.hide()
                guard let status = status else { return }
                switch status {
                case .success:
                    self?.handleSuccessViews()
                case .failure:
                    AlertManager.showAlert(on: self!, title: AppLocalizedKeys.error.localized, message: AppLocalizedKeys.somethingHappen.localized)
                }
            }
            .store(in: &cancellables)
    }

    private func handleSuccessViews() {
        let confirmationView = ConfirmationView(frame: view.bounds)
        confirmationView.proceedActionPublisher
            .sink { [weak self] _ in
                self?.viewModel.navBack()
            }
            .store(in: &cancellables)
        view.addSubview(confirmationView)
    }
}
