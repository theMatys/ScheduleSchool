//
//  SSSystemExtensions.swift
//  Schedule School
//
//  Created by Máté on 2017. 11. 11.
//  Copyright © 2017. theMatys. All rights reserved.
//

import UIKit

// MARK: Arithmetic operators
infix operator ^^ : MultiplicationPrecedence

// MARK: Transform operators
infix operator >-< : AdditionPrecedence
infix operator <+> : AdditionPrecedence
infix operator <-> : AdditionPrecedence
infix operator <*> : MultiplicationPrecedence

// MARK: Comparison operators
infix operator <?> : ComparisonPrecedence

// MARK: Assignment operators
postfix operator =!

// MARK: -
extension Bool
{
    /// Inverts the value of the left-hand-side boolean.
    ///
    /// - Parameter lhs: The boolean whose value should be inverted.
    static postfix func =!(lhs: inout Bool)
    {
        lhs = !lhs
    }
}

// MARK: -
extension Array where Element: SSImageButton.ImageStateConfiguration
{
    /// Initializes an array of button icon configurations with configurations for the given states.
    ///
    /// - Parameter controlStates: The control states for which configurations should be added to the array after the initialization.
    init(for controlStates: UIControlState...)
    {
        self.init()
        
        // Iterate through the elements of the pre-defined control states and add a configuration for each of them
        for controlState in controlStates
        {
            append(SSImageButton.ImageStateConfiguration(for: controlState) as! Element)
        }
    }
    
    /// Returns the first element in the array which is bound to the specified control state.
    ///
    /// If there are no elements in the array bound to the given control state, the subscript will create a configuration for the given state and append it to the array.
    ///
    /// - Parameter controlState: The control state which the element should be bound to.
    /// - Returns: The element or a new configuration instance which is bound to the given control state.
    subscript(controlState: UIControlState) -> SSImageButton.ImageStateConfiguration
    {
        mutating get
        {
            // Create the result
            var result: SSImageButton.ImageStateConfiguration?
            
            // Look for the first element with the control state
            forEach { (iconStateConfiguration) in
                if(iconStateConfiguration.controlState == controlState)
                {
                    result = iconStateConfiguration
                }
            }
            
            if(result == nil)
            {
                result = SSImageButton.ImageStateConfiguration(for: controlState)
                append(result as! Element)
            }
            
            // Return the result
            return result!
        }
    }
}

// MARK: -
extension String
{
    /// Retrieves the size for the string with the given font, optionally constrainted within a maximum size.
    ///
    /// - Parameters:
    ///   - font: The font which should be used to retrieve the string's size.
    ///   - size: The maximum size of the string with the given font.
    /// - Returns: The size of the string with the given font.
    func size(with font: UIFont, max size: CGSize? = nil) -> CGSize
    {
        // Create an NSString out of the current one to do the calculations
        let nsString: NSString = NSString(string: self)
        
        if(size != nil)
        {
            // If there is a max size, calculate the string's size with respect to that
            return nsString.boundingRect(with: size!, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil).size
        }
        else
        {
            // If there is no max size, calculate the string's size regularly
            return nsString.size(withAttributes: [NSAttributedStringKey.font : font])
        }
    }
}

// MARK: -
extension Comparable
{
    /// Clamps the given value in between the specified bounds.
    ///
    /// - Parameters:
    ///   - lhs: The comparable which should be clamed.
    ///   - min: The minimum and maximum values of the comparable.
    /// - Returns: The new (clamped) value.
    static func <?>(lhs: Self, rhs: (min: Self?, max: Self?)) -> Self
    {
        let min: Self? = rhs.min
        let max: Self? = rhs.max
        
        if(min != nil && max != nil)
        {
            if(lhs <= max! && lhs >= min!)
            {
                return lhs
            }
            else if(lhs > max!)
            {
                return max!
            }
            else
            {
                return min!
            }
        }
        else if(min != nil)
        {
            if(lhs > min!)
            {
                return lhs
            }
            else
            {
                return min!
            }
        }
        else if(max != nil)
        {
            if(lhs < max!)
            {
                return lhs
            }
            else
            {
                return max!
            }
        }
        else
        {
            return lhs
        }
    }
}

// MARK: -
extension CGPoint
{
    /// Returns the distance of the point from the current corrdinate system's origin.
    var distance: CGSize
    {
        return CGSize(width: x, height: y)
    }
    
