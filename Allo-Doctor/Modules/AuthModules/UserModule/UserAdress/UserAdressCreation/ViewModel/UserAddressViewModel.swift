//
//  UserAddressViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 09/11/2024.
//

import Foundation
enum OrderScreenType{
    case uploadPrescription
    case orderScreen
}
class UserAddressViewModel{
        var coordinator: HomeCoordinatorContact?
        private var cancellables = Set<AnyCancellable>()
        @Published var errorMessage: String?
        private var apiClient = APIClient()
        @Published var userAddresses : [UserAddress]?
        @Published var lat : String
        @Published var long : String
    var screenType:OrderScreenType
       var address = CurrentValueSubject<String, Never>("")
       var floor = CurrentValueSubject<String, Never>("")
       var appartmentNumber = CurrentValueSubject<String, Never>("")
  
    //    @Published var productId:Int?
        
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(),lat:String,long:String,screenType:OrderScreenType) {
            self.coordinator = coordinator
            self.apiClient = apiClient
            self.lat = lat
            self.long = long
        self.screenType = screenType
        }}
    extension UserAddressViewModel{
    func addUserAdress(){
       postUserAdress()
        }
   private  func  postUserAdress(){
       let addressBody = UserAddressBody(
               lat: lat,
               long: long,
               floor: floor.value,
               address: address.value,
               appartment_number: appartmentNumber.value.toInt() ?? 1
           )
       print(addressBody)
         NetworkService.shared.postData(endpoint:"admin/address-user/create", data: addressBody) { result in
             switch result {
             case .success(let data):
                 do {
                     let decoder = JSONDecoder()
                     let response = try decoder.decode(UserAddressResponseData.self, from: data)
              print (response)
                     self.navToRoot()
                 } catch {
                     self.errorMessage = "Failed to parse server response."
                     print("Decoding error: \(error.localizedDescription)")
                 }
                 
             case .failure(let error):
                 print(error)
               return
             }
         }
    }
        
}


extension UserAddressViewModel{
   func navBack(){
       if screenType == .uploadPrescription{
           coordinator?.navigateBack()}
       else {
           coordinator?.navigationBack()
       }
    }
    func navToRoot(){
        if screenType == .uploadPrescription{
            coordinator?.navigateBack()}
        else {
            coordinator?.navigateToRootFromPresentation()
        }
      
    }
}
