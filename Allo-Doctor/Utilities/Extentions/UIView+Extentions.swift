//
//  UIView+Extentions.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/09/2024.
//

import UIKit
var bundle: Bundle {
    return Bundle(identifier: "com.DevelopNetwork.AlloDoctor")!
}
public extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var circular: Bool {
        get {
            return self.circular
        }
        set {
            layer.cornerRadius = layer.cornerRadius / 2
            layer.masksToBounds = true
        }
    }
    
    /* Circle View */
//    @IBInspectable var isCircle: Bool {
//        set {
//            layer.cornerRadius = self.frame.size.width / 2
//        }
//        get {
//            return self.isCircle
//        }
//    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return self.borderColor
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
}

public extension UIView {
    
    enum BorderSide {
        case top
        case left
        case bottom
        case right
    }
    
    var endX: CGFloat {
        return frame.origin.x + frame.width
    }
    
    var endY: CGFloat {
        return frame.origin.y + frame.height
    }
    
    var startX: CGFloat {
        return frame.origin.x
    }
    
    var startY: CGFloat {
        return frame.origin.y
    }
    
    var width: CGFloat {
        get {
            return frame.width
        } set(value) {
            self.frame.size = CGSize(width: value, height: height)
        }
    }
    
    var height: CGFloat {
        get {
            return frame.height
        } set(value) {
            self.frame.size = CGSize(width: width, height: value)
        }
    }
}

// MARK: - Methods

public extension UIView {
    
    func startX(x : CGFloat) {
        self.frame.origin.x = x
    }
    
    func startY( y : CGFloat) {
        self.frame.origin.y = y
    }
    
    func center(x : CGFloat, y : CGFloat) {
        self.center = CGPoint(x: x, y: y)
    }
    
    func centerX(x: CGFloat) {
        self.center = CGPoint(x: x, y: self.centerY())
    }
    
    func centerX() -> CGFloat {
        return self.center.x
    }
    
    func centerY(y : CGFloat) {
        self.center = CGPoint(x : self.centerX(), y : y)
    }
    
    func centerY() -> CGFloat {
        return self.center.y
    }
    
    func loadNibFile() {
        let bundle = Bundle(for: self.classForCoder)
        let view = UINib.init(nibName: String(describing: type(of: self)), bundle: bundle).instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func removeSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
    
}

// MARK: - UI Methods

public extension UIView {
    
    func dim() {
        self.alpha = 0.5
    }
    
    func unDim() {
        self.alpha = 1
    }
    
    func applyBorder(_ color: UIColor) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color.cgColor
    }
    
    func applyCornerRadius(corenrRadius : CGFloat , mask : Bool) {
        self.layer.masksToBounds = mask
        self.layer.cornerRadius = corenrRadius
    }
    
    func applyBottomBorder(_ color: UIColor) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color.cgColor
    }
    
    func addBorder(forSide side: BorderSide, withColor color: UIColor, borderWidth: CGFloat = 1) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .top:
            border.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.width,
                                  height: borderWidth)
        case .left:
            border.frame = CGRect(x: 0,
                                  y: 0,
                                  width: borderWidth,
                                  height: self.height)
        case .bottom:
            border.frame = CGRect(x: 0,
                                  y: self.height - borderWidth,
                                  width: self.width,
                                  height: borderWidth)
        case .right:
            border.frame = CGRect(x: self.width - borderWidth,
                                  y: 0,
                                  width: borderWidth,
                                  height: self.height)
        }
        self.layer.addSublayer(border)
    }
    
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func drawStroke(width: CGFloat, color: UIColor) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.width, height: self.width), cornerRadius: self.width/2)
        let shapeLayer = CAShapeLayer ()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        self.layer.addSublayer(shapeLayer)
    }
    
    func setGradientColors(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// reusable function to change view controller background gradient layer color.
    func setGradient(colors: [CGColor],
                     locations: [NSNumber],
                     startPoint: CGPoint,
                     endPoint: CGPoint) -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = colors
        gradientLayer.frame = bounds
        
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        return gradientLayer
    }
    func addUpperDropShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: -5) // Negative height to place shadow above the view
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: -self.layer.shadowRadius, width: self.bounds.width, height: self.bounds.height + self.layer.shadowRadius))
        self.layer.shadowPath = shadowPath.cgPath
    }
}



// MARK: - Animations

private let UIViewAnimationDuration: TimeInterval = 1
private let UIViewAnimationSpringDamping: CGFloat = 0.5
private let UIViewAnimationSpringVelocity: CGFloat = 0.5

