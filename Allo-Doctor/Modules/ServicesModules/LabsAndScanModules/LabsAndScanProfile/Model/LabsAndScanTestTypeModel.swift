//
//  LabsAndScanTestTypeModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/10/2024.
//

import Foundation

struct TestData: Decodable {
    let data: [Test]?
}
    struct Test: Decodable,Hashable {
        let id: Int
        let nameEn: String
        let nameAr: String
        let descriptionEn: String
        let descriptionAr: String
        let instructionEn: String
        let instructionAr: String
        let price: String

        enum CodingKeys: String, CodingKey {
            case id
            case nameEn = "name_en"
            case nameAr = "name_ar"
            case descriptionEn = "description_en"
            case descriptionAr = "description_ar"
            case instructionEn = "instruction_en"
            case instructionAr = "instruction_ar"
            case price
        }
    }


struct LabAndScansResponse: Decodable {
    let data: LabAndScans
}
struct allScansResponse: Decodable {
    let data: [LabAndScans]
}
//struct allLabsResponse: Decodable {
//    let data: [LabInfo]
//}
struct LabAndScans: Decodable {
    let id: Int
    let nameEn: String?
    let nameAr: String?
    let name: String?
    let titleEn: String?
    let titleAr: String?
    let title: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let description: String?
    let to: String?
    let from: String?
    let address: String?
  
//    let service: Service
//    let city: City
//    let district: District
    let mainImage: String?
//    let images: [LabImage]
//    let reviews: [Review]
//    let appointments: [Appointment]
    let types: [ScanType]?
    
    enum CodingKeys: String, CodingKey {
        case id, nameEn = "name_en", nameAr = "name_ar", name
        case titleEn = "title_en", titleAr = "title_ar", title
        case descriptionEn = "description_en", descriptionAr = "description_ar", description
        case to, from, address
//        case service, city, district
        case mainImage = "main_image" , types
//        , images, reviews, appointments, types
    }
    
    struct Service: Decodable {
        let id: Int
        let name: String
    }
    
    struct City: Decodable {
        let id: Int
        let name: String
    }
    
    struct District: Decodable {
        let id: Int
        let name: String
    }
    
    struct LabImage: Decodable {
        let id: Int
        let image: String
    }
    
    struct Review: Decodable {
        let id: Int
        let userId: Int
        let labId: Int
        let review: String
        let rating: String
        
        enum CodingKeys: String, CodingKey {
            case id, userId = "user_id", labId = "lab_id", review, rating
        }
    }
    
    struct Appointment: Decodable {
        let id: Int
        let appointmentType: String
        let day: Day
        let hour: Hour
        
        enum CodingKeys: String, CodingKey {
            case id, appointmentType = "appointment_type", day, hour
        }
        
        struct Day: Decodable {
            let id: Int
            let nameEn: String
            let nameAr: String
            let name: String
            let available: Int
            
            enum CodingKeys: String, CodingKey {
                case id, nameEn = "name_en", nameAr = "name_ar", name, available
            }
        }
        
        struct Hour: Decodable {
            let id: Int
            let from: String
            let to: String
        }
    }
    
   
}
struct ScanType: Decodable , Hashable {
    let id: Int
    let nameEn: String
    let nameAr: String
    let descriptionEn: String
    let descriptionAr: String
    let instructionEn: String
    let instructionAr: String
    let price: String
    
    enum CodingKeys: String, CodingKey {
        case id, nameEn = "name_en", nameAr = "name_ar"
        case descriptionEn = "description_en", descriptionAr = "description_ar"
        case instructionEn = "instruction_en", instructionAr = "instruction_ar"
        case price
    }
}

// MARK: - LabInfo
import Foundation

struct LabResponse: Decodable {
    let data: [LabInfo]
}

import Foundation

struct LabInfo: Decodable {
    let id: Int
    let nameEn, nameAr, name: String
    let titleEn, titleAr, title: String
    let descriptionEn, descriptionAr, description: String?
    let to, from, address: String?
    let latitude, longitude: String?
    let experience: String?
    let rate: Double?
    let serviceID, districtID: Int?
    let service: Service
    let city, district: Location?
    let mainImage: String?
    let branchAppointments, homeAppointments: [Appointment]?
    let branchBookedAppointments, homeBookedAppointments: [BookedAppointment]?
    let types: [LabType]?
//    let branches: []

    enum CodingKeys: String, CodingKey {
        case id, name, title, description, to, from, address, latitude, longitude, experience, rate
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case serviceID = "service_id"
        case districtID = "district_id"
        case service, city, district
        case mainImage = "main_image"
        case branchAppointments = "branch_appointments"
        case homeAppointments = "home_appointments"
        case branchBookedAppointments = "branch_booked_appointments"
        case homeBookedAppointments = "home_booked_appointments"
        case types
    }


struct Service: Decodable {
    let id: Int
    let name: String
}

struct Location: Decodable {
    let id: Int
    let name: String
}

struct Appointment: Decodable {
    let appointmentLabID: Int
    let day: Day
    let hour: [Hour]

    enum CodingKeys: String, CodingKey {
        case appointmentLabID = "appointment_lab_id"
        case day, hour
    }
}

struct Day: Decodable {
    let id: Int
    let nameEn, nameAr, name: String
    let available: Int

    enum CodingKeys: String, CodingKey {
        case id, name, available
        case nameEn = "name_en"
        case nameAr = "name_ar"
    }
}

struct Hour: Decodable {
    let appointmentLabID, id: Int
    let from, to: String

    enum CodingKeys: String, CodingKey {
        case appointmentLabID = "appointment_lab_id"
        case id, from, to
    }
}

struct BookedAppointment: Decodable {
    let day: Day
    let hours: [BookedHour]
}

struct BookedHour: Decodable {
    let id: Int
    let from, to: String
}

struct LabType: Decodable {
    let id: Int
    let nameEn, nameAr: String
    let descriptionEn, descriptionAr: String
    let instructionEn, instructionAr: String
    let price: String

    enum CodingKeys: String, CodingKey {
        case id, price
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case instructionEn = "instruction_en"
        case instructionAr = "instruction_ar"
    }
}
}
