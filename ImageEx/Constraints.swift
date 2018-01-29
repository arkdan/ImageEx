//
//  Constraints.swift
//  UIKitExtensions
//
//  Created by ark dan on 11/16/16.
//  Copyright © 2016 arkdan. All rights reserved.
//

import UIKit


extension UIView {

    @discardableResult
    public func constraint(_ attributes: NSLayoutAttribute..., subview: UIView, _ constant: CGFloat = 0) -> [NSLayoutConstraint] {

        assert(subview.superview === self)
        subview.translatesAutoresizingMaskIntoConstraints = false

        var added = [NSLayoutConstraint]()

        for attribute in attributes {
            let off: CGFloat
            switch attribute {
            case .top, .leading, .centerX, .centerY, .width, .height:
                off = constant
            case .bottom, .trailing:
                off = -constant
            default:
                fatalError("attribute \(attribute) not supported")
            }

            let c = NSLayoutConstraint(item: subview,
                                       attribute: attribute,
                                       relatedBy: .equal,
                                       toItem: self,
                                       attribute: attribute,
                                       multiplier: 1,
                                       constant: off)
            c.isActive = true
            added.append(c)
        }
        return added
    }

    @discardableResult
    public func constraint(_ attribute: NSLayoutAttribute, _ constant: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false

        switch attribute {
        case .width, .height:
            break
        default:
            fatalError("pass .width or .height only")
        }
        let c = NSLayoutConstraint(item: self,
                                   attribute: attribute,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   multiplier: 1,
                                   constant: constant)
        c.isActive = true
        return c
    }

    @discardableResult
    public func constraint(_ attribute: NSLayoutAttribute, to siblingAttribute: NSLayoutAttribute, ofSibling sibling: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {

        assert(superview === sibling.superview, "siblings must have same superview!")
        translatesAutoresizingMaskIntoConstraints = false
        sibling.translatesAutoresizingMaskIntoConstraints = false

        let off: CGFloat
        switch attribute {
        case .bottom, .trailing, .right:
            off = -constant
        default:
            off = constant
        }

        let c = NSLayoutConstraint(item: self,
                                   attribute: attribute,
                                   relatedBy: .equal,
                                   toItem: sibling,
                                   attribute: siblingAttribute,
                                   multiplier: 1,
                                   constant: off)
        c.isActive = true
        return c
    }
}

extension UIView {

    var widthConstraint: NSLayoutConstraint? {
        return constraints.first { $0.firstItem as! NSLayoutConstraint == self }
    }

    @discardableResult
    public func constraint(size: (CGFloatConvertible, CGFloatConvertible)) -> [NSLayoutConstraint] {
        return constraint(size: CGSize(width: size.0.cgFloat, height: size.1.cgFloat))
    }

    @discardableResult
    public func constraint(size: CGSize) -> [NSLayoutConstraint] {
        return [constraint(.width, size.width), constraint(.height, size.height)]
    }
}


extension UIView {
    public func clearConstraints() {
        NSLayoutConstraint.deactivate(associatedConstraints())
    }

    public func associatedConstraints() -> [NSLayoutConstraint] {
        var constraints = self.constraints
        var superview = self.superview
        while let sv = superview {
            for constraint in sv.constraints {
                if constraint.firstItem === self || constraint.secondItem === self {
                    constraints.append(constraint)
                }
            }
            superview = sv.superview
        }
        return constraints
    }
}

extension UIView {
    public func pin(subview: UIView) {
        constraint(.top, .bottom, .leading, .trailing, subview: subview)
    }
}

public protocol CGFloatConvertible {
    var cgFloat: CGFloat { get }
}

extension Double: CGFloatConvertible {
    public var cgFloat: CGFloat { return CGFloat(self) }
}
extension Int: CGFloatConvertible {
    public var cgFloat: CGFloat { return CGFloat(self) }
}
extension UInt: CGFloatConvertible {
    public var cgFloat: CGFloat { return CGFloat(self) }
}
extension CGFloat: CGFloatConvertible {
    public var cgFloat: CGFloat { return self }
}

extension CGSize {

    public init(_ w: CGFloatConvertible, _ h: CGFloatConvertible) {
        self.init(width: w.cgFloat, height: h.cgFloat)
    }

    public mutating func scale(x: CGFloatConvertible, y: CGFloatConvertible) {
        width *= x.cgFloat
        height *= y.cgFloat
    }

    public func scaled(x: CGFloatConvertible, y: CGFloatConvertible) -> CGSize {
        var copy = self
        copy.scale(x: x, y: y)
        return copy
    }

    public func scaleFactorAspectFit(in target: CGSize) -> CGFloat {
        // try to match width
        let scale = target.width / self.width;
        // if we scale the height to make the widths equal, does it still fit?
        if height * scale <= target.height {
            return scale
        }
        // no, match height instead
        return target.height / height
    }

    public func scaledAspectFit(in target: CGSize) -> CGSize {
        let scale = scaleFactorAspectFit(in: target)
        let w = width * scale
        let h = height * scale
        return CGSize(width: w, height: h)
    }

    public static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    public static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
}

extension CGPoint {
    public static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
