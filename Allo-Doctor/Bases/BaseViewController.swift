//
//  BaseViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/09/2024.
//

import UIKit


class BaseViewController<ViewModelType>: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    var viewModel: ViewModelType
    var cancellables = Set<AnyCancellable>()
    let textField = UITextField()
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupTapGesture() // Setup tap gesture to dismiss keyboard
        
        bindViewModel()
        setupUI()
        
        view.backgroundColor = .white
    }
    
    // MARK: - Setup Tap Gesture
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboards))
        tapGesture.cancelsTouchesInView = false // Allows other touch events to be processed
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Dismiss Keyboard
    @objc private func dismissKeyboards() {
        view.endEditing(true)
    }
    
    // MARK: - Setup UI
    func setupUI() {
        // Override this method to setup the UI in subclasses
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
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Combine Clean-Up
    deinit {
        cancellables.removeAll()
    }
}
