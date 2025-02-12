//
//  IntensiveCareUnitsViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 20/12/2024.
//

import UIKit

class IntensiveCareUnitsViewController: BaseViewController<IntensiveCareUnitsViewModel> {
 
    @IBOutlet weak var continueButton: CustomButton!
    @IBOutlet weak var navBackButton: CustomNavigationBackButton!
    @IBOutlet weak var unitsTableView: UITableView!
    private let units: [AppLocalizedKeys] = [
        .adultsICU,
        .pediatricICU,
        .neonatalICU
    ]
    private var selectedIndex: Int? 
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
    }
    override func setupUI() {
        continueButton.backgroundColor = .grey6B7280
        continueButton.isUserInteractionEnabled = false
        navBackButton.setTitleColor(.black, for: .normal)
        navBackButton.tintColor = .black
        navBackButton.setTitle(AppLocalizedKeys.InstensiveCare.localized)
        setuptableView()
        continueButton.setTitle(AppLocalizedKeys.Confirm.localized, for: .normal)
    }
    @IBAction func continueButtonAction(_ sender: Any) {
        viewModel.navToIntensiveCareBooking()
    }
    @IBAction func navBackButtonAction(_ sender: Any) {
        viewModel.navBack()
    }
    private func setuptableView(){
        unitsTableView.delegate = self
        unitsTableView.dataSource = self
        unitsTableView.registerCell(cellClass: IntensiveCareUnitsTableViewCell.self)
        unitsTableView.separatorStyle = .none
        unitsTableView.separatorInset = .zero
        unitsTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 8, right: 0)

    }

  

}
extension IntensiveCareUnitsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return units.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath: indexPath) as IntensiveCareUnitsTableViewCell
        
        let isSelected = indexPath.row == selectedIndex
        cell.configure(with: units[indexPath.row].localized, isSelected: isSelected)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        continueButton.backgroundColor = .appColor
        continueButton.isUserInteractionEnabled = true
        viewModel.selectedUnit.value = units[indexPath.row].rawValue
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
}
