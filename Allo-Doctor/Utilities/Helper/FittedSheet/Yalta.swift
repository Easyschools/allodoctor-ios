// The MIT License (MIT)
//
// Copyright (c) 2017-2018 Alexander Grebenyuk (github.com/kean).
//
// August 2018 version, to update copy all code from https://raw.githubusercontent.com/kean/Yalta/master/Sources/Yalta.swift (leaving this header instead of the updated one)
// Make sure to remove all `public` from this class so we don't cause issues with anyone using this library in their own code already

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit

protocol FWIPNLayoutItem { // `UIView`, `UILayoutGuide`
    var superview: UIView? { get }
}

extension UIView: FWIPNLayoutItem {}
extension UILayoutGuide: FWIPNLayoutItem {
    var superview: UIView? { return self.owningView }
}

extension FWIPNLayoutItem { // Yalta methods available via `FWIPNLayoutProxy`
    @nonobjc var al: FWIPNLayoutProxy<Self> { return FWIPNLayoutProxy(base: self) }
}

// MARK: - FWIPNLayoutProxy

struct FWIPNLayoutProxy<Base> {
    let base: Base
}

extension FWIPNLayoutProxy where Base: FWIPNLayoutItem {
    
    // MARK: FWIPNAnchors
    
    var top: FWIPNAnchor<FWIPNAnchorType.Edge, FWIPNAnchorAxis.Vertical> { return FWIPNAnchor(base, .top) }
    var bottom: FWIPNAnchor<FWIPNAnchorType.Edge, FWIPNAnchorAxis.Vertical> { return FWIPNAnchor(base, .bottom) }
    var left: FWIPNAnchor<FWIPNAnchorType.Edge, FWIPNAnchorAxis.Horizontal> { return FWIPNAnchor(base, .left) }
    var right: FWIPNAnchor<FWIPNAnchorType.Edge, FWIPNAnchorAxis.Horizontal> { return FWIPNAnchor(base, .right) }
    var leading: FWIPNAnchor<FWIPNAnchorType.Edge, FWIPNAnchorAxis.Horizontal> { return FWIPNAnchor(base, .leading) }
    var trailing: FWIPNAnchor<FWIPNAnchorType.Edge, FWIPNAnchorAxis.Horizontal> { return FWIPNAnchor(base, .trailing) }
    
    var centerX: FWIPNAnchor<FWIPNAnchorType.Center, FWIPNAnchorAxis.Horizontal> { return FWIPNAnchor(base, .centerX) }
    var centerY: FWIPNAnchor<FWIPNAnchorType.Center, FWIPNAnchorAxis.Vertical> { return FWIPNAnchor(base, .centerY) }
    
    var firstBaseline: FWIPNAnchor<FWIPNAnchorType.Baseline, FWIPNAnchorAxis.Vertical> { return FWIPNAnchor(base, .firstBaseline) }
    var lastBaseline: FWIPNAnchor<FWIPNAnchorType.Baseline, FWIPNAnchorAxis.Vertical> { return FWIPNAnchor(base, .lastBaseline) }
    
    var width: FWIPNAnchor<FWIPNAnchorType.Dimension, FWIPNAnchorAxis.Horizontal> { return FWIPNAnchor(base, .width) }
    var height: FWIPNAnchor<FWIPNAnchorType.Dimension, FWIPNAnchorAxis.Vertical> { return FWIPNAnchor(base, .height) }
    
    // MARK: FWIPNAnchor Collections
    
    func edges(_ edges: FWIPNLayoutEdge...) -> FWIPNAnchorCollectionEdges { return FWIPNAnchorCollectionEdges(item: base, edges: edges) }
    var edges: FWIPNAnchorCollectionEdges { return FWIPNAnchorCollectionEdges(item: base, edges: [.left, .right, .bottom, .top]) }
    var center: FWIPNAnchorCollectionCenter { return FWIPNAnchorCollectionCenter(x: centerX, y: centerY) }
    var size: FWIPNAnchorCollectionSize { return FWIPNAnchorCollectionSize(width: width, height: height) }
}

extension FWIPNLayoutProxy where Base: UIView {
    var margins: FWIPNLayoutProxy<UILayoutGuide> { return base.layoutMarginsGuide.al }
    
    @available(iOS 11.0, tvOS 11.0, *)
    var safeArea: FWIPNLayoutProxy<UILayoutGuide> { return base.safeAreaLayoutGuide.al }
}

// MARK: - FWIPNAnchors

