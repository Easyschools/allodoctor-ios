//
//  DoctorFilterViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/12/2024.
//

import UIKit
struct FilterOptions {
    var titleType: String?
    var medicalInsuranceId: Int?
    var maxPrice: Float?
    var gender: String?
}


class DoctorFilterViewController: UIViewController {
    @IBOutlet weak var maxmuimPriceLabel: CairoRegular!
    let filtersSubject = PassthroughSubject<FilterOptions, Never>()
    @IBOutlet weak var genderSelectionView: GenderSelectionControl!
    @IBOutlet weak var doctorType: DoctorTypeSelectionControl!
    var titleType:String?
    var gender:String?
    var currentFilters: FilterOptions?
    let apiClient = APIClient()
    var cancellables = Set<AnyCancellable>()
    var insuranseID:Int?
    private var items: [InsuranceCompany] = []
    
    @IBOutlet weak var priceSlider: UISlider!
    @IBOutlet weak var maxPrice: CairoRegular!
    @IBOutlet weak var minPrice: CairoRegular!
    @IBOutlet weak var insuranceSelectView: DropDownWithImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        fetchInsuranceCompanies()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        insuranceSelectView.dismissDropdownIfNeeded()
    }

    @IBAction func dismissAction(_ sender: Any) {
        insuranceSelectView.dismissDropdownIfNeeded()
        self.dismiss(animated: true)
    }
    @IBAction func sliderAction(_ sender: Any) {
        maxPrice.text = priceSlider.value.toInt.toString().appendingWithSpace(AppLocalizedKeys.EGP.localized)
    }
    @IBAction func confirmationButton(_ sender: Any) {
        applyFilters()
        self.dismiss(animated: true)
    }
    private func setupUi() {

        // Insurance selection setup
        insuranceSelectView.selectionPublisher
            .sink { selectedItem in
                if let name = selectedItem["name"] as? String, let id = selectedItem["id"] as? Int {
                    self.insuranseID = id
                }
            }
            .store(in: &cancellables)
        
        // Gender selection setup
        genderSelectionView.onGenderSelected = { [weak self] selectedGender in
            guard let self = self else { return }
            if let selectedGender = selectedGender {
                self.gender = selectedGender.rawValue
            } else {
                self.gender = nil
            }
        }
        
        // Doctor type selection setup
        doctorType.onTypeSelected = { [weak self] selectedType in
            guard let self = self else { return }
            if let selectedType = selectedType {
                self.titleType = selectedType.rawValue
            } else {
                self.titleType = nil
            }
        }
        
        // Set initial values if already selected
        if let selectedGender = genderSelectionView.getSelectedGender() {
            self.gender = selectedGender.rawValue
        }
        
        if let selectedType = doctorType.getSelectedType() {
            self.titleType = selectedType.rawValue
        }

        // Configure insurance view
        insuranceSelectView.configure(with: [],
            placeholder: AppLocalizedKeys.SelectInsurance.localized,
            image: UIImage.insuranceicon)
    }}

extension DoctorFilterViewController {
    private func fetchInsuranceCompanies() {
        guard let url = URL(string: "https://allodoctor-backend.developnetwork.net/api/admin/medical-insurance/all") else {
            print("Invalid URL")
            return
        }
        
        apiClient.fetchData(from: url, as: InsuranceResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to fetch data: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] insuranceResponse in
                guard let self = self else { return }
                self.items = insuranceResponse.data ?? []
                let formattedInsuranceCompanies = self.items.map { company in
                    [
                        "id": company.id,
                        "name": company.name_en
                        
                    ]
                   
                }
                self.insuranceSelectView.configure(
                    with: formattedInsuranceCompanies,
                    placeholder: AppLocalizedKeys.SelectInsurance.localized,
                    image: UIImage.insuranceicon
                )
              
            })
            .store(in: &cancellables)
    }
    func applyFilters(){

        let selectedFilters = FilterOptions(
                    titleType:titleType,
                    medicalInsuranceId: insuranseID,
                    maxPrice:priceSlider.value,
                    gender: gender
                )
        filtersSubject.send(selectedFilters)
    }
}
