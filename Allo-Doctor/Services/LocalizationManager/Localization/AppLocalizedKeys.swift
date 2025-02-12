

import UIKit
// MARK: - app Localized keys

enum AppLocalizedKeys: String, CaseIterable {
    case none
    
    // MARK: - Splash Module
    case verifyYourNumber
    case mobileNumber
    
    // MARK: - Onboardig Module
    case getOTP
    case onboardingSubtitle
    case next
    case skip
    
    // MARK: - TabBar Module
    case home
    case category
    case cart // Button
    case purchases
    case more
    case whatWeOffer
    // MARK: - Auth Module
    case invoiceNum
    case reponseDataNullKey
    case poNumber
    case driverName
    case phoneNum
    case arrivalDate
    // MARK: - IntesiveCare
    case adultsICU = "Adults ICU"
    case pediatricICU = "Pediatric ICU"
    case neonatalICU = "Neonatal ICU"
    
    case operations = "operations"
    case searchForAnyOperation 
    case Services
    case Activity
    case Offers
    case Profile 
    case bookVisit
    case logout
    case orders
    case appointments
    case Confirm
    case myMedicalInfo
    case InstensiveCare 
    case Month
    case Year
    case Day
    case Incubations
    case ExterntalClinic
    case searchResults
    case Hospitals
    case searchForHospitals
    case SearchforDoctor
    case selectArea = "Enter Your Area"
    case doctors
    case ok
    case uploadPrescription
    case uploadPrescriptionFirst
    case EGP
    case Cash
    case PayOnline
    case language
    case AgeVerify
    case NameValidation
    case EnterName
    case SelectCity
    case ValidAge
    case male
    case female 
    case SelectInsurance
    case Consultant
    case Specialist
    case searchForHospital
    case searchForSpecialityOrDoctor
    case Speciality
    case AllSpecialities
    case searchForPharmacyOrProduct
    case BookingConfirmed = "Booking Confirmed"
    case yourBookingHasBeenConfirmed = "your booking has been confirmed"
    case From
    case To
    case fees = "fees"
    case waitingTime
    case ChooseYourAppointment = "Choose your appointment"
    case quantity
    case searchForAnyProduct
    case total
    case orderList
    case checkOut = "Check Out"
    case mintutes = "min"
    case SearchForAnyOutPatientClinic
    case WorkingHours
    case InvalidName
    case InvalidNumber
    case nameEmpty
    case phoneEmpty
    case NameRejecs
    case phoneRejecs
    case ContactUs
    case Email
    case inAppMessaging
    case askAnyQuestionWithUs
    case bookLabs
    case featureLabCenter
    case searchForLabCenter
    case bookScan
    case featureScanCenter
    case searchForScanCenter 
    case selectSpeciality
    case searchForSpeciality
    case writeSymptoms
    case somethingHappen
    case error
    case InvalidAge
    case InvalidAddress
    case addressEmpty
    case ageRejecs
    case ageEmpty
    case Jan  =  "month_jan"
    case feb = "month_feb"
    case mar = "month_mar"
    case apr = "month_apr"
    case may = "month_may"
    case jun = "month_jun"
    case jul = "month_jul"
    case aug = "month_aug"
    case sep = "month_sep"
    case oct = "month_oct"
    case nov = "month_nov"
    case dec = "month_dec"
    case searchForTest
    case branch
    case homeVisit
    case Today
    case deletedSuccessfully
    case insurancedeletedSuccessfully
    case AboutHospital
    case OneDayCareServices
    case InvalidCoupon
    case CouponAppliedsuccessfully
    case zero
    case cancelled
    case pending
    case confirmed
    case insuranceAdded
    case insuranceAddedSuccessfully
    case homeVisitBookings = "HomeVisitBookings"
    case operationBookings = "OperationBookings"
    case intensiveCareBooking = "IntensiveCareBooking"
    case nurseVisit = "NurseVisit"
    case priceInfo = "You will be informed of the price later."
    case reservationCancelledSuccessfully
    case reservestionCancelled
    case orderCancelledSuccesfully
    case orderCancelled
    case medicalInfoUpdated
    case medicalInfoUpdatedSuccesfully
    case medicalGuidance
    case note
}

extension AppLocalizedKeys {
    var value: String {
        return self.rawValue.localized
    }
    
    static func byName(name: String?) -> AppLocalizedKeys {
        return AppLocalizedKeys.allCases.first(where: {$0.value == name}) ?? .none
    }
    var localized: String {
           return self.rawValue.localized
       }
}
