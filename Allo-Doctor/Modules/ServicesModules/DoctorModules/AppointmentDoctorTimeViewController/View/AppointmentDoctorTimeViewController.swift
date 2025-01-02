//
//  AppointmentDoctorTimeViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/10/2024.
//

import UIKit
class AppointmentDoctorTimeViewController: BaseViewController<AppointmentDoctorTimeViewModel> {
// MARK: - @IBOutlets
    @IBOutlet weak var appoinmentCollectionViewDynamicHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: CairoBold!
    @IBOutlet weak var confirmationButton: CustomButton!
    @IBOutlet weak var appointmentsCollectionView: UICollectionView!
    // MARK: - Proprties
    private var selectedIndexPath: IndexPath?
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    // override BaseViewControllerMethods
    override func setupUI() {
        SetupCollectionView()
    }

    override func bindViewModel() {
        viewModel.fetchDoctorData()
        bindAppointmentData()
    }
    override func viewDidLayoutSubviews() {
        bindCollectionViewHeight()
    }

    @IBAction func confirmationButtonAction(_ sender: Any) {
//        guard let hours = viewModel.doctorData?.appointments[0].hour[selectedIndexPath?.row ?? 0] else {return}
//        guard let doctorData = viewModel.doctorData else {return}
//        if selectedIndexPath != nil{
////            viewModel.navToDoctorConfirmation(doctorData:doctorData, appointmentDay: doctorData.appointments[0].day.nameEn, appointmentHour: hours)
//        }
//        else {return}
    }
    @IBAction func navBackButtonAction(_ sender: Any) {
        viewModel.navigationback()
    }
}
extension AppointmentDoctorTimeViewController{
   private func setupViewControllerUI(){
//        dateLabel.text = viewModel.doctorData?.appointments[0].day.nameEn
    }
   private func SetupCollectionView(){
       appointmentsCollectionView.dataSource = self
       appointmentsCollectionView.delegate = self
       appointmentsCollectionView.registerCell(cellClass: DoctorAppointmentsCollectionViewCell.self)
   }
    private func bindCollectionViewHeight() {
        appointmentsCollectionView.publisher(for: \.contentSize)
            .sink { [weak self] newSize in
                guard let self = self else { return }
                if self.appoinmentCollectionViewDynamicHeightConstraint.constant != newSize.height {
                    self.appoinmentCollectionViewDynamicHeightConstraint.constant = newSize.height
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
        
    }
}
// MARK: - CollectionView Methods
extension AppointmentDoctorTimeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexpath: indexPath) as DoctorAppointmentsCollectionViewCell
//        cell.appointmentTime.text = viewModel.doctorData?.appointments[0].hour[safe: indexPath.row]?.from.convertTo12HourFormat()
        if indexPath == selectedIndexPath {
            cell.backgroundColor = .appColor
                 cell.appointmentTime.textColor = .white
                } else {
                    cell.backgroundColor = .lightGreyD9D9D9
                    cell.appointmentTime.textColor = .black
                }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let appoinments = 3
        if appoinments == 1{
            return CGSize(width: collectionView.frame.width, height: 40)}
        else if appoinments == 2 {
            return CGSize(width: collectionView.frame.width*0.45, height: 40)
        }
    else {
        return CGSize(width: collectionView.frame.width * 0.315, height: 40)}
            
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        confirmationButton.backgroundColor = .appColor
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 5
      }

      // Set the minimum vertical spacing between rows of cells
      func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return 10
      }
       
    }
   


// MARK: - BindViewModel Data
extension AppointmentDoctorTimeViewController{
    func bindAppointmentData(){
        viewModel.$doctorData.receive(on: DispatchQueue.main)
            .sink { [weak self] doctors in
                self?.appointmentsCollectionView.reloadData()
                self?.setupViewControllerUI()
            }.store(in: &cancellables)
    }
}