// phantom types
enum FWIPNAnchorAxis {
    class Horizontal {}
    class Vertical {}
}

enum FWIPNAnchorType {
    class Dimension {}
    /// Includes `center`, `edge` and `baselines` FWIPNAnchors.
    class Alignment {}
    class Center: Alignment {}
    class Edge: Alignment {}
    class Baseline: Alignment {}
}

/// An FWIPNAnchor represents one of the view's layout attributes (e.g. `left`,
/// `centerX`, `width`, etc). Use the FWIPNAnchor’s methods to construct FWIPNConstraints.
struct FWIPNAnchor<Type, Axis> { // type and axis are phantom types
    internal let item: FWIPNLayoutItem
    internal let attribute: NSLayoutConstraint.Attribute
    internal let offset: CGFloat
    internal let multiplier: CGFloat
    
    init(_ item: FWIPNLayoutItem, _ attribute: NSLayoutConstraint.Attribute, offset: CGFloat = 0, multiplier: CGFloat = 1) {
        self.item = item; self.attribute = attribute; self.offset = offset; self.multiplier = multiplier
    }
    
    /// Returns a new FWIPNAnchor offset by a given amount.
    internal func offsetting(by offset: CGFloat) -> FWIPNAnchor<Type, Axis> {
        return FWIPNAnchor<Type, Axis>(item, attribute, offset: self.offset + offset, multiplier: self.multiplier)
    }
    
    /// Returns a new FWIPNAnchor with a given multiplier.
    internal func multiplied(by multiplier: CGFloat) -> FWIPNAnchor<Type, Axis> {
        return FWIPNAnchor<Type, Axis>(item, attribute, offset: self.offset * multiplier, multiplier: self.multiplier * multiplier)
    }
}

func + <Type, Axis>(FWIPNAnchor: FWIPNAnchor<Type, Axis>, offset: CGFloat) -> FWIPNAnchor<Type, Axis> {
    return FWIPNAnchor.offsetting(by: offset)
}

func - <Type, Axis>(FWIPNAnchor: FWIPNAnchor<Type, Axis>, offset: CGFloat) -> FWIPNAnchor<Type, Axis> {
    return FWIPNAnchor.offsetting(by: -offset)
}

func * <Type, Axis>(FWIPNAnchor: FWIPNAnchor<Type, Axis>, multiplier: CGFloat) -> FWIPNAnchor<Type, Axis> {
    return FWIPNAnchor.multiplied(by: multiplier)
}

// MARK: - FWIPNAnchors (FWIPNAnchorType.Alignment)

extension FWIPNAnchor where Type: FWIPNAnchorType.Alignment {
    /// Aligns two FWIPNAnchors.
    @discardableResult func align<Type: FWIPNAnchorType.Alignment>(with FWIPNAnchor: FWIPNAnchor<Type, Axis>, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return FWIPNConstraints.constrain(self, FWIPNAnchor, relation: relation)
    }
}

// MARK: - FWIPNAnchors (FWIPNAnchorType.Edge)

extension FWIPNAnchor where Type: FWIPNAnchorType.Edge {
    /// Pins the edge to the same edge of the superview.
    @discardableResult func pinToSuperview(inset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return _pin(to: item.superview!, attribute: attribute, inset: inset, relation: relation)
    }
    
    /// Pins the edge to the respected margin of the superview.
    @discardableResult func pinToSuperviewMargin(inset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return _pin(to: item.superview!, attribute: attribute.toMargin, inset: inset, relation: relation)
    }
    
    /// Pins the edge to the respected edges of the given container.
    @discardableResult func pin(to container: FWIPNLayoutItem, inset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return _pin(to: container, attribute: attribute, inset: inset, relation: relation)
    }
    
