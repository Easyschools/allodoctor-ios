//
//  LabsAndScanProfileViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 25/09/2024.
//

import UIKit
import Kingfisher


class LabsAndScanProfileViewController: BaseViewController<LabsAndScanProfileViewModel> {
    // MARK: - Outlets
    @IBOutlet weak var searchBar: SearchView!
    @IBOutlet weak var totalPrice: CairoBold!
    @IBOutlet weak var noOfTestes: CairoRegular!
    @IBOutlet weak var searchForTestView: SearchView!
    @IBOutlet weak var upperView: CustomCornerRaduis!
    @IBOutlet weak var testTypesTableView: UITableView!
    @IBOutlet weak var bookingDetailsView: UIView!
    @IBOutlet weak var insuranceDropList: CustomDropDownList!
    @IBOutlet weak var labOrScanImage: UIImageView!
    
    // MARK: - Properties
    let coordintor = HomeCoordinator?.self
    private var imageUrl: String?
    private var screenType: String = ""
    
    // MARK: - Actions
    @IBAction func navBack(_ sender: Any) {
        viewModel.navigationBacK()
    }
    
    @IBAction func openInsurance(_ sender: Any) {
        let insuranceVC = InsuranceCompanyTableViewController()
        insuranceVC.delegate = self
        viewModel.coordinator?.presentModallyWithRoot(insuranceVC)
    }
    
    @IBAction func uploadPrescriptionAction(_ sender: Any) {
        viewModel.navToUploadPresc()
    }
    
    @IBAction func navToBookingPage(_ sender: Any) {
        viewModel.navToBookingAppointments()
    }
    
    @IBAction func callSupportAction(_ sender: Any) {
        viewModel.showNumberView(uiviewController: self)
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        bookingDetailsView.isHidden = true
        setupTableView()
        setupSearchBar()
        searchForTestView.searchTextfield.placeholder = AppLocalizedKeys.searchForTest.localized
        insuranceDropList.label.text = AppLocalizedKeys.SelectInsurance.localized
    }
    
    private func setupSearchBar() {
        searchForTestView.searchTextfield.addTarget(
            self,
            action: #selector(searchTextDidChange),
            for: .editingChanged
        )
    }
    
    @objc private func searchTextDidChange(_ textField: UITextField) {
        viewModel.filterTests(with: textField.text ?? "")
        testTypesTableView.reloadData()
    }
    
    override func bindViewModel() {
        viewModel.getLabData()
        bindViewModelImage()
        bindViewModelTests()
        BindTotalPriceView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupShadow()
    }
}

// MARK: - UI Setup
extension LabsAndScanProfileViewController {
    func setupShadow() {
        upperView.addLowerDropShadow()
    }
    
    func setupTableView() {
        testTypesTableView.dataSource = self
        testTypesTableView.delegate = self
        testTypesTableView.registerCell(cellClass: TestTypeTableViewCell.self)
//        testTypesTableView.applyDropShadow()
    }
}

// MARK: - TableView DataSource & Delegate
extension LabsAndScanProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayedTests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = testTypesTableView.dequeue(indexPath: indexPath) as TestTypeTableViewCell
        let test = viewModel.displayedTests[indexPath.row]
        
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
            cell.testTypeLabel.text = test.test.nameAr
        } else {
            cell.testTypeLabel.text = test.test.nameEn
        }
        
        cell.testPrice.text = (test.price ?? "0").appendingWithSpace(AppLocalizedKeys.EGP.localized)
        cell.selectionStyle = .none
        
        let isAdded = viewModel.isAdded(test: test)
        cell.configure(isAdded: isAdded)
        
        cell.onButtonTap = { [weak self] in
            self?.viewModel.toggleAdded(test: test)
            cell.updateButtonAppearance(isAdded: self?.viewModel.isAdded(test: test) ?? false)
            if (self?.viewModel.AddedItems.count) == 0 {
                self?.bookingDetailsView.isHidden = true
            } else {
                self?.bookingDetailsView.isHidden = false
                self?.BindTotalPriceView()
            }
        }
        
        return cell
    }
}

// MARK: - Data Binding
extension LabsAndScanProfileViewController {
    func bindViewModelImage() {
        viewModel.$imageUrl
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageUrl in
                self?.imageUrl = imageUrl
            }.store(in: &cancellables)
    }
    
    func bindViewModelTests() {
        viewModel.$labsAndScans
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.testTypesTableView.reloadData()
                let imageUrl = result?.mainImage
                self?.labOrScanImage.kf.setImage(with: URL(string: imageUrl ?? ""))
            }.store(in: &cancellables)
    }
    
    func BindTotalPriceView() {
        viewModel.$AddedItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tests in
                let tests = Array(tests)
                let total = tests.reduce(0.0) { $0 + Double((Double(($1.price ?? "0").replacingOccurrences(of: ",", with: "")) ?? 0)) }
                self?.totalPrice.text = String(format: "\(AppLocalizedKeys.EGP.localized) %.2f", total)
                
                let testCount = tests.count
                let testCountText = testCount == 1 ? AppLocalizedKeys.oneTest.localized: "\(testCount) \(AppLocalizedKeys.tests.localized)"
                self?.noOfTestes.text = AppLocalizedKeys.added.localized.appendingWithSpace(testCountText)
                
                self?.bookingDetailsView.isHidden = testCount == 0
            }.store(in: &cancellables)
    }
}

// MARK: - Insurance Delegate
extension LabsAndScanProfileViewController: InsuranceCompanyTableViewControllerDelegate {
    func insuranceCompanyTableViewController(_ controller: InsuranceCompanyTableViewController, didSelectItem item: InsuranceCompany) {
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
            insuranceDropList.label.text = item.name_ar
        } else {
            insuranceDropList.label.text = item.name_en
        }
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
    
    func insuranceCompanyTableViewControllerDidTapDismiss(_ controller: InsuranceCompanyTableViewController) {
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
}
