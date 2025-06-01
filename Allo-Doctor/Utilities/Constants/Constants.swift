//
//  Constants.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 04/09/2024.
//

import Foundation
enum Constants:String {
  case imagePlaceHolder = "https://community.softr.io/uploads/db9110/original/2X/7/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a6.jpeg"
    case emergencyAcceptTerms = """
    Allo Doctor is not a medical facility but serves as an intermediary between licensed healthcare providers and patients through its website and mobile applications.
    Allo Doctor does not replace your existing relationship with a primary care physician.
    Physicians and providers associated with Allo Doctor do not prescribe:
    - Controlled substances
    - Scheduled drugs
    - Non-therapeutic drugs
    - Other drugs that may be harmful due to their potential for abuse

    Medical services provided by healthcare providers are subject to their professional judgment.
    """

}
enum State {
    case idle
    case loading
    case success
    case error
}

enum labAndScan:String{
case labs = "16"
case scans = "17"
}

enum Dimensions:CGFloat{
    case borderRaduis = 10
    case borderWidth = 1
    case textFieldPadding = 13
    case upperViewBorderRaduis = 25
}
enum buttonsText:String{
    case Next = "Next"
    case getOtp = "Get OTP"
    case createAccount = "Create Account"
}
enum ToolBarVCs:String{
    case services = "Services"
    case activity = "Activity"
    case  offers = "Offers"
    case profile = "Profile"
}
enum ClinicProfileViews:String{
    case aboutClinicView = "AboutClinicView"
    case clinicDoctorsView = "ClinicDoctorsView"
    case reviewsView = "ReviewsUIView"
    case clinicInsuranceView = "ClinicInsuranceView"
}
struct DateConstants {
    static let days: [String] = (1...31).map { String($0) }
    static let months: [String] = [
        AppLocalizedKeys.Jan.localized,
        AppLocalizedKeys.feb.localized,
        AppLocalizedKeys.mar.localized,
        AppLocalizedKeys.apr.localized,
        AppLocalizedKeys.may.localized,
        AppLocalizedKeys.jun.localized,
        AppLocalizedKeys.jul.localized,
        AppLocalizedKeys.aug.localized,
        AppLocalizedKeys.sep.localized,
        AppLocalizedKeys.oct.localized,
        AppLocalizedKeys.nov.localized,
        AppLocalizedKeys.dec.localized
    ]
    static let years: [String] = (1940...Calendar.current.component(.year, from: Date())).map { String($0) }.reversed()

}
// Enum to represent booking status
enum BookingStatus {
    case success
    case failure
}
enum AppLanguage: String {
    case ar = "ar" // Arabic
    case en = "en" // English
}