    /// Pins the edge to the safe area of the view controller. Falls back to
    /// layout guides (`.topLayoutGuide` and `.bottomLayoutGuide` on iOS 10.
    @discardableResult func pinToSafeArea(of vc: UIViewController, inset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let item2: Any, attr2: NSLayoutConstraint.Attribute
        if #available(iOS 11, tvOS 11, *) {
            // Pin to `safeAreaLayoutGuide` on iOS 11
            (item2, attr2) = (vc.view.safeAreaLayoutGuide, self.attribute)
        } else {
            switch self.attribute {
            // Fall back to .topLayoutGuide and pin to it's .bottom.
            case .top: (item2, attr2) = (vc.topLayoutGuide, .bottom)
            // Fall back to .bottomLayoutGuide and pin to it's .top.
            case .bottom: (item2, attr2) = (vc.bottomLayoutGuide, .top)
                // There are no layout guides for .left and .right, so just pin
            // to the superview instead.
            default: (item2, attr2) = (vc.view!, self.attribute)
            }
        }
        return _pin(to: item2, attribute: attr2, inset: inset, relation: relation)
    }
    
    // Pin the FWIPNAnchor to another layout item.
    private func _pin(to item2: Any, attribute attr2: NSLayoutConstraint.Attribute, inset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        // Invert attribute and relation in certain cases. The `pin` semantics
        // are inspired by https://github.com/PureLayout/PureLayout
        let isInverted = [.trailing, .right, .bottom].contains(attribute)
        return FWIPNConstraints.constrain(self, toItem: item2, attribute: attr2, offset: (isInverted ? -inset : inset), relation: (isInverted ? relation.inverted : relation))
    }
}

// MARK: - FWIPNAnchors (FWIPNAnchorType.Center)

extension FWIPNAnchor where Type: FWIPNAnchorType.Center {
    /// Aligns the axis with a superview axis.
    @discardableResult func alignWithSuperview(offset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return align(with: FWIPNAnchor<Type, Axis>(self.item.superview!, self.attribute) + offset, relation: relation)
    }
}

// MARK: - FWIPNAnchors (FWIPNAnchorType.Dimension)

extension FWIPNAnchor where Type: FWIPNAnchorType.Dimension {
    /// Sets the dimension to a specific size.
    @discardableResult func set(_ constant: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return FWIPNConstraints.constrain(item: item, attribute: attribute, relatedBy: relation, constant: constant)
    }
    
    @discardableResult func match<Axis>(_ FWIPNAnchor: FWIPNAnchor<FWIPNAnchorType.Dimension, Axis>, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return FWIPNConstraints.constrain(self, FWIPNAnchor, relation: relation)
    }
}

// MARK: - FWIPNAnchorCollectionEdges

struct FWIPNAnchorCollectionEdges {
    internal let item: FWIPNLayoutItem
    internal let edges: [FWIPNLayoutEdge]
    private var FWIPNAnchors: [FWIPNAnchor<FWIPNAnchorType.Edge, Any>] { return edges.map { FWIPNAnchor(item, $0.attribute) } }
    
    /// Pins the edges of the view to the edges of the superview so the the view
    /// fills the available space in a container.
    @discardableResult func pinToSuperview(insets: UIEdgeInsets = .zero, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        return FWIPNAnchors.map { $0.pinToSuperview(inset: insets.inset(for: $0.attribute), relation: relation) }
    }
    
    /// Pins the edges of the view to the margins of the superview so the the view
    /// fills the available space in a container.
    @discardableResult func pinToSuperviewMargins(insets: UIEdgeInsets = .zero, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        return FWIPNAnchors.map { $0.pinToSuperviewMargin(inset: insets.inset(for: $0.attribute), relation: relation) }
    }
    
    /// Pins the edges of the view to the edges of the given view so the the
    /// view fills the available space in a container.
    @discardableResult func pin(to item2: FWIPNLayoutItem, insets: UIEdgeInsets = .zero, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        return FWIPNAnchors.map { $0.pin(to: item2, inset: insets.inset(for: $0.attribute), relation: relation) }
    }
    
    /// Pins the edges to the safe area of the view controller.
    /// Falls back to layout guides on iOS 10.
    @discardableResult func pinToSafeArea(of vc: UIViewController, insets: UIEdgeInsets = .zero, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        return FWIPNAnchors.map { $0.pinToSafeArea(of: vc, inset: insets.inset(for: $0.attribute), relation: relation) }
    }
}

// MARK: - FWIPNAnchorCollectionCenter

struct FWIPNAnchorCollectionCenter {
    internal let x: FWIPNAnchor<FWIPNAnchorType.Center, FWIPNAnchorAxis.Horizontal>
    internal let y: FWIPNAnchor<FWIPNAnchorType.Center, FWIPNAnchorAxis.Vertical>
    
    /// Centers the view in the superview.
    @discardableResult func alignWithSuperview() -> [NSLayoutConstraint] {
        return [x.alignWithSuperview(), y.alignWithSuperview()]
    }
    
    /// Makes the axis equal to the other collection of axis.
    @discardableResult func align(with FWIPNAnchors: FWIPNAnchorCollectionCenter) -> [NSLayoutConstraint] {
        return [x.align(with: FWIPNAnchors.x), y.align(with: FWIPNAnchors.y)]
    }
}


