//
//  LoadingIndicator.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 18/12/2024.
//

import UIKit

class LoadingIndicator {
    static let shared = LoadingIndicator()
    
    private var spinnerView: UIView?
    private let spinnerSize: CGFloat = 50
    
    private init() {}
    
    /// Shows the loading indicator
    /// - Parameters:
    ///   - onView: The view where the indicator should appear (default is the main window).
    func show(onView: UIView? = UIApplication.shared.windows.first(where: { $0.isKeyWindow })) {
        guard let parentView = onView, spinnerView == nil else { return }
        
        // Create a semi-transparent background with reduced blur
        let spinnerView = UIView(frame: parentView.bounds)
        spinnerView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        
        // Set up constraints
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create a circular spinner like Twitter
        let circularSpinner = CircularSpinner(frame: CGRect(x: 0, y: 0, width: spinnerSize, height: spinnerSize))
        circularSpinner.translatesAutoresizingMaskIntoConstraints = false
        
        spinnerView.addSubview(circularSpinner)
        
        // Add to parent view
        if let window = parentView as? UIWindow {
            // If it's a window, add above the root view controller's view
            if let rootViewController = window.rootViewController {
                rootViewController.view.addSubview(spinnerView)
            }
        } else {
            parentView.addSubview(spinnerView)
        }
        
        // Set up constraints for spinner view
        NSLayoutConstraint.activate([
            spinnerView.topAnchor.constraint(equalTo: parentView.topAnchor),
            spinnerView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            spinnerView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ])
        
        // Center the circular spinner
        NSLayoutConstraint.activate([
            circularSpinner.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor),
            circularSpinner.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor),
            circularSpinner.widthAnchor.constraint(equalToConstant: spinnerSize),
            circularSpinner.heightAnchor.constraint(equalToConstant: spinnerSize)
        ])
        
        // Ensure it's above safe area
        spinnerView.layer.zPosition = CGFloat.greatestFiniteMagnitude
        
        self.spinnerView = spinnerView
    }
    
    /// Hides the loading indicator
    func hide() {
        spinnerView?.removeFromSuperview()
        spinnerView = nil
    }
}

class CircularSpinner: UIView {
    private let spinnerLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSpinner()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSpinner()
    }
    
    private func setupSpinner() {
        // Define the circular path
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
                                      radius: bounds.width / 2 - 5,
                                      startAngle: 0,
                                      endAngle: CGFloat.pi * 2,
                                      clockwise: true)
        
        // Configure the spinner layer
        spinnerLayer.path = circularPath.cgPath
        spinnerLayer.strokeColor = UIColor.blueApp.cgColor
        spinnerLayer.lineWidth = 4
        spinnerLayer.fillColor = UIColor.clear.cgColor
        spinnerLayer.lineCap = .round
        spinnerLayer.strokeStart = 0
        spinnerLayer.strokeEnd = 0.4
        
        layer.addSublayer(spinnerLayer)
        
        // Add rotation animation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 1.2
        rotationAnimation.repeatCount = .infinity
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}
