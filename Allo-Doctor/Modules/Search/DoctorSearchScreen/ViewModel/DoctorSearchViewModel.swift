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
    @Published var errorMessage: String?
    @Published var cities: [City] = []
    var doctorPlace: DoctorPlace
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(),specialityId:String?,externalClinicServiceId:Int?,doctorPlace: DoctorPlace) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.specialityId = specialityId
        self.externalClinicServiceId = externalClinicServiceId
        self.doctorPlace = doctorPlace
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
        let encodedText = searchedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let district = districtId.map { "\($0)" } ?? ""
        let speciality = specialityId
        let urlString = "https://allodoctor-backend.developnetwork.net/api/admin/doctor/all?is_paginate=30&speciality_id=\(speciality ?? "")&search=\(encodedText)&web=1&sort_by=\(sortBy)&district_id=\(district)&title_type_en=\(filters?.titleType ?? "")&gender=\(filters?.gender ?? "")&max_price=\(filters?.maxPrice?.toString ?? "")&medical_insurance=\(filters?.medicalInsuranceId?.toString() ?? "")&external_clinic_service_id=\(externalClinicServiceId?.toString() ?? "")"
         print(urlString)
         guard let url = URL(string: urlString) else {
             print("Invalid URL")
             return
         }
         print(url)
       
        apiClient.fetchData(from: url, as: DoctorsResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch doctors: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] doctorResponse in
                self?.doctors = doctorResponse.data
                print("Fetched \(doctorResponse.data.count) doctors")
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
