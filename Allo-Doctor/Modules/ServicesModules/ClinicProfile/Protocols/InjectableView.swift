//
//  InjectableView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/09/2024.
//

import UIKit

protocol InjectableView: AnyObject {
    var clinicPublisher: AnyPublisher<ClinicInfo, Never> { get set }
}