    static func +(lhs: CGPoint, rhs: CGFloat) -> CGPoint
    {
        return lhs + (rhs, rhs)
    }
    
    static func +(lhs: CGPoint, rhs: (horizontal: CGFloat, vertical: CGFloat)) -> CGPoint
    {
        return lhs + CGSize(width: rhs.horizontal, height: rhs.vertical)
    }
    
    static func +(lhs: CGPoint, rhs: CGSize) -> CGPoint
    {
        return CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }
    
    static func +=(lhs: inout CGPoint, rhs: CGFloat)
    {
        return lhs += (rhs, rhs)
    }
    
    static func +=(lhs: inout CGPoint, rhs: (horizontal: CGFloat, vertical: CGFloat))
    {
        return lhs += CGSize(width: rhs.horizontal, height: rhs.vertical)
    }
    
    static func +=(lhs: inout CGPoint, rhs: CGSize)
    {
        lhs.x += rhs.width
        lhs.y += rhs.height
    }
    
    static func -(lhs: CGPoint, rhs: CGFloat) -> CGPoint
    {
        return lhs - (rhs, rhs)
    }
    
    static func -(lhs: CGPoint, rhs: (horizontal: CGFloat, vertical: CGFloat)) -> CGPoint
    {
        return lhs - CGSize(width: rhs.horizontal, height: rhs.vertical)
    }
    
    static func -(lhs: CGPoint, rhs: CGSize) -> CGPoint
    {
        return CGPoint(x: lhs.x - rhs.width, y: lhs.y - rhs.height)
    }
    
    static func -=(lhs: inout CGPoint, rhs: CGFloat)
    {
        return lhs -= (rhs, rhs)
    }
    
    static func -=(lhs: inout CGPoint, rhs: (horizontal: CGFloat, vertical: CGFloat))
    {
        return lhs -= CGSize(width: rhs.horizontal, height: rhs.vertical)
    }
    
    static func -=(lhs: inout CGPoint, rhs: CGSize)
    {
        lhs.x -= rhs.width
        lhs.y -= rhs.height
    }
    
    static func >-<(lhs: CGPoint, rhs: CGPoint) -> CGSize
    {
        return CGSize(width: lhs.x - rhs.x, height: lhs.y - rhs.y)
    }
}

// MARK: -
extension CGSize
{
    /// Returns the point at the width and the height of the size with the size being the coordinate system.
    var point: CGPoint
    {
        return CGPoint(x: width, y: height)
    }
    
    /// Returns a scalar which is calculated from the average of the width and the height.
    var averageScalar: CGFloat
    {
        return (width + height) / 2
    }
    
    static prefix func -(rhs: CGSize) -> CGSize
    {
        var result: CGSize = rhs
        
        result.width = -result.width
        result.height = -result.height
        
        return result
    }

    static func +(lhs: CGSize, rhs: CGFloat) -> CGSize
    {
        return lhs + (rhs, rhs)
    }
    
