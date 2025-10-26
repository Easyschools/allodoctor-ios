////
////  HospitalFilter.swift
////  Allo-Doctor
////
////  Created for Hospital-First Flow Implementation
////
//
//import Foundation
//
//// MARK: - Hospital Filter Options
//struct HospitalFilterOptions {
//    var searchQuery: String?
//    var districtIds: [Int]?
//    var specialtyIds: [Int]?
//    var serviceType: HospitalServiceType?
//    var sortBy: HospitalSortOption
//    var minRating: Double?
//    var maxDistance: Double?
//
//    init(
//        searchQuery: String? = nil,
//        districtIds: [Int]? = nil,
//        specialtyIds: [Int]? = nil,
//        serviceType: HospitalServiceType? = nil,
//        sortBy: HospitalSortOption = .name,
//        minRating: Double? = nil,
//        maxDistance: Double? = nil
//    ) {
//        self.searchQuery = searchQuery
//        self.districtIds = districtIds
//        self.specialtyIds = specialtyIds
//        self.serviceType = serviceType
//        self.sortBy = sortBy
//        self.minRating = minRating
//        self.maxDistance = maxDistance
//    }
//
//    // Convert to query parameters for API
//    func toQueryParameters() -> [String: String] {
//        var params: [String: String] = [:]
//
//        if let query = searchQuery, !query.isEmpty {
//            params["search"] = query
//        }
//
//        if let districts = districtIds, !districts.isEmpty {
//            params["district_ids"] = districts.map { String($0) }.joined(separator: ",")
//        }
//
//        if let specialties = specialtyIds, !specialties.isEmpty {
//            params["specialty_ids"] = specialties.map { String($0) }.joined(separator: ",")
//        }
//
//        if let service = serviceType {
//            params["service_type"] = service.rawValue
//        }
//
//        params["sort_by"] = sortBy.rawValue
//
//        if let rating = minRating {
//            params["min_rating"] = String(rating)
//        }
//
//        if let distance = maxDistance {
//            params["max_distance"] = String(distance)
//        }
//
//        return params
//    }
//}
//
//// MARK: - Hospital Service Type Enum
//enum HospitalServiceType: String, Codable, CaseIterable {
//    case all = "all"
//    case oneDayCare = "one_day_care"
//    case operations = "operations"
//    case externalClinic = "external_clinic"
//    case intensiveCare = "intensive_care"
//    case incubation = "incubation"
//    case emergency = "emergency"
//    case general = "general"
//
//    var displayName: String {
//        switch self {
//        case .all:
//            return NSLocalizedString("All Services", comment: "")
//        case .oneDayCare:
//            return NSLocalizedString("One Day Care", comment: "")
//        case .operations:
//            return NSLocalizedString("Operations", comment: "")
//        case .externalClinic:
//            return NSLocalizedString("External Clinic", comment: "")
//        case .intensiveCare:
//            return NSLocalizedString("Intensive Care", comment: "")
//        case .incubation:
//            return NSLocalizedString("Incubation", comment: "")
//        case .emergency:
//            return NSLocalizedString("Emergency", comment: "")
//        case .general:
//            return NSLocalizedString("General", comment: "")
//        }
//    }
//
//    // Map from sub-service IDs
//    static func from(subServiceId: Int) -> HospitalServiceType {
//        switch subServiceId {
//        case 1:
//            return .oneDayCare
//        case 4, 22:
//            return .externalClinic
//        case 5:
//            return .intensiveCare
//        case 6:
//            return .operations
//        case 33:
//            return .incubation
//        case 36:
//            return .emergency
//        default:
//            return .general
//        }
//    }
//}
//
//// MARK: - Hospital Sort Option
//enum HospitalSortOption: String, Codable, CaseIterable {
//    case name = "name"
//    case rating = "rating"
//    case distance = "distance"
//    case reviewsCount = "reviews_count"
//
//    var displayName: String {
//        switch self {
//        case .name:
//            return NSLocalizedString("Name (A-Z)", comment: "")
//        case .rating:
//            return NSLocalizedString("Highest Rating", comment: "")
//        case .distance:
//            return NSLocalizedString("Nearest", comment: "")
//        case .reviewsCount:
//            return NSLocalizedString("Most Reviewed", comment: "")
//        }
//    }
//}
//
//// MARK: - Filter Selection Models (for UI)
//
//struct DistrictFilterOption: Identifiable {
//    let id: Int
//    let name: String
//    let nameEn: String?
//    let nameAr: String?
//    var isSelected: Bool = false
//
//    var displayName: String {
//        if LocalizationManager.shared.getCurrentLanguage() == "ar" {
//            return nameAr ?? name
//        } else {
//            return nameEn ?? name
//        }
//    }
//}
//
//struct SpecialtyFilterOption: Identifiable {
//    let id: Int
//    let name: String
//    let nameEn: String?
//    let nameAr: String?
//    var isSelected: Bool = false
//
//    var displayName: String {
//        if LocalizationManager.shared.getCurrentLanguage() == "ar" {
//            return nameAr ?? name
//        } else {
//            return nameEn ?? name
//        }
//    }
//}
//
//// MARK: - Filter Response Models (from API)
//
//struct DistrictListResponse: Decodable {
//    let data: [DistrictFilterData]
//
//    enum CodingKeys: String, CodingKey {
//        case data
//    }
//}
//
//struct DistrictFilterData: Decodable {
//    let id: Int
//    let name: String?
//    let nameEn: String?
//    let nameAr: String?
//    let cityId: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case nameEn = "name_en"
//        case nameAr = "name_ar"
//        case cityId = "city_id"
//    }
//
//    func toFilterOption() -> DistrictFilterOption {
//        return DistrictFilterOption(
//            id: id,
//            name: name ?? "",
//            nameEn: nameEn,
//            nameAr: nameAr
//        )
//    }
//}
//
//struct SpecialtyListResponse: Decodable {
//    let data: [SpecialtyFilterData]
//
//    enum CodingKeys: String, CodingKey {
//        case data
//    }
//}
//
//struct SpecialtyFilterData: Decodable {
//    let id: Int
//    let name: String?
//    let nameEn: String?
//    let nameAr: String?
//    let descriptionEn: String?
//    let descriptionAr: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case nameEn = "name_en"
//        case nameAr = "name_ar"
//        case descriptionEn = "description_en"
//        case descriptionAr = "description_ar"
//    }
//
//    func toFilterOption() -> SpecialtyFilterOption {
//        return SpecialtyFilterOption(
//            id: id,
//            name: name ?? "",
//            nameEn: nameEn,
//            nameAr: nameAr
//        )
//    }
//}
