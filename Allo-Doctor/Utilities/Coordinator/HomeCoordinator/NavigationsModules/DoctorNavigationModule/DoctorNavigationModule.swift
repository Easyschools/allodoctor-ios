//
//  DoctorNavigationModule.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 09/01/2025.
//

// MARK: - Doctor Modules Navigations
import UIKit
extension HomeCoordinator{
    func showDoctorProfile(doctorID:String) {
        let viewModel = DoctorProfileViewModel(coordinator: self, doctorId: doctorID)
        let viewController = DoctorProfileViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    func showDoctorSearch(specialityId:String,externalClinicServiceId:String) {
        let viewModel = DoctorSearchViewModel(coordinator: self, specialityId: specialityId, externalClinicServiceId: externalClinicServiceId.toInt())
        let viewController = DoctorSearchViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    func  showDoctorConfirmationScreen (doctorData: DoctorProfile,appointmentDay: String,appoinmentHour: DoctorAppointmentHour,doctorServiceSpecialtyId: Int,date:String){
        let viewModel = BookingConfirmationViewModel(coordinator:self,doctorData: doctorData, appointmentDay: appointmentDay, appoinmentHour: appoinmentHour, doctorServiceSpecialtyId: doctorServiceSpecialtyId, date: date)
        let viewController = BookingConfirmationViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    func showDoctorAppointmentsScreen(docotor:DoctorProfile,date:String,day:String,doctorServiceSpecialtyId:Int){
        let viewModel = AppointmentDoctorTimeViewModel(coordinator: self, doctor: docotor ,date:date,day:day,doctorServiceSpecialtyId:doctorServiceSpecialtyId)
        let viewController = AppointmentDoctorTimeViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
}

// MARK: - labs and scan modules Navigations
extension HomeCoordinator{
    func showLabsAndScanBookingAppointments(labId:Int,tests:[LabTestType],type:String) {
        let viewModel = LabsAndScanAppointmentViewModel(coordinator:self,tests: tests, labId: labId, type: type)
        let viewController =  LabsAndScanAppointmentViewController(viewModel:viewModel)
        
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    func navToLabsAndScanSearchScreen(type:String) {
        let viewModel = LabsSearchScreenViewModel(coordinator: self, screenType: type)
        let viewController = LabsSearchScreenViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }

    func showLabsAndScanProfile(url: String,type:String,id:Int) {
        let viewModel = LabsAndScanProfileViewModel(coordinator:self,imageUrl:url,screenType:type, id: id)
        let viewController = LabsAndScanProfileViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
   
   
    func showLabsAndScanBooking(tests:[LabTestType],hourId:Int,dayId:Int,date:String,labId:Int,bookingType:String){
        let viewModel = BookingLabsAndScanViewModel(coordinator:self,tests:tests, hourId: hourId, dayId: dayId, date: date, labId:labId,bookingType:bookingType)
       let viewController = BookingLabsAndScanViewController(viewModel: viewModel)
       if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
             navController.pushViewController(viewController, animated: true)
         }
       
    }
   
}

