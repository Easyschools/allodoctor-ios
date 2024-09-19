//
//  SearchViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 15/09/2024.
//

import UIKit

class SearchViewController: BaseViewController<SearchViewModel> {
    // MARK: - @IBOutlets
    @IBOutlet weak private var searchTableView: UITableView!
    @IBOutlet weak private var upperView: UIView!
    @IBAction func navBackAction(_ sender: Any) {
    }
    // MARK: - VC LifeCycle & Override setupUI & bindVM functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false) 
        searchTableView.frame = .zero
        
    }
    override func setupUI() {
        setupTableView()
       
    }
    override func bindViewModel() {
        viewModel.fetchSpecialties(id:1)
        bindSpeciality()
    }
    override func viewWillLayoutSubviews() {
        upperView.roundCorners(corners: [.bottomLeft, .bottomRight], radius:Dimensions.upperViewBorderRaduis.rawValue)
        

        
    }
}
// MARK: - Setup TableView
extension SearchViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let specialties = viewModel.specialties[indexPath.row]
        let cell: SearchTableViewCell = tableView.dequeue(indexPath: indexPath)
//        cell.cellLabel.text = specialties.nameEn
        return cell
    }
    func setupTableView(){
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.registerCell(cellClass: SearchTableViewCell.self)
 
    }



}
extension SearchViewController{
    func bindSpeciality(){
        viewModel.$specialties
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.searchTableView.reloadData()
            }.store(in: &cancellables)
    }
    
}


