//
//  AppointmentCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/10/2024.
//

import UIKit

class AppointmentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var appointmentLabel: CairoSemiBold!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Set default styles
        resetStyles()
    }

    /// Configures the cell based on the appointment's availability and selection status.
    /// - Parameters:
    ///   - isAvailable: Boolean indicating if the appointment is available.
    ///   - isSelected: Boolean indicating if the appointment is selected.
    func configureCell(isAvailable: Bool, isSelected: Bool) {
        resetStyles() // Reset styles before applying new ones

        if !isAvailable {
            // Apply strikethrough if the appointment is unavailable
            let attributedText = NSAttributedString(
                string: appointmentLabel.text ?? "",
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.gray // Optional: Dim text color
                ]
            )
            appointmentLabel.attributedText = attributedText
            self.backgroundColor = .clear // Ensure no color change for unavailable appointments
        } else {
            // Available appointment
            appointmentLabel.attributedText = nil // Reset to plain text
            if isSelected {
                // Change cell color to blue if selected
                self.backgroundColor = UIColor.blueApp
                appointmentLabel.textColor = .white // Optional: Adjust text color for contrast
            } else {
                // Keep the default style for available appointments
                self.backgroundColor = .clear
                appointmentLabel.textColor = .blueApp
            }
        }
    }

    /// Resets the cell styles to the default state.
    private func resetStyles() {
        appointmentLabel.attributedText = nil
        appointmentLabel.textColor = .blueApp
        self.backgroundColor = .clear
    }
}
