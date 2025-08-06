//
//  AppointmentDoctorTimeViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/10/2024.
//

import UIKit
class AppointmentDoctorTimeViewController: BaseViewController<AppointmentDoctorTimeViewModel> {
    // MARK: - @IBOutlets
    @IBOutlet weak var upperView: UIView!
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
        viewModel.fetchDoctorAppointment()
        bindAppointmentData()
    }
    override func viewDidLayoutSubviews() {
        bindCollectionViewHeight()
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }

    @IBAction func confirmationButtonAction(_ sender: Any) {
        guard let hours = viewModel.doctorData?[0].appointmentHour?[selectedIndexPath?.row ?? 0] else {return}
        guard let doctorData = viewModel.doctor else {return}
        if selectedIndexPath != nil{
            viewModel.navToBookingScreen(hour:hours, appoimentDayHourId:viewModel.doctorData?[0].id ?? 0 , doctor:doctorData)
        }
        else {return}
    }
    @IBAction func navBackButtonAction(_ sender: Any) {
        viewModel.navigationback()
    }
}
extension AppointmentDoctorTimeViewController{
   private func setupViewControllerUI(){
       if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
           dateLabel.text = viewModel.date.prepend(viewModel.day.convertDayToArabic(), separator: " ")
       }
       else{
           dateLabel.text = viewModel.date.prepend(viewModel.day, separator: " ")}
       
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
        return viewModel.doctorData?.first?.appointmentHour?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexpath: indexPath) as DoctorAppointmentsCollectionViewCell
          
          // Get the appointment hour
          let appointmentHour = viewModel.doctorData?[0].appointmentHour?[indexPath.row]
          
          // Safely convert the time to 12-hour format
        let appointmentTimeText = appointmentHour?.from?.convertTo12HourFormat().appendingWithSpace("-").appendingWithSpace(appointmentHour?.to?.convertTo12HourFormat() ?? "--") ?? "--:--"
          
          // Check if the appointment has been booked
          if appointmentHour?.hasBooking == true {
              cell.isUserInteractionEnabled = false
              cell.backgroundColor = .lightGray
              cell.appointmentTime.textColor = .darkGray
              
              // Apply strikethrough to the text
              let attributedText = NSAttributedString(
                  string: appointmentTimeText,
                  attributes: [
                      .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                      .foregroundColor: UIColor.darkGray
                  ]
              )
              cell.appointmentTime.attributedText = attributedText
          } else {
              // Revert styles for selectable cells
              cell.isUserInteractionEnabled = true
              cell.backgroundColor = indexPath == selectedIndexPath ? .appColor : .lightGreyD9D9D9
              cell.appointmentTime.textColor = indexPath == selectedIndexPath ? .white : .black
              
              // Ensure no strikethrough for available cells
              cell.appointmentTime.attributedText = nil
              cell.appointmentTime.text = appointmentTimeText
          }
          
          return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let appoinments = viewModel.doctorData?[0].appointmentHour?.count
        if appoinments == 1 {
            return CGSize(width: collectionView.frame.width, height: 40)}
        else {
            return CGSize(width: collectionView.frame.width*0.45, height: 40)
        }
//    else {
//        return CGSize(width: collectionView.frame.width * 0.315, height: 40)}
//            
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

