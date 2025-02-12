//
//  LabsAndScanAppointmentViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/10/2024.
//

import UIKit

class LabsAndScanAppointmentViewController: BaseViewController<LabsAndScanAppointmentViewModel> {
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var confirmationButton: CustomButton!
    @IBOutlet weak var appoinmentStackView: UIStackView!
    @IBOutlet weak var appoinmentViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var datesDropDownList: CustomDropDownList!
    @IBOutlet weak var appointmentsCollectionViewDynamicHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarView: CalendarDropdownView!
    @IBOutlet weak private var appointmentsCollectionView: UICollectionView!
    @IBOutlet weak private var bookingTypeView: CustomToggleSwitch!
    var testType : String?
    private var selectedIndexPath: IndexPath?
    private var date:String?
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navback()
    }
    @IBAction func AppointmentConfirmation(_ sender: Any) {
        let seletedAppointment = viewModel.labAppointment?.original?[0]
        viewModel.navtoLabBooking(hourId: seletedAppointment?.appointmentHour?[selectedIndexPath?.row ?? 0].id ?? 0, dayId: seletedAppointment?.appointmentDay?.id ?? 0, date: date ?? viewModel.getCurrentDate())
    }
    override func setupUI() {
        setupCollectionView()
        confirmationButtonHandle(appointmentSelected: false)
        setupView()
    }

    override func viewDidLayoutSubviews() {
        bindCollectionViewHeight()
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
   
    override func bindViewModel() {
        bindDate()
        bindAppointments()
        viewModel.getAppointments(date:viewModel.getCurrentDate(), testType:"branch", day: viewModel.getCurrentDay())
        date = viewModel.getCurrentDate()
        setToggle()
        
    }
}
extension LabsAndScanAppointmentViewController{
    private  func setupCollectionView(){
        appointmentsCollectionView.dataSource = self
        appointmentsCollectionView.delegate = self
        appointmentsCollectionView.registerCell(cellClass: AppointmentCollectionViewCell.self)
    }
    private func setupView(){
        
        if viewModel.type == labAndScan.labs.rawValue{
            bookingTypeView.setToggleOptions([AppLocalizedKeys.branch.localized, AppLocalizedKeys.homeVisit.localized])
        }
        else {
            bookingTypeView.setToggleOptions([AppLocalizedKeys.branch.localized])
            
        }
    }
}
extension LabsAndScanAppointmentViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let original = viewModel.labAppointment?.original,
              !original.isEmpty,
              let appointmentHour = original.first?.appointmentHour else {
            return 1
        }
        return appointmentHour.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexpath: indexPath) as AppointmentCollectionViewCell

        // Safely get the appointment hour
        if let appointments = viewModel.labAppointment?.original?.first?.appointmentHour,
           appointments.indices.contains(indexPath.row) {
            
            let appointment = appointments[indexPath.row]
            let appointmentTimeText = appointment.from?.convertTo12HourFormat() ?? "--:--"

            if appointment.hasBooking == true {
                // Handle booked appointments
                cell.isUserInteractionEnabled = false
                cell.backgroundColor = .lightGray
                cell.appointmentLabel.textColor = .darkGray

                // Apply strikethrough to the text
                let attributedText = NSAttributedString(
                    string: appointmentTimeText,
                    attributes: [
                        .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                        .foregroundColor: UIColor.darkGray
                    ]
                )
                cell.appointmentLabel.attributedText = attributedText
            } else {
                // Handle available appointments
                cell.isUserInteractionEnabled = true
                cell.backgroundColor = indexPath == selectedIndexPath ? .appColor : .lightGreyD9D9D9
                cell.appointmentLabel.textColor = indexPath == selectedIndexPath ? .white : .black

                // Ensure no strikethrough for available cells
                cell.appointmentLabel.attributedText = nil
                cell.appointmentLabel.text = appointmentTimeText
            }
        } else {
            // Handle cases where appointments are nil or out of range
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = .lightGray
            cell.appointmentLabel.textColor = .darkGray
            cell.appointmentLabel.text = "NOT Available Appointments"
        }

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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        confirmationButtonHandle(appointmentSelected: true)
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let hours = viewModel.labAppointment?.original?.first?.appointmentHour?.count {
            if hours == 1 {
                return CGSize(width: collectionView.frame.width, height: 40)
            } else if hours == 2 {
                return CGSize(width: collectionView.frame.width * 0.5, height: 40)
            } else {
                return CGSize(width: collectionView.frame.width * 0.33333, height: 40)
            }
        } else {
            // Default case when hours is nil or data is not available
            return CGSize(width: collectionView.frame.width, height: 40)
        }

       }}
extension LabsAndScanAppointmentViewController{
    private func bindDate(){
        calendarView.dateSelection
                   .sink { [weak self] date in
                       self?.viewModel.getAppointments(date: date.formattedString, testType: self?.testType ?? "branch", day: self?.viewModel.getDayOfWeekInCairo(from: date.formattedString) ?? "")
                       self?.date = date.formattedString
                       self?.confirmationButtonHandle(appointmentSelected: false)
                   }
                   .store(in: &cancellables)
    }
    private func setToggle(){
        bookingTypeView.onToggle = { [weak self] selectedIndex in
                       guard let self = self else { return }
                       
                       switch selectedIndex {
                       case 0:
                           viewModel.testType = "branch"
                           viewModel.getAppointments(date:date ?? "", testType:"branch", day:viewModel.getDayOfWeekInCairo(from: date?.convertArabicDateToEnglish() ?? "") ?? "")
                           confirmationButtonHandle(appointmentSelected: false)
    

                       case 1:
                           viewModel.testType = "home"
                           viewModel.getAppointments(date:date ?? "", testType:"home", day:viewModel.getDayOfWeekInCairo(from: date?.convertArabicDateToEnglish() ?? "") ?? "")
                           confirmationButtonHandle(appointmentSelected: false)
                     
                       default:
                           break
                       }
                   }
        }
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
    func bindAppointments(){
        viewModel.$labAppointment
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.appointmentsCollectionView.reloadData()
            }.store(in: &cancellables)
    }
    private func confirmationButtonHandle(appointmentSelected:Bool){
        if appointmentSelected {
            confirmationButton.isUserInteractionEnabled = true
            confirmationButton.backgroundColor = .appColor
        }
        else{
            confirmationButton.backgroundColor = .grey6B7280
            confirmationButton.isUserInteractionEnabled = false
            selectedIndexPath = nil
        }
    }
}