// MARK: - FWIPNAnchorCollectionSize

struct FWIPNAnchorCollectionSize {
    internal let width: FWIPNAnchor<FWIPNAnchorType.Dimension, FWIPNAnchorAxis.Horizontal>
    internal let height: FWIPNAnchor<FWIPNAnchorType.Dimension, FWIPNAnchorAxis.Vertical>
    
    /// Set the size of item.
    @discardableResult func set(_ size: CGSize, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        return [width.set(size.width, relation: relation), height.set(size.height, relation: relation)]
    }
    
    /// Makes the size of the item equal to the size of the other item.
    @discardableResult func match(_ FWIPNAnchors: FWIPNAnchorCollectionSize, insets: CGSize = .zero, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        return [width.match(FWIPNAnchors.width * multiplier - insets.width, relation: relation),
                height.match(FWIPNAnchors.height * multiplier - insets.height, relation: relation)]
    }
}

// MARK: - FWIPNConstraints

final class FWIPNConstraints {
    var constraints = [NSLayoutConstraint]()
    
    /// All of the FWIPNConstraints created in the given closure are automatically
    /// activated at the same time. This is more efficient then installing them
    /// one-be-one. More importantly, it allows to make changes to the FWIPNConstraints
    /// before they are installed (e.g. change `priority`).
    @discardableResult init(_ closure: () -> Void) {
        FWIPNConstraints._stack.append(self)
        closure() // create FWIPNConstraints
        FWIPNConstraints._stack.removeLast()
        NSLayoutConstraint.activate(constraints)
    }
    
    /// Creates and automatically installs a constraint.
    internal static func constrain(item item1: Any, attribute attr1: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation = .equal, toItem item2: Any? = nil, attribute attr2: NSLayoutConstraint.Attribute? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        precondition(Thread.isMainThread, "Yalta APIs can only be used from the main thread")
        (item1 as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: item1, attribute: attr1, relatedBy: relation, toItem: item2, attribute: attr2 ?? .notAnAttribute, multiplier: multiplier, constant: constant)
        _install(constraint)
        return constraint
    }
    
    /// Creates and automatically installs a constraint between two FWIPNAnchors.
    internal static func constrain<T1, A1, T2, A2>(_ lhs: FWIPNAnchor<T1, A1>, _ rhs: FWIPNAnchor<T2, A2>, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return constrain(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: rhs.item, attribute: rhs.attribute, multiplier: (multiplier / lhs.multiplier) * rhs.multiplier, constant: offset - lhs.offset + rhs.offset)
    }
    
    /// Creates and automatically installs a constraint between an FWIPNAnchor and
    /// a given item.
    internal static func constrain<T1, A1>(_ lhs: FWIPNAnchor<T1, A1>, toItem item2: Any?, attribute attr2: NSLayoutConstraint.Attribute?, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return constrain(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: item2, attribute: attr2, multiplier: multiplier / lhs.multiplier, constant: offset - lhs.offset)
    }
    
    private static var _stack = [FWIPNConstraints]() // this is what enabled constraint auto-installing
    
    private static func _install(_ constraint: NSLayoutConstraint) {
        if _stack.isEmpty { // not creating a group of FWIPNConstraints
            constraint.isActive = true
        } else { // remember which constaints to install when group is completed
            let group = _stack.last!
            group.constraints.append(constraint)
        }
    }
}

// MARK: - UIView + FWIPNConstraints

extension UIView {
    @discardableResult @nonobjc func addSubview(_ a: UIView, constraints: (FWIPNLayoutProxy<UIView>) -> Void) -> FWIPNConstraints {
        addSubview(a)
        return FWIPNConstraints(for: a, constraints)
    }
    
    @discardableResult @nonobjc func addSubview(_ a: UIView, _ b: UIView, constraints: (FWIPNLayoutProxy<UIView>, FWIPNLayoutProxy<UIView>) -> Void) -> FWIPNConstraints {
        [a, b].forEach { addSubview($0) }
        return FWIPNConstraints(for: a, b, constraints)
    }
    
    @discardableResult @nonobjc func addSubview(_ a: UIView, _ b: UIView, _ c: UIView, constraints: (FWIPNLayoutProxy<UIView>, FWIPNLayoutProxy<UIView>, FWIPNLayoutProxy<UIView>) -> Void) -> FWIPNConstraints {
        [a, b, c].forEach { addSubview($0) }
        return FWIPNConstraints(for: a, b, c, constraints)
    }
    
