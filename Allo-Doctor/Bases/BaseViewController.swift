//
//  BaseViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/09/2024.
//

import UIKit
import Combine

// A generic BaseViewController that works with any ViewModel type.
class BaseViewController<ViewModelType>: UIViewController {
    
    // MARK: - Properties
    var viewModel: ViewModelType
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - Setup UI
    func setupUI() {
        // Override this method to setup the UI in subclasses
        view.backgroundColor = .white
    }
    
    // MARK: - Bind ViewModel
    func bindViewModel() {
        // Override this method in subclasses to setup data bindings with Combine
    }
    
    // MARK: - Helper for handling errors
    func handleError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Combine Clean-Up
    deinit {
        cancellables.removeAll()
    }
}