    static func +(lhs: CGSize, rhs: (width: CGFloat, height: CGFloat)) -> CGSize
    {
        return lhs + CGSize(width: rhs.width, height: rhs.height)
    }
    
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize
    {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
    static func +=(lhs: inout CGSize, rhs: CGFloat)
    {
        return lhs += (rhs, rhs)
    }
    
    static func +=(lhs: inout CGSize, rhs: (width: CGFloat, height: CGFloat))
    {
        return lhs += CGSize(width: rhs.width, height: rhs.height)
    }
    
    static func +=(lhs: inout CGSize, rhs: CGSize)
    {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }
    
    static func -(lhs: CGSize, rhs: CGFloat) -> CGSize
    {
        return lhs - (rhs, rhs)
    }
    
    static func -(lhs: CGSize, rhs: (width: CGFloat, height: CGFloat)) -> CGSize
    {
        return lhs - CGSize(width: rhs.width, height: rhs.height)
    }
    
    static func -(lhs: CGFloat, rhs: CGSize) -> CGSize
    {
        return (lhs, lhs) - rhs
    }
    
    static func -(lhs: (width: CGFloat, height: CGFloat), rhs: CGSize) -> CGSize
    {
        return CGSize(width: lhs.width, height: lhs.height) - rhs
    }
    
    static func -(lhs: CGSize, rhs: CGSize) -> CGSize
    {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
    
    static func -=(lhs: inout CGSize, rhs: CGFloat)
    {
        return lhs -= (rhs, rhs)
    }
    
    static func -=(lhs: inout CGSize, rhs: (width: CGFloat, height: CGFloat))
    {
        return lhs -= CGSize(width: rhs.width, height: rhs.height)
    }
    
    static func -=(lhs: inout CGSize, rhs: CGSize)
    {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }
    
    static func *(lhs: CGSize, rhs: CGFloat) -> CGSize
    {
        return lhs * (rhs, rhs)
    }
    
    static func *(lhs: CGSize, rhs: (width: CGFloat, height: CGFloat)) -> CGSize
    {
        return lhs * CGSize(width: rhs.width, height: rhs.height)
    }
    
    static  func *(lhs: CGSize, rhs: CGSize) -> CGSize
    {
        return CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }
    
    static func *=(lhs: inout CGSize, rhs: CGFloat)
    {
        lhs *= (rhs, rhs)
    }
    
    static func *=(lhs: inout CGSize, rhs: (width: CGFloat, height: CGFloat))
    {
        lhs *= CGSize(width: rhs.width, height: rhs.height)
    }
    
    static func *=(lhs: inout CGSize, rhs: CGSize)
    {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }
    
    static func /(lhs: CGSize, rhs: CGFloat) -> CGSize
    {
        return lhs / (rhs, rhs)
    }
    
    static func /(lhs: CGSize, rhs: (width: CGFloat, height: CGFloat)) -> CGSize
    {
        return lhs / CGSize(width: rhs.width, height: rhs.height)
    }
    
    static func /(lhs: CGSize, rhs: CGSize) -> CGSize
    {
        return CGSize(width: lhs.width / rhs.width, height: lhs.height / rhs.height)
    }
    
    static func /=(lhs: inout CGSize, rhs: CGFloat)
    {
        lhs /= (rhs, rhs)
    }
    
    static func /=(lhs: inout CGSize, rhs: (width: CGFloat, height: CGFloat))
    {
        lhs /= CGSize(width: rhs.width, height: rhs.height)
    }
    
    static func /=(lhs: inout CGSize, rhs: CGSize)
    {
        lhs.width /= rhs.width
        lhs.height /= rhs.height
    }
}

// MARK: -
extension CGRect
{
    /// Returns the furthermost point of the rectangle from its origin.
    var end: CGPoint
    {
        return CGPoint(x: origin.x + width, y: origin.y + height)
    }
    
    /// Constraints the receiver so that it is just inside the given rectangle.
    ///
    /// - Parameter rect: The rectangle which should just enclose the receiver.
    /// - Returns: The receiver constrainted within the given rectangle.
    func constrainted(within rect: CGRect) -> CGRect
    {
        var result: CGRect = self
        
        if(result.end.x > rect.end.x)
        {
            // Resize the rectangle horizontally so that it is just inside the frame rectangle
            result.size.width -= result.end.x - rect.end.x
        }
        
        if(result.end.y > rect.end.y)
        {
            // Resize the rectangle vertically so that it is just inside the frame rectangle
            result.size.height -= result.end.y - rect.end.y
        }
        
        return result
    }
    
    /// Returns the rectangle with the given origin.
    ///
    /// - Parameter size: The origin of the new rectangle.
    /// - Returns: The new rectangle with the given origin.
    func with(origin: CGPoint) -> CGRect
    {
        return CGRect(origin: origin, size: size)
    }
    
    /// Returns the rectangle with the given size.
    ///
    /// - Parameter size: The size of the new rectangle.
    /// - Returns: The new rectangle with the given size.
    func with(size: CGSize) -> CGRect
    {
        return CGRect(origin: origin, size: size)
    }
    
    static func +(lhs: CGRect, rhs: CGFloat) -> CGRect
    {
        return lhs + (rhs, rhs)
    }
    
    static func +(lhs: CGRect, rhs: (width: CGFloat, height: CGFloat)) -> CGRect
    {
        return lhs + CGSize(width: rhs.width, height: rhs.height)
    }
    
    static func +(lhs: CGRect, rhs: CGSize) -> CGRect
    {
        return lhs.offsetBy(dx: rhs.width, dy: rhs.height)
    }
    
    static func +=(lhs: inout CGRect, rhs: CGFloat)
    {
        return lhs += (rhs, rhs)
    }
    
    static func +=(lhs: inout CGRect, rhs: (width: CGFloat, height: CGFloat))
    {
        return lhs += CGSize(width: rhs.width, height: rhs.height)
    }
    
    static func +=(lhs: inout CGRect, rhs: CGSize)
    {
        lhs.origin.x += rhs.width
        lhs.origin.y += rhs.height
    }
    
    static func -(lhs: CGRect, rhs: CGFloat) -> CGRect
    {
        return lhs - (rhs, rhs)
    }
    
    static func -(lhs: CGRect, rhs: (width: CGFloat, height: CGFloat)) -> CGRect
    {
        return lhs - CGSize(width: rhs.width, height: rhs.height)
    }
    
    static func -(lhs: CGRect, rhs: CGSize) -> CGRect
    {
        return lhs.offsetBy(dx: -rhs.width, dy: -rhs.height)
    }
    
    static func -=(lhs: inout CGRect, rhs: CGFloat)
    {
        return lhs -= (rhs, rhs)
    }
    
    static func -=(lhs: inout CGRect, rhs: (width: CGFloat, height: CGFloat))
    {
        return lhs -= CGSize(width: rhs.width, height: rhs.height)
    }
    
    static func -=(lhs: inout CGRect, rhs: CGSize)
    {
        lhs.origin.x -= rhs.width
        lhs.origin.y -= rhs.height
    }
    
    static func <+>(lhs: CGRect, rhs: (size: CGSize, keepsCenter: Bool)) -> CGRect
    {
        return CGRect(origin: rhs.keepsCenter ? lhs.origin + rhs.size / 2 : lhs.origin, size: lhs.size + rhs.size)
    }
    
    static func <->(lhs: CGRect, rhs: (size: CGSize, keepsCenter: Bool)) -> CGRect
    {
        return CGRect(origin: rhs.keepsCenter ? lhs.origin - rhs.size / 2 : lhs.origin, size: lhs.size - rhs.size)
    }
    
    static func <*>(lhs: CGRect, rhs: (multiplier: CGFloat, keepsCenter: Bool)) -> CGRect
    {
        return CGRect(origin: rhs.keepsCenter ? rhs.multiplier < 1.0 ? lhs.origin + ((lhs.size * rhs.multiplier) / 2) : lhs.origin - ((lhs.size * rhs.multiplier) / 2) : lhs.origin, size: lhs.size * rhs.multiplier)
    }
}

// MARK: -
extension CALayer
{
    /// Executes a set of actions on all sublayers of the current layer.
    ///
    /// - Parameter execution: The execution which should be performed on all sublayers of the current layer.
    func onAllSublayers(_ execution: (CALayer) -> ())
    {
        execution(self)
        
        if(sublayers != nil)
        {
            for sublayer in sublayers!
            {
                sublayer.onAllSublayers(execution)
            }
        }
    }
    
    /// Resizes the layer and autoresizes its sublayers.
    ///
    /// - Parameter size: The new size of the layer.
    func resizeWithAutoresize(_ size: CGSize)
    {
        let oldSize: CGSize = bounds.size
        let multiplier: CGSize = size / oldSize
        
        onAllSublayers { (sublayer: CALayer) in
            sublayer.bounds.size *= multiplier
            sublayer.position = (sublayer.position.distance * multiplier).point
            
            if(sublayer is CATextLayer)
            {
                (sublayer as! CATextLayer).fontSize *= multiplier.averageScalar
            }
            
            if(sublayer.delegate is UILabel)
            {
                let label: UILabel = sublayer.delegate as! UILabel
                
                if(!label.adjustsFontSizeToFitWidth)
                {
                    label.adjustsFontSizeToFitWidth = true
                    label.minimumScaleFactor = (label.font.pointSize * multiplier.averageScalar) / label.font.pointSize
                }
            }
        }
    }
    
    /// Transfers the current layer to the given layer.
    ///
    /// - Parameter layer: The layer which this layer should be transferred to.
    func transfer(to layer: CALayer?)
    {
        let newFrame: CGRect? = superlayer?.convert(frame, to: layer)
        
        if(layer != nil)
        {
            layer!.addSublayer(self)
            frame = newFrame ?? frame
        }
    }
    
    /// Transfers the current layer to the given layer at the specified position.
    ///
    /// - Parameter layer: The layer which this layer should be transferred to.
    func transfer(to layer: CALayer?, at index: Int)
    {
        let newFrame: CGRect? = superlayer?.convert(frame, to: layer)
        
        if(layer != nil)
        {
            layer!.insertSublayer(self, at: UInt32(index))
            frame = newFrame ?? frame
        }
    }
    
    /// Transfers the current layer below a sublayer of the given layer.
    ///
    /// - Parameters:
    ///   - layer: The layer which this layer should be transferred to.
    ///   - sublayer: The sublayer which this layer should be inserted below.
    func transfer(to layer: CALayer?, below sublayer: CALayer?)
    {
        let newFrame: CGRect? = superlayer?.convert(frame, to: layer)
        
        if(layer != nil)
        {
            layer!.insertSublayer(self, below: sublayer)
            frame = newFrame ?? frame
        }
    }
    
    /// Transfers the current layer above a sublayer of the given layer.
    ///
    /// - Parameters:
    ///   - layer: The layer which this layer should be transferred to.
    ///   - sublayer: The sublayer which this layer should be inserted above.
    func transfer(to layer: CALayer?, above sublayer: CALayer?)
    {
        let newFrame: CGRect? = superlayer?.convert(frame, to: layer)
        
        if(layer != nil)
        {
            layer!.insertSublayer(self, above: sublayer)
            frame = newFrame ?? frame
        }
    }
}

// MARK: -
extension UIView
{
    /// Returns the furthermost point of the view's frame from its origin. (Superview's coordinate system)
    var frameEnd: CGPoint
    {
        return CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y + frame.height)
    }
    
    /// Returns the furthermost point of the view's bounds from its origin. (View's own coordinate system)
    var boundsEnd: CGPoint
    {
        return CGPoint(x: bounds.width, y: bounds.height)
    }
    
    /// Returns whether the view is supposed to draw its contents in left-to-right mode.
    var isLeftToRight: Bool
    {
        return semanticContentAttribute == .forceLeftToRight || semanticContentAttribute == .unspecified
    }
    
    /// Attempts to find the first responder in the part of the view hierarchy below the specified view.
    ///
    /// - Parameter view: The view the first responder view should be searched in.
    /// - Returns: The first responder view or nil if it was not found.
    func findFirstResponder(_ view: UIView? = nil) -> UIView?
    {
        if(view == nil)
        {
            return findFirstResponder(self)
        }
        else
        {
            if(view!.isFirstResponder)
            {
                return view
            }
            
            for subview in view!.subviews
            {
                if let result: UIView = findFirstResponder(subview)
                {
                    return result
                }
            }
            
            return nil
        }
    }
    
    /// Executes a set of actions on all views below the current view in the view hierarchy.
    ///
    /// - Parameter execution: The execution which should be performed on all views below the current view in the view hierarchy.
    func onAllSubviews(_ execution: (UIView) -> ())
    {
        for view in subviews
        {
            if(view.subviews.count > 0)
            {
                view.onAllSubviews(execution)
            }
            
            execution(view)
        }
    }
}

// MARK: -
extension UIColor
{
    /// The red component of the color. (0 to 1)
    var componentRed: CGFloat
    {
        get
        {
            var result: CGFloat = 0.0
            getRed(&result, green: nil, blue: nil, alpha: nil)
            
            return result
        }
    }
    
