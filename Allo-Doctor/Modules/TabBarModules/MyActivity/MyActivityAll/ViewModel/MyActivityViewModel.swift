//
//  MyActivityViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/09/2024.
//

import Foundation


class MyActivityViewModel {
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    @Published var myBookings: [MyBookings]?
    @Published var orders: [Order]?
    @Published var monthSections: [MonthSection] = []
    @Published var ordersSections: [OrdersSection] = []
    private var apiClient: APIClient
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
    
    func fetchMyBookings() {
        let router = APIRouter.fetchMyBookings
        apiClient.fetchData(from: router.url, as: [MyBookings].self)
            .sink(receiveCompletion: { [weak self] completion in
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
        let router = APIRouter.fetchOrders(userId: UserDefaultsManager.sharedInstance.getUserId() ?? 0)
        apiClient.fetchData(from: router.url, as: OrderResponses.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch myBookings: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] orders in
                self?.orders = orders.data
                self?.groupOrders(orders: orders.data ?? [])
            })
            .store(in: &cancellables)
    }
    private func groupBookingsByMonth(bookings: [MyBookings]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ" // Format of created_at
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM yyyy"
        
        var groupedBookings = [Date: (monthString: String, bookings: [MyBookings])]()
        
        for booking in bookings {
            if let date = dateFormatter.date(from: booking.createdAt ?? "") {
                // Get the start of the month for consistent sorting
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month], from: date)
                let monthDate = calendar.date(from: components)!
                
                let monthKey = monthFormatter.string(from: date)
                
                if groupedBookings[monthDate] == nil {
                    groupedBookings[monthDate] = (monthString: monthKey, bookings: [])
                }
                groupedBookings[monthDate]?.bookings.append(booking)
            }
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
        
        var groupedOrders = [String: [Order]]()
        
        for order in orders {
            guard let dateString = order.createdAt,
                  let date = dateFormatter.date(from: dateString) else {
                print("Failed to parse date for order: \(order.id ?? 0), date string: \(order.createdAt ?? "nil")")
                continue
            }
            
            let monthKey = monthFormatter.string(from: date)
            groupedOrders[monthKey, default: []].append(order)
        }
        
        self.ordersSections = groupedOrders.map { monthKey, orders in
            OrdersSection(month: monthKey, orders: orders)
        }.sorted { section1, section2 in
            guard let date1 = monthFormatter.date(from: section1.month),
                  let date2 = monthFormatter.date(from: section2.month) else {
                return false
            }
            return date1 > date2
        }
        
        
        
    }
    
}
extension MyActivityViewModel{
    func ShowAppointmentsDetails(booking:MyBookings){
        coordinator?.showAppointmentsActivity(bookingData: booking)
    }
    func showOrderDetails(order:Order){
        coordinator?.showOrderDetails(orderDetails: order)
    }
}
