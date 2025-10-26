

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
    case minutes = "min"
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
    case resend
    case selectGender
    case userUpdated
    case userUpdatedSuccessfully
    case pleaseAddInsuranceCardPhoto
    case addressNotAvailable
    case notAvailable
    case feesNotAvailable
    case availableOn
    case CustomerService
    case doctorCustomerService
    case messagePlaceholder
    case noAppointments
    case noOrdersYet
    case uploadingAllPhotos
    case uploadPhotos
    case maximumPhotosAdded
    case addPhotos
    case photoLibrary
    case camera
    case selectPhotos
    case maximumPhotosReached
    case uploadLimitWarning
    case pleaseUploadMedical
    case images
    case medicalImages
    case chatNow
    case oneTest
    case tests
    case added
    case done
    case Ambulance
    case pleaseSelectRating
    case reviewCreatedSuccessfully
    case submitReview
    case addCommentOptional
    case howWouldYouRateThis
    case rateAndReview
    case writeReview
    case orderPlacedSuccessfully
    case maximumQuantityReached
    case pleaseSelectAddress
    case pleaseSelectPayment
    case searchForAnyPharmacy
    case failed

    // MARK: - Hospital-First Flow
    case searchHospitals = "Search hospitals..."
    case filterHospitals = "Filter Hospitals"
    case sortBy = "Sort By"
    case filter = "Filter"
    case sort = "Sort"
    case applyFilters = "Apply Filters"
    case clearAll = "Clear All"
    case allServices = "All Services"
    case oneDayCare = "One Day Care"
    case externalClinic = "External Clinic"
    case intensiveCare = "Intensive Care"
    case incubation = "Incubation"
    case emergency = "Emergency"
    case general = "General"
    case nameAZ = "Name (A-Z)"
    case highestRating = "Highest Rating"
    case nearest = "Nearest"
    case mostReviewed = "Most Reviewed"
    case noRating = "No rating"
    case specialties = "Specialties"
    case hospitalProfile = "Hospital Profile"
    case availableSpecialties = "Available Specialties"
    case reviews = "Reviews"
    case acceptedInsurance = "Accepted Insurance"
    case call = "Call"
    case location = "Location"
    case specialtyDetails = "Specialty Details"
    case doctor = "Doctor"
    case experience = "Experience"
    case wait = "Wait:"
    case min = "minutes"
    case contactForPrice = "Contact for price"
    case anonymous = "Anonymous"
    case noHospitalsFound = "No hospitals found"
    case noSpecialtiesAvailable = "No specialties available"
    case noDoctorsAvailable = "No doctors available"
    case selectDistrict = "Select District"
    case selectSpecialty = "Select Specialty"
    case minimumRating = "Minimum Rating"
    case all = "All"


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
