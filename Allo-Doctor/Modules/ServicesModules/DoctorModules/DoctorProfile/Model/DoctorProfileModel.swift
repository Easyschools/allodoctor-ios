//
//  DoctorProfileModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 09/11/2024.
//

//import Foundation
//// MARK: - DoctorResponse
//struct DoctorProfileResponse: Decodable {
//    let data: DoctorProfile
//}
//
//struct DoctorsResponse: Decodable {
//    let data: [DoctorProfile]
//}
//// MARK: - Doctor
//struct DoctorProfile: Decodable {
//    let id: Int
//    let name: String
//    let titleEn: String?
//    let titleAr: String?
//    let title: String?
//    let descriptionEn: String?
//    let descriptionAr: String?
//    let description: String?
//    let address: String?
//    let lat: Double?
//    let long: Double?
//    let rate: Double?
//    let waitingTime: Int?
//    let price: String?
//    let priceAfterDiscount: String?
//    let experience: String?
//    let mainImage: String?
//    let district: String?
//    let districtId: Int?
//    let images: [ClinicImages]?
//    let serviceSpecialtyIds: Int?
//    let appointments: [DoctorAppointment]?
//    let appointmentsBooking: [DoctorAppointmentBooking]?
//    let avgRating : Double?
//    let reviewsCount: Int?
//    let doctorServiceSpecialtyIds:[DoctorServiceSpecialty]?
////    let infoService: [InfoService]?
////    let speciality: [Speciality]
////    let branches: [String]
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, title, description, address, lat, long, rate, price, experience, images
//        case titleEn = "title_en"
//        case titleAr = "title_ar"
//        case descriptionEn = "description_en"
//        case descriptionAr = "description_ar"
//        case waitingTime = "waitng_time"
//        case priceAfterDiscount = "price_after_discount"
//        case mainImage = "main_image"
//        case district, districtId = "district_id"
//        case serviceSpecialtyIds = "service_specialty_ids"
//        case appointments
//        case appointmentsBooking = "appointments_booking"
//        case avgRating = "avg_rating"
//        case reviewsCount = "reviews_count"
//        case doctorServiceSpecialtyIds = "doctor_service_specialty_ids"
//    
////        case infoService = "infoService"
//    }
//}
//
//// MARK: - Appointment
//struct DoctorAppointment: Decodable {
//    let appointmentDayHourId: Int
//    let day: Day
//    let hour: [Hour]
//
//    enum CodingKeys: String, CodingKey {
//        case appointmentDayHourId = "appointment_day_hour_id"
//        case day, hour
//    }
//}
//
//// MARK: - Day
//struct DoctorDay: Decodable {
//    let id: Int
//    let nameEn: String
//    let nameAr: String
//    let name: String
//    let available: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, available
//        case nameEn = "name_en"
//        case nameAr = "name_ar"
//    }
//}
//
//// MARK: - Hour
//struct DoctorHour: Decodable {
//    let appointmentDayHourId: Int
//    let id: Int
//    let from: String
//    let to: String
//
//    enum CodingKeys: String, CodingKey {
//        case appointmentDayHourId = "appointment_day_hour_id"
//        case id, from, to
//    }
//}
//
//// MARK: - AppointmentBooking
//struct DoctorAppointmentBooking: Decodable {
//    let day: Day
////    let hours: [BookingHour]
//}
//
//// MARK: - BookingHour
//struct DoctorBookingHour: Decodable {
//    let id: Int
//    let from: String
//    let to: String
//}
//
//struct ClinicImages: Decodable {
//    let id: Int?
//    let image: String?
//}
//
//// MARK: - InfoService
//struct InfoService: Decodable {
//    let id: Int?
//    let name: String?
//    let nameAr: String?
//    let nameEn: String?
//    let descriptionAr: String?
//    let descriptionEn: String?
//    let districtId: Int?
//    let serviceIdOriginal: Int?
//    let image: String?
//    let isActive: Int?
//    let address: String?
//    let lat: Double?
//    let long: Double?
//    let operationServiceId: Int?
////    let branchesCount: Int
////    let branches: [String]
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, image, address, lat, long
//        case nameAr = "name_ar"
//        case nameEn = "name_en"
//        case descriptionAr = "description_ar"
//        case descriptionEn = "description_en"
//        case districtId = "district_id"
//        case serviceIdOriginal = "service_id_original"
//        case isActive = "is_active"
//        case operationServiceId = "operation_service_id"
////        case branchesCount = "branches_count"
//    }
//}
//
//// MARK: - Speciality
//struct Speciality: Decodable {
//    let id: Int
//    let nameEn: String
//    let nameAr: String
//    let name: String
//    let descriptionEn: String
//    let descriptionAr: String
//    let description: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, description
//        case nameEn = "name_en"
//        case nameAr = "name_ar"
//        case descriptionEn = "description_en"
//        case descriptionAr = "description_ar"
//    }
//}
//
//// MARK: - DoctorAppointmentResponse
//
//struct DoctorAppointmentResponse: Decodable {
//    let data: [DoctorAppointments]
//}
//
//// MARK: - DoctorAppointment
//struct DoctorAppointments: Decodable {
//    let id: Int?
//    let appointmentHour: AppointmentHours?
//    let appointmentDay: AppointmentDays?
//    let doctorServiceSpecialty: DoctorServiceSpecialties?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case appointmentHour = "appointment_hour"
//        case appointmentDay = "appointment_day"
//        case doctorServiceSpecialty = "doctor_service_specialty"
//    }
//}
//
//// MARK: - AppointmentHour
//struct AppointmentHours: Decodable {
//    let id: Int?
//    let from: String?
//    let to: String?
//    let fromDisplay: String?
//    let toDisplay: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case from
//        case to
//        case fromDisplay = "from_display"
//        case toDisplay = "to_display"
//    }
//}
//
//// MARK: - AppointmentDay
//struct AppointmentDays: Decodable {
//    let id: Int?
//    let nameEn: String?
//    let nameAr: String?
//    let name: String?
//    let available: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case nameEn = "name_en"
//        case nameAr = "name_ar"
//        case name
//        case available
//    }
//}
//
//// MARK: - DoctorServiceSpecialty
//struct DoctorServiceSpecialties: Decodable {
//    let id: Int?
//    let doctorID: Int?
//    let doctorName: String?
//    let specialtyID: Int?
//    let specialtyName: String?
//    let serviceID: Int?
//    let serviceName: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case doctorID = "doctor_id"
//        case doctorName = "doctor_name"
//        case specialtyID = "specialty_id"
//        case specialtyName = "specialty_name"
//        case serviceID = "service_id"
//        case serviceName = "service_name"
//    }
//}
import Foundation

