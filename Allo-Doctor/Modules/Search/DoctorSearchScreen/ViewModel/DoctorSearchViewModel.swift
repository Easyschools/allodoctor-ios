//
//  DoctorSearchViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import UIKit

class DoctorSearchViewModel {
    @Published var filters: FilterOptions?
    @Published var doctors: [DoctorProfile] = []
    @Published var searchText = ""
    var coordinator: HomeCoordinatorContact?
    private var apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
    private var specialityId:String?
    private let externalClinicServiceId : Int?
    private let infoServiceId: Int?
    private let serviceId: Int?
    @Published var errorMessage: String?
    @Published var cities: [City] = []
    var doctorPlace: DoctorPlace

    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(),specialityId:String?,externalClinicServiceId:Int?,doctorPlace: DoctorPlace, infoServiceId: Int? = nil, serviceId: Int? = nil) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.specialityId = specialityId
        self.externalClinicServiceId = externalClinicServiceId
        self.doctorPlace = doctorPlace
        self.infoServiceId = infoServiceId
        self.serviceId = serviceId

        // Debug logging for initialization
        print("🔍 DoctorSearchViewModel initialized with:")
        print("   - specialityId: \(specialityId ?? "nil")")
        print("   - infoServiceId: \(String(describing: infoServiceId))")
        print("   - serviceId: \(String(describing: serviceId))")
        print("   - externalClinicServiceId: \(String(describing: externalClinicServiceId))")
        print("   - doctorPlace: \(doctorPlace)")

        setupSearchSubscription()
    }

    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.fetchDoctors(searchedText: searchText, sortBy:  "", districtId: nil, maxPrice: self?.filters?.maxPrice?.toString ?? "", medicalInsuranceId: self?.filters?.medicalInsuranceId?.toString() ?? "", gender: self?.filters?.gender ?? "",title:self?.filters?.titleType ?? "")
            }
            .store(in: &cancellables)
    }

    func fetchDoctors(searchedText: String,sortBy:String,districtId:Int?,maxPrice:String,medicalInsuranceId:String,gender:String,title:String) {
        // Build URL properly using URLComponents
        var components = URLComponents(string: "https://backend.allo-doctor.com/api/admin/doctor/all")!

        var queryItems: [URLQueryItem] = []

        // Required parameters
        queryItems.append(URLQueryItem(name: "is_paginate", value: "30"))
        queryItems.append(URLQueryItem(name: "web", value: "1"))

        // Core filtering parameters - add only if they have values
        if let specialityId = specialityId, !specialityId.isEmpty, externalClinicServiceId == nil {
            queryItems.append(URLQueryItem(name: "speciality_id", value: specialityId))
        }

        if let infoServiceId = infoServiceId {
            queryItems.append(URLQueryItem(name: "info_service_id", value: "\(infoServiceId)"))
        }

        if let serviceId = serviceId {
            queryItems.append(URLQueryItem(name: "service_id", value: "\(serviceId)"))
        }

        if let externalClinicServiceId = externalClinicServiceId {
            queryItems.append(URLQueryItem(name: "external_clinic_service_id", value: "\(externalClinicServiceId)"))
        }

        // Search and filters - add only if not empty
        if !searchedText.isEmpty {
            queryItems.append(URLQueryItem(name: "search", value: searchedText))
        }

        if !sortBy.isEmpty {
            queryItems.append(URLQueryItem(name: "sort_by", value: sortBy))
        }

        if let districtId = districtId {
            queryItems.append(URLQueryItem(name: "district_id", value: "\(districtId)"))
        }

        if !title.isEmpty {
            queryItems.append(URLQueryItem(name: "title_type_en", value: title))
        }

        if !gender.isEmpty {
            queryItems.append(URLQueryItem(name: "gender", value: gender))
        }

        if !maxPrice.isEmpty {
            queryItems.append(URLQueryItem(name: "max_price", value: maxPrice))
        }

        if !medicalInsuranceId.isEmpty {
            queryItems.append(URLQueryItem(name: "medical_insurance", value: medicalInsuranceId))
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            print("❌ Failed to construct URL")
            return
        }

        // Enhanced logging
        print("🔍 API URL: \(url.absoluteString)")
        print("📋 Parameters:")
        print("   - specialityId: \(specialityId ?? "nil")")
        print("   - infoServiceId: \(infoServiceId?.description ?? "nil")")
        print("   - serviceId: \(serviceId?.description ?? "nil")")
        print("   - externalClinicServiceId: \(externalClinicServiceId?.description ?? "nil")")
        print("   - search: \(searchedText.isEmpty ? "empty" : searchedText)")

        apiClient.fetchData(from: url, as: DoctorsResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("❌ API Error: \(error)")
                    self?.errorMessage = "Failed to fetch doctors: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] doctorResponse in
                self?.doctors = doctorResponse.data
                print("✅ Fetched \(doctorResponse.data.count) doctors")
                if doctorResponse.data.isEmpty {
                    print("⚠️ No doctors found with current filters")
                }
            })
            .store(in: &cancellables)
    }

    func navToDoctorProfile(doctorID: String,doctorServiveSpecialityId:Int) {
        if doctorPlace == .outpatientClinics {
            coordinator?.showDoctorProfile(doctorID: doctorID, doctorPlace:.outpatientClinics)
        }
        else{
            coordinator?.showDoctorProfile(doctorID: doctorID, doctorPlace:.doctorClinics)
        }
    }
    func getAllAreaOfResidence() {
          let router = APIRouter.fetchCities
          apiClient.fetchData(from: router.url, as: CityDataResponse.self)
              .sink(receiveCompletion: { completion in
                  switch completion {
                  case .finished:
                      break
                  case .failure(let error):
                      self.errorMessage = "Failed to fetch Cities: \(error.localizedDescription)"
                  }
              }, receiveValue: { citiesResponse in
                  self.cities = citiesResponse.data ?? []
              })
              .store(in: &cancellables)
      }
    func presentFiter(viewController:UIViewController){
        let filterVC = DoctorFilterViewController()
        filterVC.filtersSubject
                    .sink { [weak self] selectedFilters in
                        self?.filters = selectedFilters
                        self?.fetchDoctors(searchedText: "", sortBy:  "", districtId: nil, maxPrice: self?.filters?.maxPrice?.toString ?? "", medicalInsuranceId: self?.filters?.medicalInsuranceId?.toString() ?? "", gender: self?.filters?.gender ?? "",title:self?.filters?.titleType ?? "")
                    }
                    .store(in: &cancellables)
        let sheetController = FWIPNSheetViewController(controller: filterVC, sizes: [.fixed(620)])
        sheetController.cornerRadius = 16
       
        viewController.present(sheetController, animated: true, completion: nil)
    }
}
