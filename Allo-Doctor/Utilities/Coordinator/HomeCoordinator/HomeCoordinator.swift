//
//  HomeCoordinator.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/09/2024.
//

import UIKit

// MARK: - HomeCoordinatorContact Protocol
protocol HomeCoordinatorContact: AnyObject {
    func showSplashScreen()
    func showRegisterScreen()
    func showTabBar()
    func navigationBack()
    func showSubServicesVC()
    func showSearchScreen()
    func navigateBack()
    func showProfileMedical()
    func dismiss(completion: (() -> Void)?)
    func showOnboardingScreen()
    func showPhonenumberScreen()
    func showOtpScreen()
    var navigationController: UINavigationController { get }
    func showDoctorSearch(specialityId:String,externalClinicServiceId:String)
    func showClinicProfile(clinicID:String)
    func showClinicsSearch()
    func showProfileEdit()
    func showSelectLanguageScreen()
    func navToLabsAndScanSearchScreen(type:String)
    func showLabsAndScanProfile(url: String,type:String,id:Int)
    func presentModally(_ viewController: UIViewController)
    func dismissPresnet(_ viewController: UIViewController)
    func showHospitalSearch()
    func showDoctorProfile(doctorID:String)
    func presentModallyWithRoot(_ viewController: UIViewController)
    func  showDoctorConfirmationScreen (doctorData: DoctorProfile,appointmentDay: String,appoinmentHour: DoctorAppointmentHour,doctorServiceSpecialtyId: Int,date:String)
    func showDoctorAppointmentsScreen(docotor:DoctorProfile,date:String,day:String,doctorServiceSpecialtyId:Int)
    func showLabsAndScanBooking(tests:[LabTestType],hourId:Int,dayId:Int,date:String,labId:Int,bookingType:String)
    func showOperationsSearchScreen()
    func showPharmacyHome(lat:String,long:String)
    func showLabsAndScanBookingAppointments(labId:Int,tests:[LabTestType],type:String)
    func showPharmacyCategory(pharmacyId:Int)
    func showPharmacyProducts(pharmacyId:Int,categoryId:Int?)
    func showProductDetailsViewController(pharmacyId:Int,categoryId:Int,product:Product,viewControllerDelgate:UIViewController)
    func dismissPresnetiontabBarNav(_ viewController: UIViewController)
    func showMapView(screenType:ScreenUserLocationType)
    func showPharmacyCart(pharmacyId:Int)
    func dissToPharmacyHome (lat:String,long:String)
    func showOrdersScreens(pharmacyId:Int)
    func showCreateAddress(lat:String,long:String)
    func navigateToRoot()
    func navigateToRootFromPresentation()
    func showExternalClinics()
    func showExternalClinicHospitals(externalClinicId:Int)
    func showOpertionHospitals(operationID:Int)
    func showOperationAppointments(operationServiceId:Int,hospitalData:OperationInfoServiceWrapper)
    func showHomeVisit()
    func showIntensiveCare(selectedUnit:String)
    func showIncubations()
    func showUploadPharmacyPrescription()
    func showPharmacyGlobalSearch()
    func showHomeNursing()
    func showEmergency()
    func showOperationBooking(operationServiceId:Int,date:String,hospitalData:OperationInfoServiceWrapper)
    func showAlluserInsurance()
    func showPharmaciesCartViewController()
    func showAddInsurnace()
    func showOffersBanners(screenType:String)
    func showIntensiveCareUnits()
    func showProfileSettings()
    func showPaymentWebKit(url: String,Delegete:PaymentTaskHandling,orderId:Int)
    func showOperationConfirmed(operationServiceId:Int,hospitalData:OperationInfoServiceWrapper,date:String)
    func showOperationProcedure(operationServiceId:Int)
    func showOneDayCareHospitals()
    func  showHospitalProfile(hospitalId:Int)
    func showOneDayCareAppointments(serviceId:Int)
    func showOneDayCareBooking(dayServiceId:Int,date:String,hospitalData:OneDayCareAppointmentsModel)
    func showProfileFavouritesViewController()
    func showChatViewController()
    func showAppointmentsActivity(bookingData:MyBookings)
    func showOrderDetails(orderDetails:Order)
    func showProfileSuppotViewController()
    func showInsuranceDetails(userInsurance:UserInsurance)
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
    
    func showInsuranceDetails(userInsurance: UserInsurance) {
        let viewModel =   InsuranceDeleteViewModel(coordinator:self, userInsurance: userInsurance)
        let viewController = InsuranceDeleteViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
    }
    
    func showProfileSuppotViewController() {
        let viewModel =   ProfileSuppotViewModel(coordinator:self)
        let viewController = ProfileSuppotViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
    }
    
    func showOrderDetails(orderDetails:Order) {
        let viewModel =   OrderDetailsViewModel(coordinator:self,order: orderDetails)
        let viewController = OrderDetailsViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
    }
    
    func showAppointmentsActivity(bookingData:MyBookings) {
        
        let viewModel =   AppointmentsActivityViewModel(coordinator:self, bookingData: bookingData)
        let viewController = AppointmentsActivityViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
    }
    
    func showChatViewController() {
        
        let viewModel =   ChatViewModel(coordinator:self)
        let viewController = ChatViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
    }
    
    
    func showProfileFavouritesViewController() {
        let viewModel =   ProfileFavouritesViewModel(coordinator:self)
        let viewController = ProfileFavouritesViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
        
    }
    
