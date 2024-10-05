//
//  CustomPaddingbutton.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/09/2024.
//

import UIKit

@IBDesignable
class CustomPaddingButton: UIButton {

        // IBInspectable properties for padding and image position
        @IBInspectable var imagePadding: CGFloat = 0 {
            didSet {
                updateEdgeInsets()
            }
        }

        @IBInspectable var isImageOnRight: Bool = false {
            didSet {
                updateEdgeInsets()
            }
        }

        // Adjust image and title insets
        private func updateEdgeInsets() {
            let imagePaddingValue = isImageOnRight ? imagePadding : -imagePadding
            let titlePaddingValue = isImageOnRight ? -imagePadding : imagePadding

            if imageView != nil {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: imagePaddingValue, bottom: 0, right: -imagePaddingValue)
            }

            if titleLabel != nil {
                titleEdgeInsets = UIEdgeInsets(top: 0, left: titlePaddingValue, bottom: 0, right: -titlePaddingValue)
            }

            // Update content insets for total padding effect
            contentEdgeInsets = UIEdgeInsets(top: 0, left: imagePadding, bottom: 0, right: imagePadding)

            // Swap positions if the image is on the right
            if isImageOnRight, let titleLabel = titleLabel, let imageView = imageView {
                let titleWidth = titleLabel.intrinsicContentSize.width
                let imageWidth = imageView.frame.width

                // Shift title to the left by the width of the image, and image to the right by the width of the title
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
                imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth + imagePadding, bottom: 0, right: -titleWidth - imagePadding)
            }
        }

        // Ensure that insets are updated when layout changes
        override func layoutSubviews() {
            super.layoutSubviews()
            updateEdgeInsets()
        }
    }


