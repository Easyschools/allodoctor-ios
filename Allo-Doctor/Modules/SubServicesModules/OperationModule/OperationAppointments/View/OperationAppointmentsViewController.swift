//
//  OperationAppointmentsViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/11/2024.
//

import UIKit

class OperationAppointmentsViewController:BaseViewController<OperationAppointmentsViewModel> {
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var operationAppointmentsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Overided FunctionFrom baseViewController
    override func bindViewModel() {
        bindExternalClinicData()
        viewModel.getOperationData()
    }
    override func setupUI() {
//        bindCollectionViewHeight()
        setupCollectionView()
        setupUIView()
       
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
}
extension OperationAppointmentsViewController{
    private func setupUIView(){
        noteView.applyDropShadow()
    }
    private func setupCollectionView() {
        // Adjust collection view direction based on language
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
          
            operationAppointmentsCollectionView.semanticContentAttribute = .forceLeftToRight
        } else {
            operationAppointmentsCollectionView.semanticContentAttribute = .forceRightToLeft
        }
        
        // Register the cell
        operationAppointmentsCollectionView.registerCell(cellClass: OperationAppointmentsCollectionViewCell.self)
        operationAppointmentsCollectionView.delegate = self
        operationAppointmentsCollectionView.dataSource = self
    }

}
extension OperationAppointmentsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.generatedDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexpath: indexPath) as OperationAppointmentsCollectionViewCell

        guard indexPath.row < viewModel.generatedDates.count,
              indexPath.row < viewModel.generatedModels.count else {
            fatalError("Index out of bounds while accessing viewModel data")
        }
    
        let date = viewModel.generatedDates[indexPath.row].formatDate()
        let appointment = viewModel.generatedModels[indexPath.row]

        switch appointment.availability {
        case 0:
            cell.setupCell(
                day: appointment.day?.nameEn ?? "N/A",
                fromTo: "Not Available",
                date: date ?? "Not Available", isAvailable: false
            )
            cell.isSelected = false
        case 1: // Available
            cell.setupCell(
                day: appointment.day?.nameEn ?? "N/A",
                fromTo: appointment.from?.convertTo12HourFormat().prepend(appointment.to?.convertTo12HourFormat() ?? "", separator: "-") ?? "N/A"
                ,
                date: date ?? "Not Available", isAvailable: true
            )

        default:
            cell.setupCell(
                day: appointment.day?.nameEn ?? "N/A",
                fromTo: "Unknown",
                date: date ?? "Not Available", isAvailable: true
            )
           
        }

        return cell

    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedDate = viewModel.generatedDates[safe: indexPath.row]?.formatDateToPost() else { return }
        viewModel.showOperationBooking(date:selectedDate)
      
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
       }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 148, height: 180)
        }
     
}
// MARK: ViewModel Binding Appointments Data
extension OperationAppointmentsViewController{
   private func bindExternalClinicData(){
       viewModel.$generatedModels
            .receive(on: DispatchQueue.main)
            .sink { pharmacies in
                self.operationAppointmentsCollectionView.reloadData()
            }.store(in: &cancellables)
    }
}
