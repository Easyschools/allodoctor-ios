//
//  OneDayCareProfileViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/12/2024.
//

import UIKit


enum OneDayCareContentTypes {
    case aboutHospital, oneDayCareServices
}

class OneDayCareProfileViewController: BaseViewController<OneDayCareProfileViewModel> {
    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var toggleSwitch: CustomToggleSwitch!
    
    // MARK: - Properties
    private var currentContentType: OneDayCareContentTypes = .oneDayCareServices
   
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.getHospitalData()
        setupBindings()
        showContent(for: .aboutHospital)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upperView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
    }
    
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    // MARK: - Setup
 override func setupUI() {
        // Configure the toggle switch
     toggleSwitch.setToggleOptions([AppLocalizedKeys.AboutHospital.localized, AppLocalizedKeys.OneDayCareServices.localized])
        toggleSwitch.onToggle = { [weak self] selectedIndex in
            guard let self = self else { return }
            let selectedContentType: OneDayCareContentTypes = selectedIndex == 0 ? .aboutHospital : .oneDayCareServices
            self.showContent(for: selectedContentType)
        }
    }
    
    private func setupBindings() {
        viewModel.$hospitalData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.updateLoadingState(isLoading)
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Updates
    private func updateUI() {
        showContent(for: currentContentType)
    }
    
    private func updateLoadingState(_ isLoading: Bool) {
        if isLoading {
           
        } else {
          
        }
    }
    
    private func showError(_ error: Error) {
        // Implement your error handling UI here
        print("Error: \(error.localizedDescription)")
    }
    
    // MARK: - Content Management
    private func showContent(for contentType: OneDayCareContentTypes) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let newView: UIView
        switch contentType {
        case .aboutHospital:
            let aboutHospitalView = HospitalProfileView(frame: contentView.bounds)
            aboutHospitalView.bindData(to: viewModel.$hospitalData.eraseToAnyPublisher())
            newView = aboutHospitalView
            
        case .oneDayCareServices:
            let servicesView = ServiciesView(frame: contentView.bounds)
            servicesView.bindData(to: viewModel.$hospitalData.eraseToAnyPublisher())
            servicesView.bindSelection { [weak self] serviceId in
                self?.handleServiceSelection(serviceId)
            }
            newView = servicesView
        }
        
        newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(newView)
        currentContentType = contentType
    }
    
    private func handleServiceSelection(_ serviceId: Int) {
        viewModel.showOneDayCareAppointments(serviceId: serviceId)
    }
}