    /// The green component of the color. (0 to 1)
    var componentGreen: CGFloat
    {
        get
        {
            var result: CGFloat = 0.0
            getRed(nil, green: &result, blue: nil, alpha: nil)
            
            return result
        }
    }
    
    /// The blue component of the color. (0 to 1)
    var componentBlue: CGFloat
    {
        get
        {
            var result: CGFloat = 0.0
            getRed(nil, green: nil, blue: &result, alpha: nil)
            
            return result
        }
    }
    
    /// The alpha component of the color. (0 to 1)
    var componentAlpha: CGFloat
    {
        get
        {
            var result: CGFloat = 0.0
            getRed(nil, green: nil, blue: nil, alpha: &result)
            
            return result
        }
    }
    
    /// The white value of the color. (0 to 1)
    var whiteValue: CGFloat
    {
        get
        {
            var result: CGFloat = 0.0
            getWhite(&result, alpha: nil)
            
            return result
        }
    }
    
    /// Returns the greyscale of the color.
    var greyscale: UIColor
    {
        var greyscaleWhite: CGFloat = 0.0
        var greyscaleAlpha: CGFloat = 1.0
        
        getWhite(&greyscaleWhite, alpha: &greyscaleAlpha)
        
        return UIColor(white: greyscaleWhite, alpha: greyscaleAlpha)
    }
    
