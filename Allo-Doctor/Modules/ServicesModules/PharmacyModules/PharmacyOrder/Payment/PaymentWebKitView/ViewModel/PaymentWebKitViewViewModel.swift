//
//  PaymentWebKitViewViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/12/2024.
//

import Foundation

protocol WebViewModelProtocol {
    var urlString: String { get }
    var isValidURL: Bool { get }
    var errorMessage: String? { get }
    
    func validateURL() -> Bool
}

class PaymentWebKitViewViewModel: WebViewModelProtocol {
    // MARK: - Properties
    private(set) var urlString: String
    @Published private(set) var isValidURL: Bool = false
    var taskHandler: PaymentTaskHandling?
    @Published private(set) var errorMessage: String?
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var pharmacyId: Int?
    @Published var totalPrice: Double = 0.0
    private var apiClient: APIClient
    @Published var pharmacyCart: PharmacyCartData?
    @Published var orderCheck:OrderStatusCheck?
    @Published var paymentType : String?
    @Published var orderID:Int?
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(),urlString:String,taskHandler: PaymentTaskHandling? = nil,orderId:Int) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.urlString = urlString
        self.taskHandler = taskHandler
        self.orderID = orderId
    }
    
    // MARK: - Public Methods
    func validateURL() -> Bool {
        guard !urlString.isEmpty else {
            errorMessage = "URL cannot be empty"
            isValidURL = false
            return false
        }
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL format"
            isValidURL = false
            return false
        }
        
        guard url.scheme != nil && url.host != nil else {
            errorMessage = "URL must include scheme and host"
            isValidURL = false
            return false
        }
        
        errorMessage = nil
        isValidURL = true
        return true
    }
    func completePayment() {
        taskHandler?.handlePaymentCompletion(orderId:orderID ?? 0)
        }
}
extension PaymentWebKitViewViewModel{
    func navBack(){
        coordinator?.navigationBack()
    }
}
