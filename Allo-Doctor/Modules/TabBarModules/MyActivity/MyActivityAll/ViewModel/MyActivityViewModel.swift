//
//  MyActivityViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/09/2024.
//

import Foundation
import Combine

class MyActivityViewModel {
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    @Published var myBookings: [MyBookings]?
    @Published var orders: [Order]?
    @Published var monthSections: [MonthSection] = []
    @Published var ordersSections: [OrdersSection] = []
    private var apiClient: APIClient
    
    // Add flags to prevent multiple simultaneous requests
    private var isLoadingBookings = false
    private var isLoadingOrders = false
    
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
    
    func fetchMyBookings() {
        guard !isLoadingBookings else { return }
        isLoadingBookings = true
        
        let router = APIRouter.fetchMyBookings
        apiClient.fetchData(from: router.url, as: [MyBookings].self)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoadingBookings = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch myBookings: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] bookings in
                self?.myBookings = bookings
                self?.groupBookingsByMonth(bookings: bookings)
              
            })
            .store(in: &cancellables)
    }
    
    func fetchOrders() {
        guard !isLoadingOrders else { return }
        isLoadingOrders = true
        
        let router = APIRouter.fetchOrders(userId: UserDefaultsManager.sharedInstance.getUserId() ?? 0)
        apiClient.fetchData(from: router.url, as: OrderResponses.self)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoadingOrders = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch orders: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] orders in
                self?.orders = orders.data
                self?.groupOrders(orders: orders.data ?? [])
            })
            .store(in: &cancellables)
    }
    
    private func groupBookingsByMonth(bookings: [MyBookings]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM yyyy"
        monthFormatter.locale = Locale(identifier: "en_US")
        
        var groupedBookings = [Date: (monthString: String, bookings: [MyBookings])]()
        
        for booking in bookings {
            guard let createdAt = booking.createdAt,
                  let date = dateFormatter.date(from: createdAt) else {
                print("Failed to parse date for booking: \(booking.id), date string: \(booking.createdAt ?? "nil")")
                continue
            }
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: date)
            guard let monthDate = calendar.date(from: components) else { continue }
            
            let monthKey = monthFormatter.string(from: date)
            
            if groupedBookings[monthDate] == nil {
                groupedBookings[monthDate] = (monthString: monthKey, bookings: [])
            }
            groupedBookings[monthDate]?.bookings.append(booking)
        }
        
        // Sort by actual date and convert to MonthSection
        self.monthSections = groupedBookings
            .sorted { $0.key > $1.key } // Sort by date descending (most recent first)
            .map { MonthSection(month: $0.value.monthString, bookings: $0.value.bookings) }
    }
    
    private func groupOrders(orders: [Order]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM yyyy"
        monthFormatter.locale = Locale(identifier: "en_US")
        
        var groupedOrders = [Date: (monthString: String, orders: [Order])]()
        
        for order in orders {
            guard let dateString = order.createdAt,
                  let date = dateFormatter.date(from: dateString) else {
                print("Failed to parse date for order: \(order.id ?? 0), date string: \(order.createdAt ?? "nil")")
                continue
            }
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: date)
            guard let monthDate = calendar.date(from: components) else { continue }
            
            let monthKey = monthFormatter.string(from: date)
            
            if groupedOrders[monthDate] == nil {
                groupedOrders[monthDate] = (monthString: monthKey, orders: [])
            }
            groupedOrders[monthDate]?.orders.append(order)
        }
        
        // Sort by actual date and convert to OrdersSection
        self.ordersSections = groupedOrders
            .sorted { $0.key > $1.key } // Sort months by date descending (most recent first)
            .map { monthData in
                // Sort orders within each month by date descending (most recent first)
                let sortedOrders = monthData.value.orders.sorted { order1, order2 in
                    guard let dateString1 = order1.createdAt,
                          let dateString2 = order2.createdAt,
                          let date1 = dateFormatter.date(from: dateString1),
                          let date2 = dateFormatter.date(from: dateString2) else {
                        return false
                    }
                    return date1 > date2 // Most recent first
                }
                
                return OrdersSection(month: monthData.value.monthString, orders: sortedOrders)
            }
    }
}

extension MyActivityViewModel {
    func ShowAppointmentsDetails(booking: MyBookings) {
        coordinator?.showAppointmentsActivity(bookingData: booking)
    }
    
    func showOrderDetails(order: Order) {
        coordinator?.showOrderDetails(orderDetails: order)
    }
}