private let UIViewAnimationDurationPop: TimeInterval = 0.2
private let UIViewAnimationScalePop: CGFloat = 1.1

private let UIViewAnimationDurationPopBig: TimeInterval = 0.2
private let UIViewAnimationScalePopBig: CGFloat = 1.25

private let UIViewAnimationDurationReversePop: TimeInterval = 0.05
private let UIViewAnimationScaleReversePop: CGFloat = 0.0

private let UIViewAnimationScaleOriginal: CGFloat = 1.0

extension UIView {
    
    func spring(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        spring(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }
    
    func spring(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: UIViewAnimationDuration,
            delay: 0,
            usingSpringWithDamping: UIViewAnimationSpringDamping,
            initialSpringVelocity: UIViewAnimationSpringVelocity,
            options: UIView.AnimationOptions.allowAnimatedContent,
            animations: animations,
            completion: completion
        )
    }
    
    func fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
    

    
}


public extension UIView {
    
    func shadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func shadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

// MARK: - UIView Helper methods
public extension UIView {

    /// Returns the grand super view of the current view.
    /// The grand super view is the topmost ancestor view in the view hierarchy.
    /// - Returns: The grand super view of the current view.
    var grandSuperView: UIView {
        var view: UIView = self
        
        while let superView = view.superview { view = superView }
        return view
    }

    /**
     Anchors the view to its superview or other views using Auto Layout constraints.
     
     - Parameters:
        - top: The top anchor of the view.
        - leading: The leading anchor of the view.
        - bottom: The bottom anchor of the view.
        - trailing: The trailing anchor of the view.
        - topConstant: The constant value for the top anchor.
        - leadingConstant: The constant value for the leading anchor.
        - bottomConstant: The constant value for the bottom anchor.
        - trailingConstant: The constant value for the trailing anchor.
        - widthConstant: The constant value for the width anchor.
        - heightConstant: The constant value for the height anchor.
     
     - Returns: An array of NSLayoutConstraint objects that represent the created constraints.
     */
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        topConstant: CGFloat = 0,
        leadingConstant: CGFloat = 0,
        bottomConstant: CGFloat = 0,
        trailingConstant: CGFloat = 0,
        widthConstant: CGFloat = 0,
        heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {

        translatesAutoresizingMaskIntoConstraints = false

        var anchors = [NSLayoutConstraint]()

        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }

        if let leading = leading {
            anchors.append(leadingAnchor.constraint(equalTo: leading, constant: leadingConstant))
        }

        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }

        if let trailing = trailing {
            anchors.append(trailingAnchor.constraint(equalTo: trailing, constant: -trailingConstant))
        }

        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }

        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }

        anchors.forEach { $0.isActive = true }

        return anchors
    }
    
    /// Anchor center X into current view's superview with a constant margin value.
    ///
    /// - Parameter constant: constant of the anchor constraint (default is 0).
    func anchorCenterXToSuperview(constant: CGFloat = 0) {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }

    /// Anchor center Y into current view's superview with a constant margin value.
    ///
    /// - Parameter withConstant: constant of the anchor constraint (default is 0).
    func anchorCenterYToSuperview(constant: CGFloat = 0) {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }

    /**
     Applies a gradient to the UIView.

     - Parameters:
        - colours: An array of UIColor objects representing the colors of the gradient.
        - locations: An optional array of NSNumber objects representing the locations of each color in the gradient. If not provided, the colors will be evenly distributed.
        - startPoint: The starting point of the gradient. Defaults to CGPoint(x: 0.5, y: 0.0).
        - endPoint: The ending point of the gradient. Defaults to CGPoint(x: 0.5, y: 1.0).
     */
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        self.layer.insertSublayer(gradient, at: 0)
        
        return gradient
    }

    /// Applies a corner radius to the view.
    /// - Parameters:
    ///   - radius: The radius of the corners.
    ///   - corners: The corners to apply the radius to.
    func applyCornerRadius(radius: CGFloat, corners: CACornerMask) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    /// Applies a dotted border to the view.
    /// - Parameters:
    ///   - color: The color of the border. Default is white.
    ///   - radius: The radius of the corners. Default is 0.
    ///   - lineDashPattern: The line dash pattern for the border. Default is [8, 8].
    func applyDottedBorder(with color: UIColor? = .white, radius: CGFloat = 0, lineDashPattern: [NSNumber]? = [8, 8]) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color?.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.frame = bounds
        shapeLayer.fillColor = nil
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        shapeLayer.path = path.cgPath
        
        layer.addSublayer(shapeLayer)
    }
}