    /// Returns the color as an `SSColor`.
    var ssColor: SSColor
    {
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return SSColor(red: Int(red * 255), green: Int(green * 255), blue: Int(blue * 255), alpha: Float(alpha))
    }
    
    /// Adds the specified amount to every component of the color.
    ///
    /// - Parameter amount: The amount which should be added to each component of the color.
    /// - Returns: The new (modified) color.
    func added(_ amount: CGFloat) -> UIColor
    {
        return UIColor(red: componentRed + amount, green: componentGreen + amount, blue: componentBlue + amount, alpha: componentAlpha)
    }
    
    /// Subtracts the specified amount to every component of the color.
    ///
    /// - Parameter amount: The amount which should be subtracted to each component of the color.
    /// - Returns: The new (modified) color.
    func subtracted(_ amount: CGFloat) -> UIColor
    {
        return UIColor(red: componentRed - amount, green: componentGreen - amount, blue: componentBlue - amount, alpha: componentAlpha)
    }
    
    static func +(lhs: UIColor, rhs: UIColor) -> UIColor
    {
        return UIColor(red: lhs.componentRed + rhs.componentRed, green: lhs.componentGreen + rhs.componentGreen, blue: lhs.componentBlue + rhs.componentBlue, alpha: lhs.componentAlpha)
    }
    
