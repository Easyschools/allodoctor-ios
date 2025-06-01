//
//  MovableView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 22/11/2024.
//

import UIKit

class MovableView: UIView {
    private var initialCenter: CGPoint = .zero // Store the original center

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPanGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPanGesture()
    }

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGesture)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let superview = self.superview else { return }

        switch gesture.state {
        case .began:
            // Save the initial center when the gesture starts
            initialCenter = self.center
        case .changed:
            // Only allow vertical movement by changing the `y` position
            let translation = gesture.translation(in: superview)
            self.center = CGPoint(x: initialCenter.x, y: initialCenter.y + translation.y)
        case .ended, .cancelled, .failed:
            // Return to the original position when the gesture ends
            UIView.animate(withDuration: 0.3) {
                self.center = self.initialCenter
            }
        default:
            break
        }
    }
}
