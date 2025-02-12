//
//  OnBoardingScreensViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/09/2024.
// MARK: - OnBoardingScreensViewModel
import UIKit
class OnBoardingScreensViewModel {
  
        @Published var currentImageIndex: Int = 0
        @Published var images: [UIImage] = []
        
        weak var coordinator: HomeCoordinatorContact?
        

    // MARK: - Models
    private struct OnboardingContent {
        let image: UIImage
        let title: String
        let description: String
    }
    
    // MARK: - Private Properties
    private let onboardingContent: [OnboardingContent]
    
    // MARK: - Initialization
    init() {
        self.onboardingContent = [
            OnboardingContent(
                image: .doctorOnboarding,
                title: "Pharmacy services",
                description: "Our Pharmacy Services make managing your medications simple and stress-free. Whether you need to purchase prescriptions, find over-the-counter products, or request delivery, we’ve got you covered."
            ),
            OnboardingContent(
                image: .pharmacyOnboard,
                title: "Book Appointments",
                description: "Our Booking & Consultations feature empowers you to connect with healthcare providers in just a few clicks. Whether you need to book an appointment with a doctor, schedule a consultation, or arrange specialized care, we’ve made the process seamless and intuitive."
            ),
            OnboardingContent(
                image: .emergenceyOnboard,
                title: "Get Medical Advice",
                description: "Our Emergency Services are designed to provide rapid access to critical medical assistance during urgent situations. With a streamlined process, help is just a few taps away."
            )
        ]
        
        self.images = onboardingContent.map { $0.image }
    }
    
    // MARK: - Public Methods
    var isLastScreen: Bool {
        currentImageIndex == onboardingContent.count - 1
    }
    
    func scrollToNextImage() {
        guard !isLastScreen else { return }
        currentImageIndex += 1
    }
    
    func updateCurrentIndex(_ index: Int) {
        guard index >= 0, index < onboardingContent.count else { return }
        currentImageIndex = index
    }
    
    func getContent(for index: Int) -> (title: String, description: String)? {
        guard index >= 0, index < onboardingContent.count else { return nil }
        let content = onboardingContent[index]
        return (content.title, content.description)
    }
    func navToNumberScreen(){
        coordinator?.showPhonenumberScreen()
    }
    func navToTabBarAsGuest(){
        coordinator?.showTabBar()
    }
}


