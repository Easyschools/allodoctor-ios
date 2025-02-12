//
//  OrderDetailsViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/01/2025.
//

import Foundation
class OrderDetailsViewModel{
    private var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    @Published var pharmacy: Pharmacy?
    @Published var order: Order?
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(),order:Order) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.order = order
    }
}
extension OrderDetailsViewModel{
    func navBack(){
        coordinator?.navigateBack()
    }
}
