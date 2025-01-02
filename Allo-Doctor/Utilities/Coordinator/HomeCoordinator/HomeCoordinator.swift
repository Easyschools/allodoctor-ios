//
//  HomeCoordinator.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/09/2024.
//

import Foundation
import UIKit

// MARK: - HomeCoordinatorContact Protocol

protocol HomeCoordinatorContact: AnyObject {
    func showSplashScreen()
    func showRegisterScreen()
    func showTabBar()
    func showSubServicesVC()
    func showSearchScreen()
    func navigateBack()
    func dismiss(completion: (() -> Void)?)
    func showOnboardingScreen()
    func showPhonenumberScreen()
    func showOtpScreen()
    var navigationController: UINavigationController { get }
    func showDoctorSearch(specialityId:String) 
    func showClinicProfile(clinicID:String)
    func showClinicsSearch()
    func showSelectLanguageScreen()
    func navToLabsAndScanSearchScreen(type:String)
    func showLabsAndScanProfile(url: String,type:String,id:Int)
    func presentModally(_ viewController: UIViewController)
    func dismissPresnet(_ viewController: UIViewController)
    func showHospitalSearch()
    func showDoctorProfile(doctorID: String)
    func presentModallyWithRoot(_ viewController: UIViewController) 
    func  showDoctorConfirmationScreen (doctorData: DoctorProfile,appointmentDay: String,appoinmentHour: Hour)
    func showDoctorAppointmentsScreen(docotor:DoctorProfile)
    func showLabsAndScanBooking(tests:[Test])
    func showOperationsSearchScreen()
    func showPharmacyHome(lat:String,long:String)
    func showLabsAndScanBookingAppointments()
    func showPharmacyCategory(pharmacyId:Int)
    func showPharmacyProducts(pharmacyId:Int,categoryId:Int)
    func showProductDetailsViewController(pharmacyId:Int,categoryId:Int,product:Product)
    func dismissPresnetiontabBarNav(_ viewController: UIViewController)
    func showMapView(screenType:ScreenUserLocationType)
    func showPharmacyCart(pharmacyId:Int)
    func dissToPharmacyHome (lat:String,long:String)
    func showOrdersScreens()
    func showCreateAddress()
    func navigateToRoot()
    func showExternalClinics()
    func showExternalClinicHospitals(externalClinicId:Int)
    func showOpertionHospitals(operationID:Int)
    func showOperationAppointments(operationServiceId:Int)
    func showHomeVisit()
    func showIntensiveCare()
    func showIncubations()
}

// MARK: - HomeCoordinator

final class HomeCoordinator: Coordinator {
    var window: UIWindow?
    var navigationController: UINavigationController

    init(navigationController: UINavigationController, window: UIWindow?) {
        self.navigationController = navigationController
        self.window = window
    }

    func start() {
        showLaunchScreen()
    }

   
    // Show MainTabBarController as the root of the window
    func showTabBar() {
        let viewmodel = TabBarViewModel(coordinator: self)
        viewmodel.coordinator = self
        let tabBar = MainTabBarController(viewModel: viewmodel)


        window?.rootViewController = tabBar
        
        window?.makeKeyAndVisible()
    }
}

// MARK: - HomeCoordinatorContact Implementation

