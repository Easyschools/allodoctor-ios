//
//  LabsAndScanAppointmentViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/10/2024.
//

import UIKit

class LabsAndScanAppointmentViewController: BaseViewController<LabsAndScanAppointmentViewModel> {
    

    @IBOutlet weak var appoinmentStackView: UIStackView!
    @IBOutlet weak var appoinmentViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var datesDropDownList: CustomDropDownList!
    @IBOutlet weak var appointmentsCollectionViewDynamicHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var appointmentsCollectionView: UICollectionView!
    @IBOutlet weak private var bookingTypeView: CustomToggleSwitch!
    var arrinsurance = ["AXA", "Misr Insurance", "Good life Insurance"]
    override func viewDidLoad() {
        super.viewDidLoad()
        bookingTypeView.setToggleOptions(["Branch", "Home Visit"])
        
     
    }
    @IBAction func AppointmentConfirmation(_ sender: Any) {
    }
    override func setupUI() {
        setupCollectionView()
      
       
//        appointmentStackView.addLowerDropShadow()
  
    
    }

    override func viewDidLayoutSubviews() {
        bindCollectionViewHeight()

    }
   
    override func bindViewModel() {
        
    }
}
extension LabsAndScanAppointmentViewController{
    func setupCollectionView(){
        appointmentsCollectionView.dataSource = self
        appointmentsCollectionView.delegate = self
        appointmentsCollectionView.registerCell(cellClass: AppointmentCollectionViewCell.self)
    }
}
extension LabsAndScanAppointmentViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexpath: indexPath) as AppointmentCollectionViewCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        if  == 1{
        //            return CGSize(width: collectionView.frame.width, height: 40)}
        //        else if appoinments == 2 {
        //            return CGSize(width: collectionView.frame.width*0.45, height: 40)
        //        }
        //    else {
        return CGSize(width: collectionView.frame.width * 0.33333, height: 40)}
    
            
}
extension LabsAndScanAppointmentViewController{
    private func bindCollectionViewHeight() {
        appointmentsCollectionView.publisher(for: \.contentSize)
            .sink { [weak self] newSize in
                guard let self = self else { return }
                if self.appointmentsCollectionViewDynamicHeightConstraint.constant != newSize.height {
                    self.appointmentsCollectionViewDynamicHeightConstraint.constant = newSize.height
                    self.appoinmentViewConstraintHeight.constant = self.appoinmentStackView.intrinsicContentSize.height
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
    }
}