    @discardableResult @nonobjc func addSubview(_ a: UIView, _ b: UIView, _ c: UIView, _ d: UIView, constraints: (FWIPNLayoutProxy<UIView>, FWIPNLayoutProxy<UIView>, FWIPNLayoutProxy<UIView>, FWIPNLayoutProxy<UIView>) -> Void) -> FWIPNConstraints {
        [a, b, c, d].forEach { addSubview($0) }
        return FWIPNConstraints(for: a, b, c, d, constraints)
    }
}

// MARK: - FWIPNConstraints (Arity)

extension FWIPNConstraints {
    @discardableResult convenience init<A: FWIPNLayoutItem>(for a: A, _ closure: (FWIPNLayoutProxy<A>) -> Void) {
        self.init { closure(a.al) }
    }
    
    @discardableResult convenience init<A: FWIPNLayoutItem, B: FWIPNLayoutItem>(for a: A, _ b: B, _ closure: (FWIPNLayoutProxy<A>, FWIPNLayoutProxy<B>) -> Void) {
        self.init { closure(a.al, b.al) }
    }
    
    @discardableResult convenience init<A: FWIPNLayoutItem, B: FWIPNLayoutItem, C: FWIPNLayoutItem>(for a: A, _ b: B, _ c: C, _ closure: (FWIPNLayoutProxy<A>, FWIPNLayoutProxy<B>, FWIPNLayoutProxy<C>) -> Void) {
        self.init { closure(a.al, b.al, c.al) }
    }
    
    @discardableResult convenience init<A: FWIPNLayoutItem, B: FWIPNLayoutItem, C: FWIPNLayoutItem, D: FWIPNLayoutItem>(for a: A, _ b: B, _ c: C, _ d: D, _ closure: (FWIPNLayoutProxy<A>, FWIPNLayoutProxy<B>, FWIPNLayoutProxy<C>, FWIPNLayoutProxy<D>) -> Void) {
        self.init { closure(a.al, b.al, c.al, d.al) }
    }
}

// MARK: - Misc

enum FWIPNLayoutEdge {
    case top, bottom, leading, trailing, left, right
    
    internal var attribute: NSLayoutConstraint.Attribute {
        switch self {
        case .top: return .top;          case .bottom: return .bottom
        case .leading: return .leading;  case .trailing: return .trailing
        case .left: return .left;        case .right: return .right
        }
    }
}

internal extension NSLayoutConstraint.Attribute {
    var toMargin: NSLayoutConstraint.Attribute {
        switch self {
        case .top: return .topMargin;           case .bottom: return .bottomMargin
        case .leading: return .leadingMargin;   case .trailing: return .trailingMargin
        case .left: return .leftMargin          case .right: return .rightMargin
        default: return self
        }
    }
}

internal extension NSLayoutConstraint.Relation {
    var inverted: NSLayoutConstraint.Relation {
        switch self {
        case .greaterThanOrEqual: return .lessThanOrEqual
        case .lessThanOrEqual: return .greaterThanOrEqual
        case .equal: return self
        @unknown default:
            return self
        }
    }
}

internal extension UIEdgeInsets {
    func inset(for attribute: NSLayoutConstraint.Attribute) -> CGFloat {
        switch attribute {
        case .top: return top; case .bottom: return bottom
        case .left, .leading: return left
        case .right, .trailing: return right
        default: return 0
        }
    }
}

// MARK: - Deprecated

extension FWIPNAnchor where Type: FWIPNAnchorType.Alignment {
    @available(*, deprecated, message: "Please use operators instead, e.g. `view.top.align(with: view.bottom * 2 + 10)`.")
    @discardableResult func align<Type: FWIPNAnchorType.Alignment>(with FWIPNAnchor: FWIPNAnchor<Type, Axis>, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return FWIPNConstraints.constrain(self, FWIPNAnchor, offset: offset, multiplier: multiplier, relation: relation)
    }
}

extension FWIPNAnchor where Type: FWIPNAnchorType.Dimension {
    @available(*, deprecated, message: "Please use operators instead, e.g. `view.width.match(view.height * 2 + 10)`.")
    @discardableResult func match<Axis>(_ FWIPNAnchor: FWIPNAnchor<FWIPNAnchorType.Dimension, Axis>, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return FWIPNConstraints.constrain(self, FWIPNAnchor, offset: offset, multiplier: multiplier, relation: relation)
    }
}

#endif // os(iOS) || os(tvOS) || os(watchOS)
