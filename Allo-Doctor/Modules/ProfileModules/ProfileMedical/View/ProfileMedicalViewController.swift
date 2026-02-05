//
//  ProfileMedicalViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/12/2024.
//

import UIKit


class ProfileMedicalViewController: BaseViewController<ProfileMedicalViewModel> {

    @IBOutlet weak var MedicalImagesCollectionView: UICollectionView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var navBackButton: CustomNavigationBackButton!
    @IBOutlet weak var confirmationButton: CustomButton!
    @IBOutlet weak var medicalHistoryTextView: CustomTextView!
    @IBOutlet weak var allergieTextView: CustomTextView!
    @IBOutlet weak var medicineTextView: CustomTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        confirmationButton.setTitle(AppLocalizedKeys.Confirm.localized, for: .normal)
        navBackButton.setTitle(AppLocalizedKeys.myMedicalInfo.localized)
        setupCollectionView()
        // Set self as the delegate for image upload completion
        viewModel.imageUploadDelegate = self
    }

    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Pass false to preserve user's text input when returning from modal
        // Initial text field population happens in bindViewModel() with updateTextFields: true
        viewModel.fetchMedicalData(updateTextFields: false)
    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    
    @IBAction func uploadImageAction(_ sender: Any) {
        viewModel.showMedicalImagesUpload()
    }
    
    override func bindViewModel() {
        viewModel.fetchMedicalData()
        bindData()
        setupTextView()
    }
    
    @IBAction func confirmationButton(_ sender: Any) {
        viewModel.confirmBooking()
    }
    
    private func setupCollectionView() {
        // Register the cell
        let nib = UINib(nibName: "MedicalImagesCollectionViewCell", bundle: nil)
        MedicalImagesCollectionView.register(nib, forCellWithReuseIdentifier: "MedicalImagesCollectionViewCell")
        
        // Set up collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        MedicalImagesCollectionView.collectionViewLayout = layout
       
        // Set delegates
        MedicalImagesCollectionView.dataSource = self
        MedicalImagesCollectionView.delegate = self
    }
    
    private func setupTextView(){
        medicineTextView.placeholder = AppLocalizedKeys.myMedicalInfo.localized
        medicalHistoryTextView.placeholder = AppLocalizedKeys.myMedicalInfo.localized
        allergieTextView.placeholder = AppLocalizedKeys.myMedicalInfo.localized
        allergieTextView.bindText(to: viewModel.allergy, storeIn: &cancellables)
        medicineTextView.bindText(to: viewModel.medication, storeIn: &cancellables)
        medicalHistoryTextView.bindText(to: viewModel.medicalHistory, storeIn: &cancellables)
    }
    
    private func bindData(){
        viewModel.$medicalData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // Only reload collection view for images
                // Text fields are updated via CurrentValueSubjects binding in setupTextView()
                self?.MedicalImagesCollectionView.reloadData()
            }.store(in: &cancellables)

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
}

// MARK: - UICollectionViewDataSource
extension ProfileMedicalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.medicalData?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MedicalImagesCollectionViewCell", for: indexPath) as! MedicalImagesCollectionViewCell
        
        if let image = viewModel.medicalData?.images[indexPath.item] {
            cell.configure(with: image)
            
            // Subscribe to delete publisher
            cell.deletePublisher
                .sink { [weak self] imageId in
                    self?.showDeleteConfirmation(imageId: imageId)
                }
                .store(in: &cell.cancellables)
        }
        
        return cell
    }
    
    private func showDeleteConfirmation(imageId: Int) {
        let alert = UIAlertController(title: "Delete Image", message: "Are you sure you want to delete this image?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteImage(id: imageId)
        })
        
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileMedicalViewController: UICollectionViewDelegate {
    // Add any additional delegate methods if needed
}

extension ProfileMedicalViewController{
    private func handleSucessViews(){
        let confirmationView = ConfirmationView(frame: view.bounds)
        confirmationView.setupView(message: AppLocalizedKeys.medicalInfoUpdated.localized, description: AppLocalizedKeys.medicalInfoUpdatedSuccesfully.localized)
        confirmationView.proceedActionPublisher
            .sink { [weak self] _ in
                self?.viewModel.navBack()
            }
            .store(in: &cancellables)
        // Add it to the view controller's view
        view.addSubview(confirmationView)
    }
}

// MARK: - ImageUploadDelegate
extension ProfileMedicalViewController: ImageUploadDelegate {
    func imageUploadDidComplete() {
        // Refresh medical data to show newly uploaded images
        // Pass false to preserve user's text input (don't overwrite text fields)
        viewModel.fetchMedicalData(updateTextFields: false)
    }
}