public extension UIView {
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

public extension UIView {
    func removeGradientLayer() {
        if let layer = layer.sublayers?.first as? CAGradientLayer {
            layer.removeFromSuperlayer()
        }
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
          let path = UIBezierPath(roundedRect: self.bounds,
                                  byRoundingCorners: corners,
                                  cornerRadii: CGSize(width: radius, height: radius))
          let mask = CAShapeLayer()
          mask.path = path.cgPath
          self.layer.mask = mask
      }
}

public enum CAGradientPoint {
    case topLeft
    case centerLeft
    case bottomLeft
    case topCenter
    case center
    case bottomCenter
    case topRight
    case centerRight
    case bottomRight
    
    public var point: CGPoint {
        switch self {
        case .topLeft:
            return CGPoint(x: 0, y: 0)
        case .centerLeft:
            return CGPoint(x: 0, y: 0.5)
        case .bottomLeft:
            return CGPoint(x: 0, y: 1.0)
        case .topCenter:
            return CGPoint(x: 0.5, y: 0)
        case .center:
            return CGPoint(x: 0.5, y: 0.5)
        case .bottomCenter:
            return CGPoint(x: 0.5, y: 1.0)
        case .topRight:
            return CGPoint(x: 1.0, y: 0.0)
        case .centerRight:
            return CGPoint(x: 1.0, y: 0.5)
        case .bottomRight:
            return CGPoint(x: 1.0, y: 1.0)
        }
    }
   
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
extension UIView{ 
static func instantiateFromNib() -> Self {
    return instantiateFromNibHelper()
}

/// Helper method to handle instantiation and type casting.
private static func instantiateFromNibHelper<T>() -> T where T: UIView {
    let nibName = String(describing: self)
    guard let nib = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil),
          let view = nib.first as? T else {
        fatalError("Error: No nib with name \(nibName) found.")
    }
    return view
}}

extension UIView {
    
    func applyDropShadow(color: UIColor = UIColor.black.withAlphaComponent(0.1),
                            opacity: Float = 1.0,
                            offset: CGSize = CGSize(width: 4, height: 4),
                            radius: CGFloat = 15,
                            shouldRasterize: Bool = false) {
           self.layer.shadowColor = color.cgColor
           self.layer.shadowOpacity = opacity
           self.layer.shadowOffset = offset
           self.layer.shadowRadius = radius
           self.layer.masksToBounds = false // Ensures the shadow is not clipped
           self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath // Creates a shadow path based on the view's bounds
           
           // Optional: Improve performance by rasterizing the shadow
           self.layer.shouldRasterize = shouldRasterize
           self.layer.rasterizationScale = shouldRasterize ? UIScreen.main.scale : 1
       }
    }



import UIKit

@IBDesignable
class CustomShadowVieww: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyDropShadow()
    }

    private func setupView() {
        // Optional: Set background color if not set in XIB
        if self.backgroundColor == nil {
            self.backgroundColor = .white
        }
    }

    func applyDropShadow(color: UIColor = UIColor.black.withAlphaComponent(0.1),
                         opacity: Float = 1.0,
                         offset: CGSize = CGSize(width: 4, height: 4),
                         radius: CGFloat = 15) {
        // Apply drop shadow properties
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        
        // Set the shadow path based on the view’s bounds
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
}
extension UIView {
    func addXibSubview(named xibName: String) {
        guard let xibView = bundle.loadNibNamed(xibName, owner: self, options: nil)?.first as? UIView else {
            fatalError("Failed to load XIB named \(xibName)")
        }
        
        xibView.frame = bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(xibView)
    }
}
extension UIView{
    func addLowerDropShadow() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor // #0000001A
        self.layer.shadowOpacity = 1.0 // Full opacity as it's included in the color
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowRadius = 15 // Half of 30px for a more natural look
        self.layer.masksToBounds = false
        
        // Create a shadow path that extends beyond the view's bounds
        let shadowPath = UIBezierPath(rect: self.bounds.insetBy(dx: -15, dy: -15).offsetBy(dx: 0, dy: 15))
        self.layer.shadowPath = shadowPath.cgPath
    }
}
extension UIView {
    func animate(isHidden: Bool, duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 0
            }, completion: { finished in
                self.isHidden = true
                completion?(finished)
            })
        } else {
            self.alpha = 0
            self.isHidden = false
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 1
            }, completion: completion)
        }
    }
    
}
extension UIView {
    func customCircularView() {
        self.layer.cornerRadius = min(self.frame.width, self.frame.height) / 2
        self.layer.masksToBounds = true
    }
}
