//
//  CustomPageController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 05/09/2024.
//

import UIKit

@IBDesignable
class CustomPageControl: UIControl {
    
    // MARK: - Properties
    
    private var dotViews = [UIView]()
    
    @IBInspectable var numberOfPages: Int = 0 {
        didSet {
            configureDotViews()
        }
    }
    
    @IBInspectable var currentPage: Int = 0 {
        didSet {
            updateCurrentPageAppearance()
        }
    }
    
    @IBInspectable var pageIndicatorTintColor: UIColor? = .lightGray
    @IBInspectable var currentPageIndicatorTintColor: UIColor? = .appColor
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(frame: self.bounds)
        stack.alignment = .center
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        addSubview(stackView)
        setupPageControlConstraints() // Automatically called when the view is initialized
    }
    
    private func configureDotViews() {
        // Remove old dots
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews.removeAll()
        
        // Create new dot views
        for index in 0..<numberOfPages {
            let dot = createDotView(for: index)
            dotViews.append(dot)
            stackView.addArrangedSubview(dot)
        }
    }
    
    private func createDotView(for index: Int) -> UIView {
        let dot = UIView()
        dot.tag = index
        dot.translatesAutoresizingMaskIntoConstraints = false
        styleDotView(dot, isCurrent: index == currentPage)
        return dot
    }
    
    private func setupPageControlConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 30),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
    }
    
    // MARK: - Dot Styling
    
    private func styleDotView(_ dot: UIView, isCurrent: Bool) {
        dot.transform = .identity
        dot.layer.cornerRadius = dot.bounds.height / 2
        dot.layer.masksToBounds = true
        dot.backgroundColor = isCurrent ? currentPageIndicatorTintColor : pageIndicatorTintColor
        
        if isCurrent {
            applyCurrentPageStyle(to: dot)
        }
    }
    
    private func applyCurrentPageStyle(to dot: UIView) {
        UIView.animate(withDuration: 0.2) {
            dot.layer.cornerRadius = dot.bounds.height / 4
            dot.transform = CGAffineTransform(scaleX: 1.5, y: 1)
        }
    }
    
    // MARK: - Update Current Page Appearance
    
    private func updateCurrentPageAppearance() {
        for (index, dot) in dotViews.enumerated() {
            let isCurrent = index == currentPage
            styleDotView(dot, isCurrent: isCurrent)
        }
    }
}