// MARK: - DoctorResponse
struct DoctorProfileResponse: Decodable {
    let data: DoctorProfile
}

struct DoctorsResponse: Decodable {
    let data: [DoctorProfile]
}
struct DoctorsFav: Decodable {
    let data :[FavData]
}

struct FavData:Decodable {
    let id: Int?
}
// MARK: - Doctor
struct DoctorProfile: Decodable {
    let id: Int?
    let nameAr:String?
    let nameEn:String?
    let titleEn: String?
    let titleAr: String?
    let titleTypeEn: String?
    let titleTypeAr: String?
    let title: String?
    let gender: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let description: String?
    let address: String?
    let rate: Double?
    let waitingTime: Int?
    let price: String?
    let priceAfterDiscount: String?
    let experience: String?
    let mainImage: String?
    let district: DoctorDistrict?
    let districtId: Int?
    let images: [ClinicImages]?
    let doctorServiceSpecialtyIds: [DoctorServiceSpecialties]?
    let appointments: [DoctorAppointment]?
    let appointmentsBooking: [DoctorAppointmentBooking]?
    let services: [DoctorServices]?
    let infoService: [InfoService]?
    let speciality: [Speciality]?
    let externalClinicService: [ExternalClinicService]?
    let avgRating: Double?
    let reviewsCount: Int?
    let medicalInsurance : [MedicalInsurance]?
    enum CodingKeys: String, CodingKey {
        case id, title, description, address, rate, price, experience, images, gender, district
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case titleTypeEn = "title_type_en"
        case titleTypeAr = "title_type_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case waitingTime = "waitng_time"
        case priceAfterDiscount = "price_after_discount"
        case mainImage = "main_image"
        case districtId = "district_id"
        case doctorServiceSpecialtyIds = "doctor_service_specialty_ids"
        case appointments
        case appointmentsBooking = "appointments_booking"
        case services
        case infoService = "infoService"
        case speciality
        case externalClinicService = "externalClinicService"
        case avgRating = "avg_rating"
        case reviewsCount = "reviews_count"
        case medicalInsurance = "medical_insurance"
    }
}

// MARK: - District
struct DoctorDistrict: Decodable {
    let id: Int?
    let name: String?
}

// MARK: - Service
struct DoctorServices: Decodable {
    let id: Int
    let nameAr: String?
    let nameEn: String?
    let name: String?
    let slug: String?
    let descriptionAr: String?
    let descriptionEn: String?
    let description: String?
    let order: Int?
    let image: String?
    let parentId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, description, order, image
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case parentId = "parent_id"
    }
}

