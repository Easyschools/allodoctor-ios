//
//  OneDayCareAppointmentsViewViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 27/12/2024.
//

import UIKit

class OneDayCareAppointmentsViewController: BaseViewController<OneDayCareAppointmentsViewModel> {
    @IBOutlet weak var oneDayCareCollectionView: UICollectionView!
    @IBOutlet weak var upperView: UIView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Overided FunctionFrom baseViewController
    override func bindViewModel() {
        bindExternalClinicData()
        viewModel.getAppointmentsData()
        
    }
    override func setupUI() {
   
        setupCollectionView()

       
    }
    
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
}
extension OneDayCareAppointmentsViewController{
  
    private func setupCollectionView(){
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
          
            oneDayCareCollectionView.semanticContentAttribute = .forceLeftToRight
        } else {
            oneDayCareCollectionView.semanticContentAttribute = .forceRightToLeft
        }
        oneDayCareCollectionView.registerCell(cellClass: OperationAppointmentsCollectionViewCell.self)
        oneDayCareCollectionView.delegate = self
        oneDayCareCollectionView.dataSource = self
    }

}
extension OneDayCareAppointmentsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
        let appointments = viewModel.generatedModels[indexPath.row]
        switch appointments.availability {
        case 0: // Not available
            cell.setupCell(
                day: appointments.day?.nameEn ?? "N/A",
                fromTo: "Not Available",
                date: date ?? "Not Available", isAvailable: false
            )
            cell.isSelected = false
        case 1: // Available
            cell.setupCell(
                day: appointments.day?.nameEn ?? "N/A",
                fromTo: viewModel.hospitalAppointment?.data.from?.convertTo12HourFormat().prepend(viewModel.hospitalAppointment?.data.to?.convertTo12HourFormat() ?? "", separator: "-") ?? "N/A",
               
                date: date ?? "Not Available", isAvailable: true
            )

        default: // Handle unexpected availability values
            cell.setupCell(
                day: appointments.day?.nameEn ?? "N/A",
                fromTo: "Unknown",
                date: date ?? "Not Available", isAvailable: true
            )
           
        }

        return cell

    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hospitalData = viewModel.hospitalAppointment!

        let id = viewModel.generatedModels[indexPath.row].id ?? 0
        guard let selectedDate = viewModel.generatedDates[safe: indexPath.row]?.formatDateToPost() else { return }
        viewModel.showOneDayCareBooking(date: selectedDate, dayServiceId: id, hospitalData:hospitalData)
      
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
extension OneDayCareAppointmentsViewController{
   private func bindExternalClinicData(){
       viewModel.$generatedModels
            .receive(on: DispatchQueue.main)
            .sink { pharmacies in
                self.oneDayCareCollectionView.reloadData()
            }.store(in: &cancellables)
       viewModel.$hospitalAppointment
           .receive(on: DispatchQueue.main)
           .sink { pharmacies in
               self.oneDayCareCollectionView.reloadData()
           }.store(in: &cancellables)
    }
}
