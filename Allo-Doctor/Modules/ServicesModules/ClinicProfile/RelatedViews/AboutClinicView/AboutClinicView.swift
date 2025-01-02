//
//  AboutClinicView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import UIKit

class AboutClinicView: UIView {
    // MARK: - Private Outlets
    @IBOutlet weak private var clinicBranchesTableView: UITableView!
    @IBOutlet weak private var clinicDescription: CairoRegular!
    @IBOutlet weak private var clinicSpecialityTableView: UITableView!
    @IBOutlet weak private var clinicBranchesDynamicString: NSLayoutConstraint!
    @IBOutlet weak private var clinicSpecialityDynamicString: NSLayoutConstraint!
    // MARK: - Proprties
    var aboutClinicPublisher: AnyPublisher<Clinic?, Never>?
    private var clinicData: Clinic?
    private var cancellables = Set <AnyCancellable>()
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        bindData()
        setuptableViews()
//        bindData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        bindData()
        setuptableViews()
//        bindData()
    }
    
    // MARK: - Setup Methods
    private func commonInit(){
        self.addXibSubview(named: ClinicProfileViews.aboutClinicView.rawValue)
        bindData()
    }
}
// MARK: - DataBinding
extension AboutClinicView{
    func bindData() {
        aboutClinicPublisher?
            .receive(on: DispatchQueue.main)
            .sink { [weak self] clinicData in
                self?.clinicData = clinicData
                self?.clinicBranchesTableView.reloadData()
                self?.clinicSpecialityTableView.reloadData()
                self?.setupUI()
            }
            .store(in: &cancellables)
    }
}
// MARK: - Setup UI
extension AboutClinicView{
    private func setupUI(){
        clinicDescription.text = clinicData?.descriptionEn
    }
    private func setuptableViews(){
        // Clinic specialities TableView Setup
        clinicSpecialityTableView.delegate = self
        clinicSpecialityTableView.dataSource = self
        clinicSpecialityTableView.registerCell(cellClass: ClinicAboutTableViewCell.self)
        // Clinic Branches TableView Setup
        clinicBranchesTableView.delegate = self
        clinicBranchesTableView.dataSource = self
        clinicBranchesTableView.registerCell(cellClass: ClinicAboutTableViewCell.self)
    }
    
    
}
// MARK: - TableView Methods
extension AboutClinicView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == clinicSpecialityTableView {
            return clinicData?.specialties.count ?? 0
        }
        else {
            return clinicData?.branches.count ?? 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath: indexPath) as ClinicAboutTableViewCell
        if tableView == clinicSpecialityTableView {
            cell.infoLabel.text = clinicData?.specialties[indexPath.row].name
            return cell
        }
        else {
            cell.infoLabel.text = clinicData?.branches[indexPath.row].name
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 26
    }

   
}