// MARK: - DoctorServiceSpecialty
struct DoctorServiceSpecialties: Decodable {
    let id: Int
    let infoService: DoctorInfoService?
    let externalClinicService: ExternalClinicService?
    let appointments: [DoctorAppointment]?
    enum CodingKeys: String, CodingKey {
        case id
        case infoService = "info_service"
        case appointments
        case externalClinicService = "external_clinic_service"
    }
}

struct DoctorInfoService: Decodable {
    let id: Int?
    let name: String?
    let nameAr: String?
    let nameEn: String?
    let descriptionAr: String?
    let descriptionEn: String?
    let address: String?
    enum CodingKeys: String, CodingKey {
        case id, name ,address
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
    }
}

// MARK: - ExternalClinicService
struct ExternalClinicService: Decodable {
    let id: Int
    let nameAr: String?
    let nameEn: String?
    let descriptionAr: String?
    let descriptionEn: String?
    let price: String?
    let address: String?
    let infoService: InfoService?
    let serviceId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, price, address
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case serviceId = "service_id"
        case infoService = "infoService"
        
    }
}

// MARK: - InfoService
//struct InfoService: Decodable {
//    let id: Int?
//    let name: String?
//    let nameAr: String?
//    let nameEn: String?
//    let descriptionAr: String?
//    let descriptionEn: String?
//    let avgRating: Double?
//    let reviewsCount: Int?
//    let districtId: Int?
//    let serviceIdOriginal: Int?
//    let district: District?
//    let image: String?
//    let backgroundImage: String?
//    let infoServiceNo: String?
//    let isActive: Int?
//    let address: String?
//    let lat: Double?
//    let long: Double?
//    let branchesCount: Int?
//    let branches: [String]?
//    let operationServiceId: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, image, address, lat, long, district
//        case nameAr = "name_ar"
//        case nameEn = "name_en"
//        case descriptionAr = "description_ar"
//        case descriptionEn = "description_en"
//        case avgRating = "avg_rating"
//        case reviewsCount = "reviews_count"
//        case districtId = "district_id"
//        case serviceIdOriginal = "service_id_original"
//        case backgroundImage = "background_image"
//        case infoServiceNo = "info_service_no"
//        case isActive = "is_active"
//        case branchesCount = "branches_count"
//        case branches
//        case operationServiceId = "operation_service_id"
//    }
//}
struct InfoService: Decodable {
    let id: Int?
    let name: String?
    let nameAr: String?
    let nameEn: String?
    let descriptionAr: String?
    let descriptionEn: String?
    let districtId: District? 
    let serviceIdOriginal: Int?
    let image: String?
    let isActive: Int?
    let address: String?
    let lat: String?
    let long: String?
    let operationServiceId: Int?
    let avgRating: Double?
    let reviewsCount: Int?

//    let branchesCount: Int
//    let branches: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, image, address, lat, long
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case districtId = "district_id"
        case serviceIdOriginal = "service_id_original"
        case isActive = "is_active"
        case operationServiceId = "operation_service_id"
        case avgRating = "avg_rating"
        case reviewsCount = "reviews_count"
//        case branchesCount = "branches_count"
    }
}

// Rest of the existing structs remain the same
struct ClinicImages: Decodable {
    let id: Int?
    let image: String?
}

// MARK: - Appointment
struct DoctorAppointment: Decodable {
    let appointmentDayHourId: Int
    let day: DoctorDay
    let hour: [DoctorHour]
    enum CodingKeys: String, CodingKey {
        case appointmentDayHourId = "appointment_day_hour_id"
        case day, hour
    }
}

// MARK: - Day
struct DoctorDay: Decodable {
    let id: Int
    let nameEn: String
    let nameAr: String
    let name: String
    let available: Int
    let date: String?

    enum CodingKeys: String, CodingKey {
        case id, name, available , date
        case nameEn = "name_en"
        case nameAr = "name_ar"
    }
}

// MARK: - Hour
struct DoctorHour: Decodable {
    let appointmentDayHourId: Int?
    let id: Int?
    let from: String?
    let to: String?

    enum CodingKeys: String, CodingKey {
        case appointmentDayHourId = "appointment_day_hour_id"
        case id, from, to
    }
}

// MARK: - AppointmentBooking
struct DoctorAppointmentBooking: Decodable {
    let day: Day
}

// MARK: - Speciality
struct Speciality: Decodable {
    let id: Int?
    let nameEn: String?
    let nameAr: String?
    let name: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
    }
}
