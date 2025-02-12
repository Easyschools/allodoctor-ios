//
//  CartManger.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 06/11/2024.
//
import Foundation
struct GrandTotalManger {
    static let grandTotalUpdatePublisher = PassthroughSubject<Void, Never>()
    
    static func updateOtherViewControllers() {
   
        grandTotalUpdatePublisher.send()
    }
}
protocol addToCartTapped: AnyObject {
    func didTapButton()
}