    func showOneDayCareBooking(dayServiceId:Int,date:String,hospitalData:OneDayCareAppointmentsModel)
    {
        let viewModel =   OneDayCareBookingViewModel(coordinator:self,dayServiceId: dayServiceId, date: date, hospitalData: hospitalData)
        let viewController = OneDayCareBookingViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
        
        
    }
    func showOneDayCareAppointments(serviceId:Int){
        let viewModel =   OneDayCareAppointmentsViewModel(coordinator:self, ServiceId:serviceId)
        let viewController = OneDayCareAppointmentsViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
      
    }
    func showHospitalProfile(hospitalId:Int) {
        let viewModel = OneDayCareProfileViewModel(coordinator:self, hospitalId: hospitalId)
        let viewController = OneDayCareProfileViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
    }
    
    func showOneDayCareHospitals() {
        let viewModel = OneDayCareHospitalsViewModel(coordinator:self)
        let viewController = OneDayCareHospitalsViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
    }
    
    func showOperationProcedure(operationServiceId:Int){
        let viewModel = OperationProcedureViewModel(coordinator:self,operationServiceId: operationServiceId)
        let viewController = OperationProcedureViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
        
    }
    func showOperationConfirmed(operationServiceId:Int,hospitalData:OperationInfoServiceWrapper,date:String){
        let viewModel = OperationConfirmedViewModel(coordinator:self,operationServiceId: operationServiceId, hospitalData:hospitalData, date:date)
        let viewController = OperationConfirmedViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
        
    }
    
    
    func showIntensiveCareUnits() {
        let viewModel = IntensiveCareUnitsViewModel(coordinator:self)
        let viewController = IntensiveCareUnitsViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
        
    }
    
    func showOffersBanners(screenType: String) {
        let viewModel = OffersBannersViewModel(coordinator:self,screenType: screenType)
        let viewController = OffersBannersViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
    }

   
    func showAlluserInsurance() {
        let viewModel = InsuranceSelectViewModel(coordinator: self)
        let viewController = InsuranceSelectViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
    }
    
    func showAddInsurnace() {
        let viewModel = UserInsuranceViewModel(coordinator: self)
        let viewController = UserInsuranceViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
    }
    func showProfileMedical(){
        let viewModel = ProfileMedicalViewModel(coordinator: self)
        let viewController = ProfileMedicalViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
    }
    func showProfileSettings(){
        let viewModel = ProfileSettingsViewModel(coordinator: self)
        let viewController = ProfileSettingsViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
    }
    func showOperationBooking(operationServiceId:Int,date:String,hospitalData:OperationInfoServiceWrapper) {
        let viewModel = OperationBookingViewModel(coordinator: self,operationServiceId: operationServiceId, date: date, hospitalData:hospitalData)
        let viewController = OperationBookingViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
    }
   
    
    func showIncubations(){
        let viewModel = IncubationsViewModel(coordinator: self)
        let viewController = IncubationsViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }}
    func showIntensiveCare(selectedUnit:String) {
        let viewModel = IntensiveCareViewModel(coordinator: self, selectedUnit: selectedUnit)
        let viewController = IntensiveCareViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    
   
    func showOperationAppointments(operationServiceId:Int,hospitalData:OperationInfoServiceWrapper){
        let viewModel = OperationAppointmentsViewModel(coordinator: self, operationServiceId: operationServiceId, hospitalData: hospitalData)
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
    
    

  
    func showProfileEdit(){
        let viewModel =  ProfileEditViewModel(coordinator: self)
        let viewController = ProfileEditViewController(viewModel: viewModel)
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
    
   
    
    func showClinicProfile(clinicID:String) {
        let viewModel = ClinicProfileViewModel(coordinator: self, clinicID: clinicID)
        let viewController = ClinicProfileViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }


    func showSubServicesVC() {
        let viewModel = SubServiceViewModel(coordinator: self)
        let viewController = SubServiceViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
                navController.pushViewController(viewController, animated: true)
            }

    }
    


    func dismiss(completion: (() -> Void)?) {
        navigationController.dismiss(animated: true, completion: completion)
    }

    func navigateBack() {   if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
        navController.popViewController(animated: true)}
    }
    func navigationBack() {
        if let presentedNavController = (window?.rootViewController as? UITabBarController)?.selectedViewController?.presentedViewController as? UINavigationController {
            presentedNavController.popViewController(animated: true)
     
        }
        
    }

    
    func navigateToRoot() {
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.popToRootViewController(animated: true)
            }
    
    }
    func navigateToRootFromPresentation() {
        if let presentedNavController = (window?.rootViewController as? UITabBarController)?.selectedViewController?.presentedViewController as? UINavigationController {
            presentedNavController.popToRootViewController(animated: true)
        }}
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

  

 

    func showClinicsSearch() {
        let viewModel = ClinicSearchScreenViewModel(coordinator: self)
        let viewController = ClinicSearchScreenViewController(viewModel: viewModel)
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
   
   

}

// MARK: - Services Navigations
extension HomeCoordinator{
    func showHomeVisit() {
        let viewModel = HomeVisitViewModel(coordinator: self)
        let viewController =  HomeVisitViewController(viewModel:viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    
    func showHomeNursing(){
        let viewModel = HomeNursingViewModel(coordinator: self)
        let viewController = HomeNursingViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    
    func showEmergency() {
        let viewModel = EmergencyViewModel(coordinator: self)
        let viewController = EmergencyViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
        
    }
    
}
