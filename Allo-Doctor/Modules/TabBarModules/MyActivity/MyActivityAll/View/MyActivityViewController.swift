//
//  MyActivityViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/09/2024.
//

import UIKit

class MyActivityViewController: BaseViewController<MyActivityViewModel> {
    
    @IBOutlet weak var noActivityLabel: CairoBold!
    @IBOutlet weak var noActivityImage: UIImageView!
    @IBOutlet weak var notAvailableView: UIStackView!
    @IBOutlet weak var actvityTableView: UITableView!
    @IBOutlet weak var customSwitch: CustomToggleSwitch!
    var index : Int?
    override func viewDidLoad() {
    super.viewDidLoad()
        LoadingIndicator.shared.show()
    customSwitch.onToggle = { [weak self] selectedIndex in
                   guard let self = self else { return }
                   
                   switch selectedIndex {
                   case 0:
                       index = selectedIndex
                       viewModel.fetchMyBookings()
                       bindAppointments()
                   case 1:
                       index = selectedIndex
                       viewModel.fetchOrders()
                       bindOrders()
                   default:
                       break
                   }
               }
           }
    
    override func setupUI() {
        self.notAvailableView.isHidden = true

    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchMyBookings()
        setupViewUI()
        setupTableView()
        bindAppointments()
        viewModel.fetchOrders()
        bindOrders()
    }

}
extension MyActivityViewController{
    func setupViewUI(){
        let options =  [AppLocalizedKeys.appointments.localized,AppLocalizedKeys.orders.localized]
        customSwitch.setToggleOptions(options)
    }
  func setupTableView(){
      actvityTableView.delegate = self
      actvityTableView.dataSource = self
      actvityTableView.registerCell(cellClass: MyActivityTableViewCell.self)
    }
}

