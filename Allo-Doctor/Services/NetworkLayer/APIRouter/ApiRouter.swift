
//
//  ApiRouter.swift
//  Allo-Doctor
//
//  Created by Abdallah Ismail on 10/09/2024.
//

import Foundation
enum APIRouter {
    case registerUser
    case fetchServices(isPaginate: Int)
    case fetchSpecialities(isPaginate: Int)
    case fetchSubServices(isPaginate: Int)
    case fetchInfoService(id: Int)
    case fetchDoctors(isPaginate: Int)
    case fetchPharmacies(isPaginate: Int, lat: String, long: String,search:String)
    case fetchPharmacy(id: Int)
    case fetchBasketPharmacies
    case fetchProducts(isPaginate: Int, categoryId: Int, pharmacyId: Int,search:String)
    case fetchAllProducts(isPaginate: Int, pharmacyId: Int,search:String)
    case addToCart(AddProductToCart)
    case fetchPharmacyCart(pharmacyId: Int,couponId:String)
    case fetchOrderStatus(orderId: Int)
    case fetchMyBookings
    case fetchOrders(userId: Int)
    case fetchLabsAndScanInfo(id: Int)
    case fetchUserAddresses
    case orderConfirm
    case fetchDoctorAppointment(doctorId: Int, specialtyId: Int, serviceId: Int, day: String, date: String)
    case fetchOperations(isPaginate:Int,search:String)
    case fetchExternalClinics(isPaginate:Int,search:String)
    case fetchOperationData(operationId:Int,search:String,districtId:String)
    case fetchExternalClinicData(externalClinicId:Int)
    case fetchAllOneDayCareHospitals(search:String)
    case fetchHospitalData(hospitalId:Int)
    case fetchOperationAppointments(operationServiceId:Int)
    case bookHomeVisit(BookingHomeBody)
    case bookHomeNursing(BookingHomeNursingBody)
    case bookIncubtions(IncubtionsAndIntensiveCareModel)
    case bookIntensiveCare(IncubtionsAndIntensiveCareModel)
    case fetchDoctorAppoinment(doctorServiceSpecialityId: Int)
    case fetchLabAppoinment(labId:Int,day:String,date:String,type:String)
    case fetchProductsGlobalSearch(isPaginate:Int ,search:String)
    case fetchCities
    case updateUser
    case bookEmergency(Emergencgy)
    case operationBooking(ConfirmOperationRequest)
    case bookDoctor(BookingRequest)
    case fetchOffers(offerType:String)
    case fetchBanners
    case medicalInfoPost
    case fetchOperationProcdure(operationServiceId:Int)
    case fetchOneDayCareServiceDays(ServiceId:Int)
    case oneDayServiceBooking
    case addToFavoutites
    case isFavourite (entity:String,id:Int)
    case getallFavsourites
    case fetchUserInsurance
    case postMessage
    case fetchMedicalData
    case delteFav (entity:String,id:Int)
    case deleteInsurance(id:Int)
    case deleteProductid(id:Int,pharmacyId:Int)
    case deletePharmacyCart(pharmacyId:Int)
    case cancelReservation(id:Int,type:String)
    case getUser(userId:Int)
    // Construct the full path and query for each case
    private var path: String {
        switch self {
        case .registerUser:
            return "/auth/register"
        case .updateUser:
            return "/admin/user/update"
        case .fetchServices(let isPaginate):
            return "/admin/service/all?is_paginate=\(isPaginate)"
        case .fetchSpecialities(let isPaginate):
            return "/admin/speciality/all?is_paginate=\(isPaginate)"
        case .fetchSubServices(let isPaginate):
            return "/admin/sub-service/all?is_paginate=\(isPaginate)"
        case .fetchInfoService(let id):
            return "/admin/service/get?id=\(id)"
        case .fetchDoctors(let isPaginate):
            return "/admin/doctor/all?is_paginate=\(isPaginate)"
        case .fetchPharmacies(let isPaginate, let lat, let long,let search):
            return "/admin/pharmacy/all?is_paginate=\(isPaginate)&lat=\(lat)&long=\(long)&search=\(search)"
        case .fetchPharmacy(let id):
            return "/admin/pharmacy/get?id=\(id)"
        case .fetchProducts(let isPaginate, let categoryId, let pharmacyId,let search):
            return "/admin/filter/all-medications?is_paginate=\(isPaginate)&category_id=\(categoryId)&pharmacy_id=\(pharmacyId)&search=\(search)"
        case .fetchProductsGlobalSearch(let isPaginate,let search):
            return "/admin/filter/all-medications?is_paginate=\(isPaginate)&search=\(search)"
        case .fetchBasketPharmacies:
            return "/admin/order/grand-total"
        case .fetchPharmacyCart(let pharmacyId,let couponId):
            return "/admin/order/grand-total?pharmacy_id=\(pharmacyId)&coupon_code=\(couponId)"
        case .fetchMyBookings:
            return "/admin/my-bookings/all"
        case .fetchLabsAndScanInfo(let id):
            return "/admin/lab/get?id=\(id)&web=1"
        case .fetchUserAddresses:
            return "/admin/address-user/all"
        case .orderConfirm:
            return "/admin/order/create"
        case .fetchDoctorAppointment(let doctorId, let specialtyId, let serviceId, let day, let date):
            return "/admin/appointment-doctor/get-available-appointment?doctor_id=\(doctorId)&service_id=\(serviceId)&speciality_id=\(specialtyId)&date=\(date)&day=\(day)"
        case .addToCart: return "/admin/cart/create"
        case .fetchOperations(isPaginate: let isPaginate,search: let search):
            return "/admin/operation/all?is_paginate=\(isPaginate)&search=\(search)"
        case .fetchExternalClinics(isPaginate: let isPaginate,search: let search):
            return "/admin/external-clinic/all?is_paginate=\(isPaginate)&search=\(search)"
        case .fetchOperationData(operationId: let id,search: let search,districtId: let districtId):
            return "/admin/operation/get?id=\(id)&search=\(search)&district_id=\(districtId)"
        case .fetchExternalClinicData(externalClinicId: let id):
            return "/admin/external-clinic/get?id=\(id)"
        case .fetchOperationAppointments(operationServiceId: let operationServiceId):
            return "/admin/operation-service-days/get?operation_service_id=\(operationServiceId)"
        case .bookHomeVisit:
            return "/admin/home-visit/create"
        case .bookIncubtions(_):
            return "/admin/incubator/create"
        case .bookIntensiveCare(_):
            return "/admin/intensive-care/create"
        case .fetchDoctorAppoinment(doctorServiceSpecialityId: let doctorServiceSpecialityId):
            return "/admin/appointment-doctor/get?doctor_service_specialty_id=\(doctorServiceSpecialityId)"
       
        case .fetchLabAppoinment(labId: let labId, day: let day, date: let date, type: let type):
            return "/admin/appointment-lab/get-available-appointment?lab_id=\(labId)&date=\(date)&day=\(day)&appointment_type=\(type)"
        case .bookHomeNursing(_):
            return "/admin/nurse-visit/create"
        case .fetchCities:
            return "/admin/city/all?is_paginate=50"
        case .bookEmergency(_):
            return "/admin/emergency/create"
        case .operationBooking(_):
            return "/admin/operation/booking-operation"
        case .bookDoctor(_):
            return "/admin/booking/create"
        case .fetchAllProducts(isPaginate: let isPaginate, pharmacyId: let pharmacyId, search: let search):
            return "/admin/filter/all-medications?is_paginate=\(isPaginate)&pharmacy_id=\(pharmacyId)&search=\(search)"
        case .fetchOffers(offerType: let offerType):
            return "/admin/offer/all?is_paginate=15&bannerable_type=\(offerType)"
        case .medicalInfoPost:
            return "/admin/medical-info/create"
        case .fetchOrders(userId:let userId):
            return "/admin/order/all?is_paginate&user_id=\(userId)"
        case .fetchOrderStatus(orderId: let orderId):
            return "/admin/order/get/?id=\(orderId)"
        case .fetchOperationProcdure(operationServiceId: let id):
            return "/admin/procedure/get?operation_service_id=\(id)"
        case .fetchAllOneDayCareHospitals(let search):
            return "/admin/day-service/all-info-services?is_paginate=10&search=\(search)"
        case .fetchHospitalData(let hospitalId):
            return "/admin/info-service/get?id=\(hospitalId)"
        case .fetchOneDayCareServiceDays(ServiceId: let ServiceId):
            return "/admin/info-day-service/get/?id=\(ServiceId)"
        case .oneDayServiceBooking:
            return "/admin/day-service/booking"
        case .addToFavoutites:
            return "/admin/favorite/create"
        case .isFavourite(entity: let entity, id: let id):
            return "/admin/favorite/all?favoritable_entity=\(entity)&favoritable_id=\(id)"
        case .getallFavsourites:
            return "/admin/favorite/all"
        case .fetchUserInsurance:
            return "/admin/user-insurance/all"
        case .postMessage:
            return "/admin/chat/send-message"
        case .fetchBanners:
            return "/admin/offer/all?banner=1"
        case .fetchMedicalData:
            return "/admin/medical-info/get"
        case .delteFav(entity: let entity, id: let id):
            return "/admin/favorite/delete?favoritable_id=\(id)&favoritable_entity=\(entity)"

        case .deleteInsurance(id: let id):
            return "/admin/user-insurance/delete?medical_insurance_id=\(id)"
        case .deleteProductid(id: let id,pharmacyId: let pharmacyId):
            return "/admin/cart/delete?id=\(id)&pharmacy_id=\(pharmacyId)"
        case .deletePharmacyCart(pharmacyId: let pharmacyId):
            return "/admin/cart/delete?pharmacy_id=\(pharmacyId)"
        case .cancelReservation(id: let id,type: let type):
            return "/admin/my-bookings/delete?id=\(id)&type=\(type)"
        case .getUser(userId: let userId):
            return "/admin/user/get?id=\(userId)"
        }
    }
    // Define the base URL for all requests
    private var baseURL: String {
        return APIConstants.basedURL
    }
    // Combine base URL with path to create full URL
    var url: URL {
        return URL(string: baseURL + path)!
    }
    
    // Define HTTP methods based on each case
    var method: String {
        switch self {
        case .registerUser, .addToCart, .orderConfirm,.bookHomeVisit,.bookHomeNursing,.bookEmergency,.operationBooking,.bookDoctor,.medicalInfoPost:
            return "POST"
        default:
            return "GET"
        }
    }
    
    // Define the HTTP body data for each request
    var body: Data? {
        switch self {
        case .addToCart(let productData):
            return try? JSONEncoder().encode(productData)
//        case .orderConfirm(let orderData):
//            return try? JSONEncoder().encode(orderData)
        case .bookHomeNursing(let nursingBody):
            return try? JSONEncoder().encode(nursingBody)
        default:
            return nil
        }
    }
    
    // Define request headers
    var headers: [String: String] {
        var defaultHeaders = ["Content-Type": "application/json"]
        if let authHeader = AuthManager.shared.getAuthorizationHeader() {
            defaultHeaders["Authorization"] = authHeader
        }
        return defaultHeaders
    }
    
    // Build the complete URLRequest object
    func makeRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
