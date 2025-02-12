//
//  ClinicProfileViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import UIKit
import Kingfisher
import Combine

enum ContentTypes {
    case about, doctors, insurance, reviews
}

class ClinicProfileViewController: BaseViewController<ClinicProfileViewModel> {
    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var clinicLogo: CircularImageView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var clinicToolBar: UIToolbar!
    @IBOutlet weak var aboutToolBarItem: UIBarButtonItem!
    @IBOutlet weak var doctorsToolBarItem: UIBarButtonItem!
    @IBOutlet weak var reviewsToolBarItem: UIBarButtonItem!
    @IBOutlet weak var insuranceToolBarItem: UIBarButtonItem!
    
    // MARK: - Properties
    private var clinicData: Clinic?
    private var currentContentType: ContentTypes?

    // Publishers for different content types
    private let aboutSubject = PassthroughSubject<Clinic?, Never>()
    private let doctorsSubject = PassthroughSubject<[ClinicDoctor], Never>()
    private let reviewsSubject = PassthroughSubject<Clinic?, Never>()
    private let insuranceSubject = PassthroughSubject<Clinic?, Never>()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindClinicData()
        showContent(for: .about)
        viewModel.fetchClinicData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upperView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
        updateClinicLogo()
    }

    // MARK: - Setup
    internal override func setupUI() {
        clinicToolBar.isHidden = false
        // Additional UI setup if needed
    }

    // MARK: - Data Binding
    private func bindClinicData() {
        viewModel.$clinicData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] clinic in
                self?.clinicData = clinic
                self?.updateUI()
            
            }
            .store(in: &cancellables)
    }

    // MARK: - UI Updates
    private func updateUI() {
        updateClinicLogo()
        showContent(for: currentContentType ?? .about)
    }

    private func updateClinicLogo() {
        if let imageUrlString = clinicData?.image, let imageUrl = URL(string: imageUrlString) {
            clinicLogo.kf.setImage(with: imageUrl)
        }
    }

    // MARK: - Content Management
    private func showContent(for contentType: ContentTypes) {
        clinicToolBar.isHidden = false
        contentView.subviews.forEach { $0.removeFromSuperview() }

        let newView: UIView
        switch contentType {
        case .about:
            let aboutView = AboutClinicView(frame: contentView.bounds)
            aboutView.aboutClinicPublisher = aboutSubject.eraseToAnyPublisher()
            aboutView.bindData()
            newView = aboutView
            aboutSubject.send(clinicData)
        case .doctors:
            let doctorsView = ClinicDoctorsView(frame: contentView.bounds)
            doctorsView.doctorsPublisher = doctorsSubject.eraseToAnyPublisher()
            doctorsView.bindData()
            newView = doctorsView
            doctorsSubject.send(clinicData?.doctors ?? [])
        case .insurance:
            newView = ClinicInsuranceView(frame: contentView.bounds)
            aboutSubject.send(clinicData)
        case .reviews:
            newView = ReviewsUIView(frame: contentView.bounds)
            reviewsSubject.send(clinicData)
        }

        newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(newView)

        currentContentType = contentType
        updateToolbarItemSelection(for: contentType)
    }

    private func updateToolbarItemSelection(for contentType: ContentTypes) {
        let selectedColor = UIColor.appColor
        let defaultColor = UIColor.black

        aboutToolBarItem.tintColor = contentType == .about ? selectedColor : defaultColor
        doctorsToolBarItem.tintColor = contentType == .doctors ? selectedColor : defaultColor
        reviewsToolBarItem.tintColor = contentType == .reviews ? selectedColor : defaultColor
        insuranceToolBarItem.tintColor = contentType == .insurance ? selectedColor : defaultColor
    }

    // MARK: - Actions
    @IBAction func aboutToolBarItemAction(_ sender: Any) {
        showContent(for: .about)
    }

    @IBAction func doctorsToolBarItemAction(_ sender: Any) {
        showContent(for: .doctors)
    }

    @IBAction func reviewsToolBarButtonAction(_ sender: Any) {
        showContent(for: .reviews)
    }

    @IBAction func insuranceToolBarButtonAction(_ sender: Any) {
        showContent(for: .insurance)
    }

    @IBAction func navigationBackAction(_ sender: Any) {
        viewModel.coordinator?.navigateBack()
    }
}