extension HomeCoordinator: HomeCoordinatorContact {
    func showIncubations(){
        let viewModel = IncubationsViewModel(coordinator: self)
        let viewController = IncubationsViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }}
    func showIntensiveCare() {
        let viewModel = IntensiveCareViewModel(coordinator: self)
        let viewController = IntensiveCareViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    
    func showHomeVisit() {
        let viewModel = HomeVisitViewModel(coordinator: self)
        let viewController =  HomeVisitViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    
    func showOperationAppointments(operationServiceId:Int){
        let viewModel = OperationAppointmentsViewModel(coordinator: self, operationServiceId: operationServiceId)
        let viewController =  OperationAppointmentsViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
        
    }
    func showExternalClinicHospitals(externalClinicId: Int) {
        let viewModel = ExternalClinicHospitalsViewModel(coordinator: self, externalClinicId: externalClinicId)
        let viewController =  ExternalClinicHospitalsViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    
    func showOpertionHospitals(operationID: Int) {
        let viewModel = OperationHospitalsViewModel(coordinator: self, operationId: operationID)
        let viewController =  OperationHospitalsViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    
    func showExternalClinics() {
        let viewModel = ExterntalClinicSearchViewModel(coordinator: self)
        let viewController =  ExterntalClinicSearchViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    

    func showSplashScreen() {
        if let sceneDelegate = SceneDelegate.shared() {
            sceneDelegate.resetToSplash()
        }
    }
    
    func showCreateAddress() {
        let viewModel = UserAddressViewModel()
        let viewController = UserAddressViewController(viewModel: viewModel)
        if let presentedNavController = (window?.rootViewController as? UITabBarController)?.selectedViewController?.presentedViewController as? UINavigationController {
            presentedNavController.pushViewController(viewController, animated: true)
        }
    }
    func showOrdersScreens() {
        let viewModel = PharmacyOrderViewModel(coordinator:self, pharmacyId: 1)
        let viewController = PharmacyOrderViewController(viewModel: viewModel)
        
        // Find the top-most navigation controller to push the new view controller
        if let presentedNavController = (window?.rootViewController as? UITabBarController)?.selectedViewController?.presentedViewController as? UINavigationController {
            presentedNavController.pushViewController(viewController, animated: true)
        }
    }

    func showMapView(screenType: ScreenUserLocationType) {
        let viewModel = UserLocationViewModel(coordinator: self, screenType: screenType)
        let viewController = UserLocationViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        switch screenType {
        case .pharmacyHome:
            if let selectedViewController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
                selectedViewController.present(viewController, animated: true)
            }
            
        case .userAddress:
            if let selectedViewController = (window?.rootViewController as? UITabBarController)?.selectedViewController?.presentedViewController as? UINavigationController {
                selectedViewController.present(viewController, animated: true)
            }
        }
    }

    func showPharmacyProducts(pharmacyId: Int, categoryId: Int) {
        let viewModel = PharmacyProductViewModel(coordinator:self,pharmacyId: pharmacyId, categoryId: categoryId)
        let viewController = PharmacyProductViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    func showProductDetailsViewController(pharmacyId:Int,categoryId:Int,product:Product) {
        let viewModel = ProductDetailsViewModel(coordinator:self,pharmacyId:pharmacyId, categoryId: categoryId, product: product)
        let viewController = ProductDetailsViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.present(viewController, animated: true)
          }
    }
    
    func showLabsAndScanBookingAppointments() {
        let viewModel = LabsAndScanAppointmentViewModel(coordinator: self)
        let viewController =  LabsAndScanAppointmentViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    func showOperationsSearchScreen(){
        let viewModel = OperationSearchViewModel(coordinator: self)
        let viewController =  OperationSearchViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    func showHospitalSearch() {
        let viewModel = HospitalSearchViewModel(coordinator: self)
        let viewController =  HospitalSearchViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
        
    }
    
    func showOtpScreen() {
        let viewModel = OTPViewModel()
        viewModel.coordinator = self
        let viewController = OTPViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showPhonenumberScreen() {
        let viewModel = PhoneNumberViewModel(coordinator: self)
        let viewController = PhoneNumberViewController(viewModel: viewModel)
   
            navigationController.pushViewController(viewController, animated: false)
 
    }
    
    func showClinicProfile(clinicID:String) {
        let viewModel = ClinicProfileViewModel(coordinator: self, clinicID: clinicID)
        let viewController = ClinicProfileViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    func showPharmacyCart(pharmacyId: Int) {
        let viewModel = PharmacyCartViewModel(coordinator: self, pharmacyId: pharmacyId)
        let pharmacyCartVC = PharmacyCartViewController(viewModel: viewModel)
        
        // Wrap in a navigation controller
        let navigationController = UINavigationController(rootViewController: pharmacyCartVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        // Present the navigation controller from the selected navigation stack
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.present(navigationController, animated: true)
        }
    }


    func showSubServicesVC() {
        let viewModel = SubServiceViewModel(coordinator: self)
        let viewController = SubServiceViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
                navController.pushViewController(viewController, animated: true)
            }

    }
    
    func showSelectLanguageScreen() {
        let viewModel = SelectlanguageViewModel()
        viewModel.coordinator = self
        let viewController = SelectlanguageViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: false)
          }
        else{
            navigationController.pushViewController(viewController, animated: false)}
    }

    func showRegisterScreen() {
        let viewModel = RegisterViewModel(coordinator: self)
        let viewController = RegisterViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func dismiss(completion: (() -> Void)?) {
        navigationController.dismiss(animated: true, completion: completion)
    }

    func navigateBack() {   if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
        navController.popViewController(animated: true)}
    }

    
    func navigateToRoot() {
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.popToRootViewController(animated: true)
            }
    
    }

    func showLaunchScreen() {
        let viewController = LaunchScreenViewController()
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: true)
    }

    func showSearchScreen() {
        let viewModel = SearchViewModel(coordinator: self)
        let viewController = SearchViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
                navController.pushViewController(viewController, animated: true)
            }
    }

    func showDoctorProfile(doctorID: String) {
        let viewModel = DoctorProfileViewModel(coordinator: self, doctorId: doctorID)
        let viewController = DoctorProfileViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }

    func showOnboardingScreen() {
        let viewModel = OnBoardingScreensViewModel()
        let viewController = OnBoardingScreensViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showDoctorSearch(specialityId:String) {
        let viewModel = DoctorSearchViewModel(coordinator: self, specialityId: specialityId)
        let viewController = DoctorSearchViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }

    func showClinicsSearch() {
        let viewModel = ClinicSearchScreenViewModel(coordinator: self)
        let viewController = ClinicSearchScreenViewController(viewModel: viewModel)
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
    func  showDoctorConfirmationScreen (doctorData: DoctorProfile,appointmentDay: String,appoinmentHour: Hour){
        let viewModel = BookingConfirmationViewModel(coordinator:self,doctorData: doctorData, appointmentDay: appointmentDay, appoinmentHour: appoinmentHour)
        let viewController = BookingConfirmationViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    func showDoctorAppointmentsScreen(docotor:DoctorProfile){
        let viewModel = AppointmentDoctorTimeViewModel(coordinator: self, doctor: docotor )
        let viewController = AppointmentDoctorTimeViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    func showLabsAndScanBooking(tests:[Test]){
        let viewModel = BookingLabsAndScanViewModel(coordinator: self, tests: tests)
       let viewController = BookingLabsAndScanViewController(viewModel: viewModel)
       if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
             navController.pushViewController(viewController, animated: true)
         }
       
    } 
    func showPharmacyHome(lat:String,long:String){
       let viewModel = PharmacyHomeViewModel(coordinator: self,lat: lat,long: long)
       let viewController = PharmacyHomeViewController(viewModel: viewModel)
        viewController.showMapView()
       if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
             navController.pushViewController(viewController, animated: true)
         }
    }
    func showPharmacyCategory(pharmacyId:Int){
        let viewModel = PharmacyCategoryViewModel(coordinator: self,pharmacyId: pharmacyId)
        let viewController = PharmacyCategoryViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
  func presentModally(_ viewController: UIViewController) {
        navigationController.present(viewController, animated: true, completion: nil)
   
       }
    
    func presentModallyWithRoot(_ viewController: UIViewController) {
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.present(viewController, animated: true)
          }
         }
    func dismissPresnet(_ viewController: UIViewController) {
            navigationController.dismiss(animated: true)
             
         }
   func dismissPresnetiontabBarNav(_ viewController: UIViewController) {
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.dismiss(animated: true)
          }
    
     }
    func dissToPharmacyHome(lat: String, long: String) {
        // Initialize or update the view model with the latest coordinates
        let viewModel = PharmacyHomeViewModel(coordinator: self, lat: lat, long: long)
        let viewController = PharmacyHomeViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.dismiss(animated: true) {
                navController.dismiss(animated: true)
            }
        }
    }
   

}
