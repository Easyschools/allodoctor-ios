//
//  ClinicInsuranceView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 06/10/2024.
//

import UIKit
class ClinicInsuranceView: UIView {
    
    // MARK: - Properties
    @IBOutlet weak var insurancesTableView: UITableView!
    private var cancellables = Set<AnyCancellable>()
    var doctors : [ClinicDoctor]?
    var insurances = ["Axa","MedLife","misrInsurance","AXA Egypt","NEXT CARE", "Care Insurance"]
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupTableView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupTableView()
        
    }
    private func commonInit(){
        self.addXibSubview(named: ClinicProfileViews.clinicInsuranceView.rawValue)
//        bindData()
    }
}
extension ClinicInsuranceView {
    func setupTableView(){
        insurancesTableView.delegate = self
        insurancesTableView.dataSource = self
        insurancesTableView.registerCell(cellClass: BulletPointsTableViewCell.self)
    }
}
extension ClinicInsuranceView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return insurances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath: indexPath) as BulletPointsTableViewCell
        cell.cellLabel.text = insurances[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }

}
