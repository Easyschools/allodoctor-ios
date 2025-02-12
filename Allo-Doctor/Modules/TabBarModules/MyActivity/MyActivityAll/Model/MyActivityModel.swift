//
//  MyActivityModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/11/2024.
//
struct MonthSection {
    let month: String
    let bookings: [MyBookings]
}
struct OrdersSection {
    let month: String
    let orders: [Order]
}

struct MyBookings: Decodable {
    let id: Int
    let createdAt: String?
    let name: String?
    let typeOfBooking: String?
    let address:String?
    let doctor: Doctor?
    let lab: Lab?
    let operation_service: OperationService?
    let date:String?
    let status:String?
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case name
        case address
        case typeOfBooking = "type_of_booking"
        case doctor = "appointment_day_hour"
        case lab = "appointment_lab"
        case date , status ,operation_service
    }
    
    struct Doctor: Decodable {
        let id: Int?
        let doctorServiceSpecialty: DoctorServiceSpecialty?
        
        enum CodingKeys: String, CodingKey {
            case id
            case doctorServiceSpecialty = "doctor_service_specialty"
        }
        
        struct DoctorServiceSpecialty: Decodable {
            let id: Int?
            let doctor: DoctorDetails?
            
            struct DoctorDetails: Decodable {
                let id: Int?
                let nameAR: String?
                let nameEn: String?
                let titleEn: String?
                let titleAr: String?
                let price : String?
                let address:String?
                enum CodingKeys: String, CodingKey {
                    case id
                    case titleEn = "title_en"
                    case nameAR = "name_ar"
                    case nameEn = "name_en"
                    case titleAr = "title_ar"
                    case price
                    case address
                }
            }
        }
    }
    
    struct Lab: Decodable {
        let id: Int?
        let labDetails: LabDetails?
        
        enum CodingKeys: String, CodingKey {
            case id
            case labDetails = "lab"
        }
        
        struct LabDetails: Decodable {
            let id: Int?
            let nameEn: String?
            let nameAr: String?
            let address: String?
            let mainImage: String?
            
            enum CodingKeys: String, CodingKey {
                case id
                case nameEn = "name_en"
                case nameAr = "name_ar"
                case address
                case mainImage = "main_image"
            }
        }
    }
    struct OperationService: Decodable {
        var id: Int?
        var infoServiceId: Int?
        let info_service :OperationInfoServiceBooking?
        var operationId: Int?
        var price: String?
        var createdAt: String?
        var updatedAt: String?
        var deletedAt: String?
        var operation: Operation?
        
        enum CodingKeys: String, CodingKey {
            case id
            case infoServiceId = "info_service_id"
            case operationId = "operation_id"
            case price
            case info_service
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case deletedAt = "deleted_at"
            case operation
        }
    }

    struct OperationInfoServiceBooking: Decodable {
        let id: Int
        let nameAr: String?
        let nameEn: String?
        let descriptionAr: String?
        let descriptionEn: String?

        let address: String?
        let image: String?

        let districtId: Int?
        let deletedAt: String?
        let createdAt: String?
        let updatedAt: String?
        let userId: Int?
        let backgroundImage: String?
        let infoServiceNo: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case nameAr = "name_ar"
            case nameEn = "name_en"
            case descriptionAr = "description_ar"
            case descriptionEn = "description_en"
            case address
            case image
        

            case districtId = "district_id"
            case deletedAt = "deleted_at"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case userId = "user_id"
            case backgroundImage = "background_image"
            case infoServiceNo = "info_service_no"
        }
    }

}



struct OrderResponses: Decodable {
    let data: [Order]?
}

// Order
struct Order: Decodable {
    let id: Int?
    let code: String?
    let userId: Int?
    let orderStatusId: Int?
    let orderStatus: OrderStatus?
    let paymentTypeId: Int?
    let paymentType: String?
    let transactionId: String?
    let total: String?
    let totalBeforeDiscount: String?
    let notes: String?
    let createdAt: String?
    let pharmacy: OrderPharmacy?
//    let address: OrderAddress?
    let cartItems: [OrderCartItem]?
    let prescription: String?

    enum CodingKeys: String, CodingKey {
        case id, code
        case userId = "user_id"
        case orderStatusId = "order_status_id"
        case orderStatus = "order_status"
        case paymentTypeId = "payment_type_id"
        case paymentType = "payment_type"
        case transactionId = "transaction_id"
        case total
        case totalBeforeDiscount = "total_before_discount"
        case notes
        case createdAt = "created_at"
        case pharmacy
//        case address
        case cartItems = "cartItems"
        case prescription
    }
}

// Order Status
struct OrderStatus: Decodable {
    let id: Int?
    let name: String?
    let nameAr: String?
    let nameEn: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case nameEn = "name_en"
    }
}

// Pharmacy
struct OrderPharmacy: Decodable {
    let id: Int?
    let nameEn: String?
    let nameAr: String?
    let name: String?
    let titleEn: String?
    let titleAr: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let distance: String?
    let address: String?
    let cityId: Int?
    let districtId: Int?
    let latitude: String?
    let longitude: String?
    let to: String?
    let from: String?
    let pickup: Int?
    let delivery: Int?
    let phone: String?
    let url: String?
    let experience: String?
    let mainImage: String?
    let backgroundImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case name
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case distance
        case address
        case cityId = "city_id"
        case districtId = "district_id"
        case latitude, longitude, to, from, pickup, delivery, phone, url, experience
        case mainImage = "main_image"
        case backgroundImage = "background_image"
    }
}

// Address
struct OrderAddress: Decodable {
    let id: Int?
    let lat: String?
    let long: String?
    let address: String?
    let floor: String?
    let appartmentNumber: String?

    enum CodingKeys: String, CodingKey {
        case id, lat, long, address, floor
        case appartmentNumber = "appartment_number"
    }
}

// Cart Item
struct OrderCartItem: Decodable {
    let id: Int?
    let orderId: Int?
    let pharmacyId: Int?
    let medication: OrderMedication?
    let medicationPharmacy: OrderMedicationPharmacy?
    let quantity: Int?
    let price: Double?
    let total: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderId = "order_id"
        case pharmacyId = "pharmacy_id"
        case medication
        case medicationPharmacy = "medication_pharmacy"
        case quantity, price, total
        case createdAt = "created_at"
    }
}

// Medication
struct OrderMedication: Decodable {
    let id: Int?
    let nameEn: String?
    let nameAr: String?
    let name: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let typeId: Int?
    let mainImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case name
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case typeId = "type_id"
        case mainImage = "main_image"
    }
}

// Medication Pharmacy
struct OrderMedicationPharmacy: Decodable {
    let id: Int?
    let medicationId: Int?
    let pharmacyId: Int?
    let categoryId: Int?
    let quantity: Int?
    let availability: Int?
    let price: String?
    let discountPercentage: String?
    let priceAfterDiscount: String?
    let deletedAt: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case medicationId = "medication_id"
        case pharmacyId = "pharmacy_id"
        case categoryId = "category_id"
        case quantity, availability, price
        case discountPercentage = "discount_percentage"
        case priceAfterDiscount = "price_after_discount"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
