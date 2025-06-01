//
//  PharmacyNavigationModule.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 09/01/2025.
//


// MARK: - Pharmacy Navigations
import UIKit
extension HomeCoordinator{
    func showCreateAddress(lat:String,long:String) {
        let viewModel = UserAddressViewModel(coordinator:self,lat: lat, long: long)
        let viewController = UserAddressViewController(viewModel: viewModel)
        if let presentedNavController = (window?.rootViewController as? UITabBarController)?.selectedViewController?.presentedViewController as? UINavigationController {
            presentedNavController.pushViewController(viewController, animated: true)
        }
        else if let selectedViewController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            selectedViewController.pushViewController(viewController, animated: true)
        }
    }
    func showOrdersScreens(pharmacyId:Int) {
        let viewModel = PharmacyOrderViewModel(coordinator:self, pharmacyId: pharmacyId)
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
            if let presentedNavController = (window?.rootViewController as? UITabBarController)?.selectedViewController?.presentedViewController as? UINavigationController {
                presentedNavController.pushViewController(viewController, animated: true)
            }
        case .uploadPresription:
            if let selectedViewController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
                selectedViewController.present(viewController, animated: true)
            }
        }
    }
    func showUploadPharmacyPrescription(){
        let viewModel = UploadPrescriptionViewModel(coordinator: self, pharmacyId: 30)
        let viewController = UploadPrescriptionViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
    }
    func showPharmacyProducts(pharmacyId: Int, categoryId: Int?) {
        let viewModel = PharmacyProductViewModel(coordinator:self,pharmacyId: pharmacyId, categoryId: categoryId)
        let viewController = PharmacyProductViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    func showProductDetailsViewController(pharmacyId:Int,categoryId:Int,product:Product,viewControllerDelgate:UIViewController) {
        let viewModel = ProductDetailsViewModel(coordinator:self,pharmacyId:pharmacyId, categoryId: categoryId, product: product, uiviewcontrollerDelegate: viewControllerDelgate)
        let viewController = ProductDetailsViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.present(viewController, animated: true)
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

    func showPaymentWebKit(url: String,Delegete:PaymentTaskHandling,orderId:Int) {
        let viewModel = PaymentWebKitViewViewModel(coordinator:self,urlString: url,taskHandler: Delegete, orderId: orderId)
        let viewController = PaymentWebKitViewViewController(viewModel: viewModel)
        if let presentedNavController = (window?.rootViewController as? UITabBarController)?.selectedViewController?.presentedViewController as? UINavigationController {
            presentedNavController.pushViewController(viewController, animated: true)
        }
  
       
    }
    func showPharmacyHome(lat:String,long:String){
       let viewModel = PharmacyHomeViewModel(coordinator:self,lat: lat,long: long)
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
    func showPharmacyGlobalSearch(){
        let viewModel = PharmacyGlobalSearchViewModel(coordinator: self)
        let viewController = PharmacyGlobalSearchViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
    func dismissPresnetiontoProducts(_ viewController: UIViewController) {
         if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
             navController.dismiss(animated: true)
           }
     
      }
    func dissToPharmacyHome(lat: String, long: String) {
        // Initialize or update the view model with the latest coordinates
        let viewModel = PharmacyHomeViewModel(coordinator: self, lat: lat, long: long)
        _ = PharmacyHomeViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.dismiss(animated: true) {
                navController.dismiss(animated: true)
            }
        }
    }
    func showPharmaciesCartViewController() {
        let viewModel = PharmaciesCartViewModel(coordinator: self)
        let viewController = PharmaciesCartViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        }
    }
}
