//
//  WordStackView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 03/10/2024.
//

import UIKit

// Custom UI Component class
class WordStackView: UIView {

    // UIStackView to hold word views
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
    }

    // Initial setup for the stack view
    private func setupStackView() {
        // Add stack view to the main view
        addSubview(stackView)
        
        // Set up constraints for the stack view to match parent view's size
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    // Function to update the stack view with new words
    func updateWords(_ words: [String]) {
        // Remove existing word views from the stack view
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Create and add new word views for each word in the array
        for word in words {
            let wordView = createWordView(with: word)
            stackView.addArrangedSubview(wordView)
        }
    }

    // Method to create a view for a word
    private func createWordView(with word: String) -> UIView {
        let wordLabel = UILabel()
        wordLabel.text = word
        wordLabel.textAlignment = .center

        // Set specific properties as described
        wordLabel.frame = CGRect(x: 87, y: 155, width: 77, height: 25)
        wordLabel.backgroundColor = .white
        wordLabel.layer.cornerRadius = 30
        wordLabel.clipsToBounds = true
        wordLabel.layer.maskedCorners = [.layerMinXMinYCorner] // Top-left corner
        wordLabel.alpha = 0.0 // Set opacity to 0

        let wordView = UIView()
        wordView.addSubview(wordLabel)

        // Set constraints for wordLabel within wordView
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: wordView.topAnchor),
            wordLabel.leadingAnchor.constraint(equalTo: wordView.leadingAnchor),
            wordLabel.trailingAnchor.constraint(equalTo: wordView.trailingAnchor),
            wordLabel.bottomAnchor.constraint(equalTo: wordView.bottomAnchor),
            wordLabel.widthAnchor.constraint(equalToConstant: 77),
            wordLabel.heightAnchor.constraint(equalToConstant: 25)
        ])

        return wordView
    }
}

