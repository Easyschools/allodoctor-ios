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
    let types: [ScanTypeWrapper]?
    
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
// Main wrapper struct for the type object
struct ScanTypeWrapper: Codable, Hashable {
    let test: ScanType?
    let discountPercentage: String?
    let priceAfterDiscount: String?
    let price: String?
    
    enum CodingKeys: String, CodingKey {
        case test
        case discountPercentage = "discount_percentage"
        case priceAfterDiscount = "price_after_discount"
        case price
    }
}

struct ScanType: Codable, Hashable {
    let id: Int
    let nameEn: String
    let nameAr: String
    let descriptionEn: String
    let descriptionAr: String
    let instructionEn: String
    let instructionAr: String
    let price: String?
    let deletedAt: String?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case instructionEn = "instruction_en"
        case instructionAr = "instruction_ar"
        case price
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
// MARK: - LabInfo
import Foundation

struct LabResponse: Decodable {
    let data: [LabInfo]?
}

struct LabInfo: Decodable {
    let id: Int?
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
    let latitude: String?
    let longitude: String?
    let experience: String?
    let rate: Double?
    let serviceID: Int?
    let districtID: Int?

    let mainImage: String?

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
//        case service, city, district
        case mainImage = "main_image"

    }
}


// Main response structure
struct LabsAndScanResponse: Decodable {
    let data: LabData?
}

struct LabData: Decodable {
    let id: Int?
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
   
    let experience: String?
    let rate: Double?
    let serviceId: Int?
    let districtId: Int?
    let service: Service?
    let city: City?
    let district: District?
    let mainImage: String?
    
    let types: [LabTestType]
//    let medicalInsurance: [String]?
//    let branches: [labBranch]?
  
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case name
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case title
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case description
        case to
        case from
        case address
    
        case experience
        case rate
        case serviceId = "service_id"
        case districtId = "district_id"
        case service
        case city
        case district
        case mainImage = "main_image"

       
        case types
//        case medicalInsurance = "medical_insurance"
//        case branches

    }
}

struct labService: Decodable {
    let id: Int?
    let name: String?
}



struct labDistrict: Decodable {
    let id: Int?
    let name: String?
}



//struct Review: Decodable {
//    let id: Int?
//    let userId: Int?
//    let labId: Int?
//    let review: String?
//    let rating: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userId = "user_id"
//        case labId = "lab_id"
//        case review
//        case rating
//    }
//}

//struct BranchAppointment: Decodable {
//    let appointmentLabId: Int?
//    let day: Day?
//    let hour: [Hour]?
//
//    enum CodingKeys: String, CodingKey {
//        case appointmentLabId = "appointment_lab_id"
//        case day
//        case hour
//    }
//}



struct LabTestType: Decodable,Hashable {
    let test: LabTest
    let price: String?
    let discountPercentage: String?
    let priceAfterDiscount: String?
    
    enum CodingKeys: String, CodingKey {
        case test
        case price
        case discountPercentage = "discount_percentage"
        case priceAfterDiscount = "price_after_discount"
    }
}

struct LabTest: Decodable,Hashable {
    let id: Int?
    let nameEn: String?
    let nameAr: String?
   
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
   
    }
}

struct labBranch: Decodable {
    let id: Int?
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
    let latitude: Double?
    let longitude: Double?
    let experience: String?
    let rate: Double?
    let serviceId: Int?
    let districtId: Int?
    let city: City?
    let district: District?
    let mainImage: String?
   

    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case name
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case title
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case description
        case to
        case from
        case address
        case latitude
        case longitude
        case experience
        case rate
        case serviceId = "service_id"
        case districtId = "district_id"
        case city
        case district
        case mainImage = "main_image"
       
    }
}
