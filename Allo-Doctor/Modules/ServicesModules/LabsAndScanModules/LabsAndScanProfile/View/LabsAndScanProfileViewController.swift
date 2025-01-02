//
//  LabsAndScanProfileViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 25/09/2024.
//

import UIKit
import Kingfisher
class LabsAndScanProfileViewController: BaseViewController<LabsAndScanProfileViewModel> {
    @IBOutlet weak var totalPrice: CairoBold!
    @IBOutlet weak var noOfTestes: CairoRegular!
    let coordintor = HomeCoordinator?.self
    @IBOutlet weak var searchForTestView: SearchView!
    @IBOutlet weak var upperView: CustomCornerRaduis!
    
    @IBOutlet weak var testTypesTableView: UITableView!
    @IBOutlet weak var bookingDetailsView: UIView!
    @IBOutlet weak var insuranceDropList: CustomDropDownList!
    @IBOutlet weak var labOrScanImage: UIImageView!
    private var imageUrl: String?
    private var screenType: String = ""
    var arrinsurance = ["AXA", "Misr Insurance", "Good life Insurance"]
    
    @IBAction func navBack(_ sender: Any) {
        viewModel.navigationBacK()
    }
//     MARK: - Initializers

    @IBAction func bookByPrescriptionAction(_ sender: Any) {


    }

    @IBAction func navToBookingPage(_ sender: Any) {
        viewModel.navToBookingTests()
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getLabData()
        bookingDetailsView.isHidden = true
        bindViewModelImage()
        bindViewModelTests()
        setupTableView()
        // Set placeholder text for the search text field
        searchForTestView.searchTextfield.placeholder = "Search for Lab test"

        insuranceDropList.items = arrinsurance
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        insuranceDropList.setDropdownHeight(200)
        setupShadow()
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupShadow()
    }

}

// MARK: - Shadow Setup
extension LabsAndScanProfileViewController {
    func setupShadow() {
     
        upperView.addLowerDropShadow()
       
    }
    func setupTableView() {
        testTypesTableView.dataSource = self
        testTypesTableView.delegate = self
        testTypesTableView.registerCell(cellClass: TestTypeTableViewCell.self)
    }
}

extension LabsAndScanProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.labsAndScans?.types?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = testTypesTableView.dequeue(indexPath: indexPath) as TestTypeTableViewCell
        cell.testTypeLabel.text = viewModel.labsAndScans?.types?[indexPath.row].nameEn
        cell.testPrice.text =  viewModel.labsAndScans?.types?[indexPath.row].price
        cell.selectionStyle = .none
        let test = viewModel.labsAndScans?.types?[safe: indexPath.row]!
        let isAdded = viewModel.isAdded(test: test!)
             
             cell.configure(isAdded: isAdded)
             
             cell.onButtonTap = { [weak self] in
                 self?.viewModel.toggleAdded(test: test!)
                 cell.updateButtonAppearance(isAdded: self?.viewModel.isAdded(test: test!) ?? false)
                 if (self?.viewModel.AddedItems.count) == 0
                 {
                     self?.bookingDetailsView.isHidden = true
                 }
                 else{
                     self?.bookingDetailsView.isHidden = false
                     self?.BindTotalPriceView()}
             }
             
        return cell
    }
    
}
extension LabsAndScanProfileViewController{
    func bindViewModelImage(){
        viewModel.$imageUrl
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageUrl in
                self?.imageUrl = imageUrl
                
            }.store(in: &cancellables)
    }
    func bindViewModelTests(){
        viewModel.$labsAndScans
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.testTypesTableView.reloadData()
                let imageUrl = result?.mainImage
                self?.labOrScanImage.kf.setImage(with: URL(string: imageUrl ?? ""))
            }.store(in: &cancellables)
    }
    func BindTotalPriceView(){
        viewModel.$AddedItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tests in
                let tests = Array(tests)
                let total = tests.reduce(0.0) { $0 + (Double($1.price) ?? 0.0) }
                self?.totalPrice.text = String(format: "%.2f", total).prepend("Total ")
                self?.noOfTestes.text = String(tests.count).prepend("Added Tests:")
            }.store(in: &cancellables)
        
    }
}

