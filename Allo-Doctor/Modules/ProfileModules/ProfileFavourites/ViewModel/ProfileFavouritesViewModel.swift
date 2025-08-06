//
//  ProfileFavouritesViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 29/12/2024.
//

class ProfileFavouritesViewModel {
    // MARK: - Properties
    var coordinator: HomeCoordinatorContact?
    private let apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()

    // Published Properties
    @Published var favData: Favourites?
    
    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
    
    func fetchDoctorFavourite() {
        let router = APIRouter.getallFavsourites

        apiClient.fetchData(from: router.url, as: Favourites.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.favData = response
            }).store(in: &cancellables)
    }
    
    func deleteFav(entity: String, favId: Int) {
        let entity = entity.lowercased()
        let router = APIRouter.delteFav(entity: entity, id: favId)
        
        apiClient.deleteData(from: router.url, as: DeleteResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Delete request completed successfully.")
                    // Remove the item from local data after successful deletion
                    self?.removeItemFromLocalData(favId: favId)
                case .failure(let error):
                    print("Error during delete request: \(error)")
                }
            }, receiveValue: { response in
                print("Message: \(response.Message)")
                print("Data: \(response.data)")
            })
            .store(in: &cancellables)
    }
    
    private func removeItemFromLocalData(favId: Int) {
        // Remove the item from the local data array
        if var currentData = favData?.data {
            currentData.removeAll { item in
                item.favoritableID == favId
            }
            favData?.data = currentData
        }
    }
    
    func navToDoctors(doctorID: String) {
        coordinator?.showDoctorProfile(doctorID: doctorID, doctorPlace: .doctorClinics)
    }
    
    func navToPhramacy(pharmacyId: Int) {
        coordinator?.showPharmacyCategory(pharmacyId: pharmacyId)
    }
    
    func navBack() {
        coordinator?.navigateBack()
    }
}