extension MyActivityViewController{
private func bindAppointments(){
    viewModel.$monthSections
        .receive(on: DispatchQueue.main)
        .sink { [weak self] booking in
            if booking.isEmpty == true {
                self?.noActivityImage.image = .appointmentsPlaceHolder
                self?.noActivityLabel.text = AppLocalizedKeys.noAppointments.localized
                self?.notAvailableView.isHidden = false
            }
            else{
                self?.notAvailableView.isHidden = true
            }
            self?.actvityTableView.reloadData()
            LoadingIndicator.shared.hide()
        }.store(in: &cancellables)
    }
    private func bindOrders(){
        viewModel.$orders
            .receive(on: DispatchQueue.main)
            .sink { [weak self] orders in
                self?.actvityTableView.reloadData()
                if orders?.isEmpty == true {
//                    self?.noActivityImage.image = .noOrdersPlaceHolder
//                    self?.noActivityLabel.text = AppLocalizedKeys.noOrdersYet.localized
//                    self?.notAvailableView.isHidden = false
                }
                else{
                    
                    self?.notAvailableView.isHidden = true
                }
                LoadingIndicator.shared.hide()
            }.store(in: &cancellables)
        }
   
}
extension MyActivityViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if index == 1{
            return viewModel.ordersSections.count
        }
        else{
            return viewModel.monthSections.count}
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if index == 1{
            return viewModel.ordersSections[section].month
        }
        else{
            return viewModel.monthSections[section].month}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if index == 1{
            return viewModel.ordersSections[section].orders.count
        }
        else{
            return viewModel.monthSections[section].bookings.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(indexPath: indexPath) as MyActivityTableViewCell? else {
            return UITableViewCell()
        }
        if index == 1{
            let order = viewModel.ordersSections[indexPath.section].orders[indexPath.row]
            if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
                cell.setupCell(name: order.pharmacy?.nameAr ?? "", date:  order.createdAt ?? "", appointmentNumber: order.id?.toString() ?? "", image: .pharmacyLogo, status: order.orderStatus?.nameEn ?? "")
            }
            else{
                cell.setupCell(name: order.pharmacy?.nameEn ?? "", date:  order.createdAt ?? "", appointmentNumber: order.id?.toString() ?? "", image: .pharmacyLogo, status: order.orderStatus?.nameEn ?? "")}
        }
        else{
            
            
            let booking = viewModel.monthSections[indexPath.section].bookings[indexPath.row]
            if booking.typeOfBooking == "booking" {
                if UserDefaultsManager.sharedInstance.getLanguage() == .ar { cell.appointmentName.text = booking.doctor?.doctorServiceSpecialty?.doctor?.nameAR?.capitalized
                    cell.setupCell(name: booking.doctor?.doctorServiceSpecialty?.doctor?.nameAR?.capitalized ?? "" , date: booking.date ?? "No date", appointmentNumber: booking.id.toString().prepend("#"), image: .doctorOfferIcon, status: booking.status ?? "pending")}
                else{
                    cell.appointmentName.text = booking.doctor?.doctorServiceSpecialty?.doctor?.nameEn?.capitalized
                    cell.setupCell(name: booking.doctor?.doctorServiceSpecialty?.doctor?.nameEn?.capitalized ?? "" , date: booking.date ?? "No date", appointmentNumber: booking.id.toString().prepend("#"), image: .doctorOfferIcon, status: booking.status ?? "pending")}
            }
            else if booking.typeOfBooking == "labBookings" {
                if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
                    cell.setupCell(name: booking.lab?.labDetails?.nameAr ?? "", date: booking.date ?? "No date", appointmentNumber: booking.id.toString().prepend("#"), image: .labLogo, status: booking.status ?? "pending")
                }
                else{
                    cell.setupCell(name: booking.lab?.labDetails?.nameEn ?? "", date: booking.date ?? "No date", appointmentNumber: booking.id.toString().prepend("#"), image: .labLogo, status: booking.status ?? "pending")
                    
                }}
                else if booking.typeOfBooking == "homeVisitBooking"{
                    cell.setupCell(name: AppLocalizedKeys.homeVisit.localized, date: booking.createdAt?.fullDateFormatter() ?? "No date", appointmentNumber: booking.id.toString().prepend("#"), image: .homeVisit, status: booking.status ?? "pending")
                }
                else if booking.typeOfBooking == "nurseVisitBooking"{
                    cell.setupCell(name: "Nursery Visit", date: booking.createdAt?.fullDateFormatter() ?? "No date", appointmentNumber: booking.id.toString().prepend("#"), image: .nurse, status: booking.status ?? "pending")
                }
                else if booking.typeOfBooking == "operationBookings"{
                    if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
                        cell.setupCell(name: booking.operation_service?.operation?.nameAr ?? "", date: booking.createdAt?.fullDateFormatter() ?? "No date", appointmentNumber: booking.id.toString().prepend("#"), image: .operation, status: booking.status ?? "pending")
                    }
                    else{
                        cell.setupCell(name: booking.operation_service?.operation?.nameEn ?? "", date: booking.createdAt?.fullDateFormatter() ?? "No date", appointmentNumber: booking.id.toString().prepend("#"), image: .operation, status: booking.status ?? "pending")}
                }
                else if booking.typeOfBooking == "intensiveCareBooking"{
                    cell.setupCell(name: AppLocalizedKeys.InstensiveCare.localized, date: booking.createdAt?.fullDateFormatter() ?? "No date", appointmentNumber: booking.id.toString().prepend("#"), image: .intesiveCare, status: booking.status ?? AppLocalizedKeys.pending.localized)
                }
            else if booking.typeOfBooking == "emergencyBooking"{
    
                cell.setupCell(name: AppLocalizedKeys.Ambulance.localized, date: booking.createdAt?.fullDateFormatter() ?? "No date", appointmentNumber: booking.id.toString().prepend("#"), image: .operation , status: booking.status ?? AppLocalizedKeys.pending.localized)
            }
            
            }
            cell.selectionStyle = .none
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if index == 1{
                let order = viewModel.ordersSections[indexPath.section].orders[indexPath.row]
                viewModel.showOrderDetails(order: order)
            }
            else{
                let booking = viewModel.monthSections[indexPath.section].bookings[indexPath.row]
                viewModel.ShowAppointmentsDetails(booking:booking)}
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 84
        }
    }

