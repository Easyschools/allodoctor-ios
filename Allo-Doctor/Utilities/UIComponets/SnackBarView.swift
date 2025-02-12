//
//  SnackBarView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 31/12/2024.
//

import UIKit

class Snackbar: UIView {

    private let messageLabel = UILabel()
    private var hideTimer: Timer?

    init(message: String, backgroundColor: UIColor, textColor: UIColor, duration: TimeInterval) {
        super.init(frame: .zero)
        setupSnackbar(message: message, backgroundColor: backgroundColor, textColor: textColor)
        showAtBottom(duration: duration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSnackbar(message: String, backgroundColor: UIColor, textColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true

        messageLabel.text = message
        messageLabel.textColor = textColor
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        addSubview(messageLabel)

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }

    private func showAtBottom(duration: TimeInterval) {
        guard let window = UIApplication.shared.windows.first else { return }
        window.addSubview(self)

        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20),
            self.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }

        hideTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
            self?.hide()
        }
    }

    private func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
