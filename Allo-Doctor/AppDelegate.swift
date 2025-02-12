//
//  AppDelegate.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 02/09/2024.
//
import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import FirebaseCore
import FirebaseMessaging
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.Message_ID"
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Firebase first
        FirebaseApp.configure()
        
        // Set up notifications before Google Services
        setupNotifications(application)
        
        // Initialize Google Services on main thread
        DispatchQueue.main.async {
            GMSServices.provideAPIKey("AIzaSyDJkVY_BdzPGHKPRV1zvVNoqiw2sbOszXg")
            GMSPlacesClient.provideAPIKey("AIzaSyAdWUwZDIdhQghUsBkYsQA3qxnSA8XUEcY")
        }
        
        return true
    }
    
    private func setupNotifications(_ application: UIApplication) {
        // Set delegates
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        // Request authorization
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            print("Notification permission granted: \(granted)")
            if let error = error {
                print("Notification authorization error: \(error)")
            }
        }
        
        // Register for remote notifications
        application.registerForRemoteNotifications()
    }
    
    // Handle device token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("Device Token: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
    }
    
    // Handle registration error
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
    
    // Scene lifecycle methods remain unchanged
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        guard let token = fcmToken else {
            print("FCM Token is nil")
            return
        }
        
        // Post notification for token updates
        let dataDict: [String: String] = ["token": token]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        
        // Send token to server
        if let phoneNumber = UserDefaultsManager.sharedInstance.getMobileNumber() {
            print("Updating FCM token with phone: \(phoneNumber)")
            FCMTokenManager.shared.handleTokenUpdate(token, phoneNumber: phoneNumber)
        } else {
            print("No phone number available in UserDefaults")
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print("Received notification in foreground: \(userInfo)")
        
        // Always show alert and play sound for foreground notifications
        return [.alert, .badge, .sound]
    }
    
    // Handle notification response when user taps notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print("User tapped notification: \(userInfo)")
        
        // Handle notification tap
        if let messageID = userInfo[gcmMessageIDKey] as? String {
            print("Message ID from notification tap: \(messageID)")
            // Add your notification tap handling logic here
        }
    }
    
    // Handle background notifications
    func application(_ application: UIApplication,
                    didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
    -> UIBackgroundFetchResult {
        print("Received background notification: \(userInfo)")
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID from background: \(messageID)")
        }
        
        return .newData
    }
}