    static func -(lhs: UIColor, rhs: UIColor) -> UIColor
    {
        return UIColor(red: lhs.componentRed - rhs.componentRed, green: lhs.componentGreen - rhs.componentGreen, blue: lhs.componentBlue - rhs.componentBlue, alpha: lhs.componentAlpha)
    }
    
    static func +=(lhs: inout UIColor, rhs: UIColor)
    {
        lhs = lhs + rhs
    }
    
    static func -=(lhs: inout UIColor, rhs: UIColor)
    {
        lhs = lhs - rhs
    }
}

// MARK: -
extension UIImage
{
    /// Returns the aspect ratio of the image, based on its size.
    var aspectRatio: CGFloat
    {
        return size.height / size.width
    }
    
    /// Creates a newly drawn image with the specified alpha value.
    ///
    /// - Parameter alpha: The alpha value the new image should be drawn with.
    /// - Returns: The new image with the specified alpha.
    func withAlphaValue(_ alpha: CGFloat) -> UIImage?
    {
        // Attempt to begin an image context
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        // Get the context
        let context: CGContext! = UIGraphicsGetCurrentContext()

        // Check if the context is valid
        if(context != nil)
        {
            // Draw the image in the context
            draw(at: .zero, blendMode: .normal, alpha: alpha)
            
            // Retrieve the image from the context
            let result: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            
            // End the context
            UIGraphicsEndImageContext()
            
            return result
        }
        
        return nil
    }
}

// MARK: -
extension UIImageView
{
    /// Tints the image view's image with the given color.
    ///
    /// - Parameter color: The color which the image should be tinted with.
    func tintImage(with color: UIColor)
    {
        image = image?.withRenderingMode(.alwaysTemplate)
        tintColor = color
    }
}

// MARK: -
extension UIViewPropertyAnimator
{
    /// Initializes the animator object with a cubic Bézier timing curve.
    ///
    /// - Parameters:
    ///   - duration: The duration of the animation, in seconds.
    ///   - curve: The object providing the timing information.
    ///   - animations: The block containing the animations. This block has no return value and takes no parameters. Use this block to modify any animatable view properties. When you start the animations, those properties are animated from their current values to the new values using the specified animation parameters.
    convenience init(duration: TimeInterval, curve: SSCubicTimingCurve, animations: (() -> ())?)
    {
        self.init(duration: duration, controlPoint1: curve.controlPoint1, controlPoint2: curve.controlPoint2, animations: animations)
    }
}

// MARK: -
extension UICubicTimingParameters
{
    /// The `SSCubicTimingCurve` representation of the cubic curve.
    var ssCubicTimingCurve: SSCubicTimingCurve
    {
        return SSCubicTimingCurve(controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
}
