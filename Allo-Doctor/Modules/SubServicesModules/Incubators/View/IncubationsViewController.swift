//
//  IncubationsViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/11/2024.
//

import UIKit
import PhotosUI
class IncubationsViewController: BaseViewController<IncubationsViewModel>, PHPickerViewControllerDelegate {

    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var yearsDropDownView: DropdownView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var daysDropDownView: DropdownView!
    @IBOutlet weak var monthDropDownView: DropdownView!
    @IBOutlet weak var reportImage: UIImageView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var deleteImageButton: UIButton!
    @IBOutlet weak var navBackButton: CustomNavigationBackButton!
    private var isAreaSelected  = false
    override func viewDidLoad() {
        super.viewDidLoad() 
        viewModel.loadSavedImage()
    
    }
   
     
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    @IBAction func selectAreaAction(_ sender: Any) {
        let citiesVC = SectionSearchableTableViewController(cityData: viewModel.cities)
        citiesVC.delegate = self
        viewModel.coordinator?.presentModallyWithRoot(citiesVC)
    }
    override func bindViewModel() {
        bindVM()
        viewModel.getAllAreaOfResidence()
        bindVm()
        handleViewModelResponse()
     
    }


    override func setupUI() {
        deleteImageButton.isHidden = true
        monthDropDownView.configure(with: DateConstants.months, placeholder:AppLocalizedKeys.Month.localized)
        yearsDropDownView.configure(with: DateConstants.years, placeholder:AppLocalizedKeys.Year.localized)
        daysDropDownView.configure(with: DateConstants.days, placeholder:AppLocalizedKeys.Day.localized)
        navBackButton.setTitleColor(.black, for: .normal)
        navBackButton.tintColor = .black
        navBackButton.setTitle(AppLocalizedKeys.Incubations.localized)
     
    }
    override init(viewModel: IncubationsViewModel) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Load View
    override func loadView() {
        // Load the view from the XIB
        if let nibView = Bundle.main.loadNibNamed("IntensiveCareAndIncubators", owner: self, options: nil)?.first as? UIView {
            self.view = nibView
        } else {
         return
        }
    }
    
    @IBAction func deleteImageButtonAction(_ sender: Any) {
        viewModel.deleteImage()
    }
    @IBAction func ConfirmationBookingAction(_ sender: Any) {
        guard validateInputs() == false else{
            LoadingIndicator.shared.show()
            viewModel.confirmBooking()
            return
        }

    }
    @IBAction func openImagePicker(_ sender: Any) {
        openImagePicker()
    }
}
extension IncubationsViewController{
   private func bindVM(){
        viewModel.$selectedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.reportImage.image = image
                self?.deleteImageButton.isHidden = (image == nil)
            }
            .store(in: &cancellables)
  
       
    }
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
    @objc private func deleteImage() {
           viewModel.deleteImage()
       }
   
}
extension IncubationsViewController{
   private func bindVm(){
        nameTextField.bindText(to: viewModel.name, storeIn: &cancellables)
        phoneTextField.bindText(to: viewModel.phone, storeIn: &cancellables)
        
        daysDropDownView.selectionPublisher
            .sink { [weak self] day in
                self?.viewModel.day.value = day
            }
            .store(in: &cancellables)
        monthDropDownView.selectionPublisher
            .sink { [weak self] month in
                let month = month.monthNumber()
                self?.viewModel.month.value = month?.toString() ?? ""
            }
            .store(in: &cancellables)
        yearsDropDownView.selectionPublisher
            .sink { [weak self] year in
                self?.viewModel.year.value = year
            }
        .store(in: &cancellables)}
}
extension IncubationsViewController:SectionSearchableTableViewControllerDelegate {
    func sectionSearchableTableViewController(_ controller: SectionSearchableTableViewController, didSelectDistrictWithID id: Int, districtName name: String) {
        
        areaLabel.text = name
        viewModel.districtId.value = id
        isAreaSelected = true
        
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
    
    func sectionSearchableTableViewControllerDidTapDismiss(_ controller: SectionSearchableTableViewController) {
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
}
extension IncubationsViewController{
private func handleViewModelResponse(){
    viewModel.$status
               .receive(on: DispatchQueue.main)
               .sink { status in
                   guard let status = status else { return }
                   switch status {
                   case .success:
                       LoadingIndicator.shared.hide()
                       self.handleSucessViews()
                   case .failure:
                       AlertManager.showAlert(on: self, title: AppLocalizedKeys.error.localized, message:  AppLocalizedKeys.somethingHappen.localized)
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
}
extension IncubationsViewController{
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
        guard let phone = phoneTextField.text, !phone.isEmpty else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidNumber.localized, message: AppLocalizedKeys.phoneEmpty.localized)
            return false
        }
        
        guard phone.isValidEgyptianNumber else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidNumber.localized, message: AppLocalizedKeys.phoneRejecs.localized)
            return false
        }
        guard !viewModel.day.value.isEmpty else {
            AlertManager.showAlert(on: self, title: "Error", message: "Please select a valid day.")
            return false
        }
        
//        guard !viewModel.month.value.isEmpty else {
//            AlertManager.showAlert(on: self, title: "Error", message: "Please select a valid month.")
//            return false
//        }
        
        guard !viewModel.year.value.isEmpty else {
            AlertManager.showAlert(on: self, title: "Error", message: "Please select a valid year.")
            return false
        }
        // Validate area selection
        guard isAreaSelected == true else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.selectArea.localized, message: AppLocalizedKeys.selectArea.localized)
            return false
        }
        guard reportImage.image != nil else {
            AlertManager.showAlert(on: self, title:AppLocalizedKeys.uploadPrescription.localized, message:AppLocalizedKeys.uploadPrescriptionFirst.localized)
            return false
        }
        
        return true
    }
}
