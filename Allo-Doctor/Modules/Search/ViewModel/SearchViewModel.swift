//
//  SearchViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 18/09/2024.
//

import Foundation
class SearchViewModel{
    @Published var specialties: [Specialty] = []
    @Published var cities:[City] = []
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private var apiClient = APIClient()
    var coordinator: HomeCoordinatorContact?
    init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
}
extension SearchViewModel{
    func fetchSpecialties(id:Int){
        let router = APIRouter.fetchInfoService(id: id)
       
        apiClient.fetchData(from:router.url, as: HospitalData.self)
            .sink(receiveCompletion:{ completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Failed to fetch Services: \(error.localizedDescription)"
                    
                }}
                ,receiveValue: { speciality in
                self.specialties =  speciality.data.specialties
                }).store(in: &cancellables)
    }
    func fetchCities(){
//        apiClient.fetchData(from:, as: CityResponse.self)
//            .sink(receiveCompletion: {completion in switch completion{
//            case.finished:
//                break
//            case.failure(let error):
//                self.errorMessage  = "Failed to fetch Services: \(error.localizedDescription)"
//            }}
//            ,receiveValue:{ citiesResponse in
//                self.cities = citiesResponse.data
//            } ).store(in: &cancellables)
    }
}
             
