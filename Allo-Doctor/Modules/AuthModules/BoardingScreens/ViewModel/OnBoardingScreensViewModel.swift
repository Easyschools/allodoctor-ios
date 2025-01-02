//
//  OnBoardingScreensViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/09/2024.
//
import Foundation
import UIKit
import Combine

class OnBoardingScreensViewModel {
    // Published properties for binding
    @Published var currentImageIndex: Int = 0
    @Published var images: [UIImage] = []
    
    // Private properties
    private let imageARR = [
        UIImage(named: "offers"),
        UIImage(named: "offers"),
        UIImage(named: "offers")
    ].compactMap { $0 }
    
    private let serviceTitles = ["Discover Doctors", "Book Appointments", "Get Medical Advice"]
    private let serviceDescriptions = [
        "Find the best doctors in your area with ease.",
        "Schedule appointments at your convenience.",
        "Receive expert medical advice from the comfort of your home."
    ]
    
    // Initialize ViewModel
    init() {
        // Assign image array to the published images
        images = imageARR
    }
    
    // Method to scroll to the next image
    func scrollToNextImage() {
        if currentImageIndex < images.count - 1 {
            currentImageIndex += 1
        }
    }
    
    // Check if the last image is reached
    func isLastImage() -> Bool {
        return currentImageIndex == images.count - 1
    }
    
    // Get service title for a given index
    func getServiceTitle(for index: Int) -> String {
        return serviceTitles[safe: index] ?? ""
    }
    
    // Get service description for a given index
    func getServiceDescription(for index: Int) -> String {
        return serviceDescriptions[safe: index] ?? ""
    }
}


