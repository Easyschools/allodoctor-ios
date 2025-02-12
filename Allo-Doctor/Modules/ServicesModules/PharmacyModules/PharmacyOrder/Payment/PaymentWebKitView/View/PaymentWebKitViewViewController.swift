//
//  PaymentWebKitViewViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/12/2024.
//

import UIKit
import WebKit

class PaymentWebKitViewViewController: BaseViewController<PaymentWebKitViewViewModel> {
    private var webView: WKWebView!
    private var customNavBar: UIView!
    private var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavBar()
        setupWebView()
        setupBindings()
        loadURL()
    }
    
    private func setupCustomNavBar() {
        customNavBar = UIView()
        customNavBar.backgroundColor = .white
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavBar)
        
        // Configure button with specific styling
        doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        doneButton.setTitleColor(.appColor, for: .normal)
        doneButton.backgroundColor = .clear
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.addSubview(doneButton)
        
        let topPadding: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        
        NSLayoutConstraint.activate([
            // Nav bar constraints
            customNavBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 34 + topPadding),
            
            // Button constraints
            doneButton.leadingAnchor.constraint(equalTo: customNavBar.leadingAnchor, constant: 16),
            doneButton.bottomAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: -10),
            doneButton.widthAnchor.constraint(equalToConstant: 60),
            doneButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupWebView() {
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        // Add any additional bindings if needed
    }
    
    private func loadURL() {
        guard viewModel.validateURL(),
              let url = URL(string: viewModel.urlString) else {
            handleError(message: viewModel.errorMessage ?? "Invalid URL")
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    private func handleError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func doneButtonTapped() {
        viewModel.completePayment()
        viewModel.navBack()
    }
}
