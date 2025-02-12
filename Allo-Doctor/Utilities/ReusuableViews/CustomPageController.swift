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
    
    @IBInspectable var pageIndicatorTintColor: UIColor? = .lightGray {
        didSet {
            updateCurrentPageAppearance()
        }
    }
    
    @IBInspectable var currentPageIndicatorTintColor: UIColor? = .blue {
        didSet {
            updateCurrentPageAppearance()
        }
    }
    
    // MARK: - UI Components
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - View Setup
    private func setupViews() {
        backgroundColor = .clear
        addSubview(stackView)
        setupPageControlConstraints()
    }
    
    private func setupPageControlConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // MARK: - Dot Configuration
    private func configureDotViews() {
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews.removeAll()
        
        for index in 0..<numberOfPages {
            let dot = createDotView(for: index)
            dotViews.append(dot)
            stackView.addArrangedSubview(dot)
        }
        
        layoutIfNeeded()
        updateCurrentPageAppearance()
    }
    
    private func createDotView(for index: Int) -> UIView {
        let dot = UIView()
        dot.tag = index
        dot.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dot.widthAnchor.constraint(equalToConstant: 12),
            dot.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        styleDotView(dot, isCurrent: index == currentPage)
        return dot
    }
    
    // MARK: - Styling
    private func styleDotView(_ dot: UIView, isCurrent: Bool) {
        dot.layer.cornerRadius = 6
        dot.layer.masksToBounds = true
        
        if isCurrent {
            dot.backgroundColor = currentPageIndicatorTintColor
            applyCurrentPageStyle(to: dot)
        } else {
            dot.backgroundColor = pageIndicatorTintColor
            dot.transform = .identity
        }
    }
    
    private func applyCurrentPageStyle(to dot: UIView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
            dot.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        })
    }
    
    // MARK: - Updates
    private func updateCurrentPageAppearance() {
        guard currentPage >= 0 && currentPage < dotViews.count else { return }
        
        for (index, dot) in dotViews.enumerated() {
            styleDotView(dot, isCurrent: index == currentPage)
        }
    }
    
    // MARK: - Layout
    override var intrinsicContentSize: CGSize {
        return CGSize(width: CGFloat(numberOfPages * 20), height: 20)
    }
}
