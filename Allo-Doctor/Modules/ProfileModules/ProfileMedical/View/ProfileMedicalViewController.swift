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
    }

    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchMedicalData()
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
            .sink { [weak self] medicalData in
                self?.medicalHistoryTextView.text = medicalData?.medicalHistory
                self?.allergieTextView.text = medicalData?.allergy
                self?.medicineTextView.text = medicalData?.medication
                
                // Reload collection view when data changes
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
