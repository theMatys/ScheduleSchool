//
//  SSView.swift
//  Schedule School
//
//  Created by Máté on 2018. 01. 02..
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

/// A custom view of the application with specific inspectable layer properties.
@IBDesignable
class SSView: UIView
{
    /// The radius to use when drawing rounded corners for the view layer’s background.
    ///
    /// If its value is not set, the view will use its default corner radius.
    ///
    /// If its value is less than zero, the view will use a corner radius of half of its height. This will cause the view to be drawn with fully rounded corners without over-rounding them.
    @IBInspectable internal var cornerRadius: CGFloat
    {
        set
        {
            if(newValue >= 0.0)
            {
                layer.cornerRadius = newValue
                cornerState = .custom
            }
            else
            {
                layer.cornerRadius = frame.height / 2
                cornerState = .max
            }
        }
        
        get
        {
            return layer.cornerRadius
        }
    }
    
    /// The color of the view layer's border.
    @IBInspectable internal var borderColor: UIColor
    {
        get
        {
            return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : UIColor.clear
        }
        
        set
        {
            layer.borderColor = newValue.cgColor
        }
    }
    
    /// The width of the view layer’s border.
    @IBInspectable internal var borderWidth: CGFloat
    {
        get
        {
            return layer.borderWidth
        }
        
        set
        {
            layer.borderWidth = newValue
        }
    }
    
    /// The color of the view layer’s shadow.
    @IBInspectable internal var shadowColor: UIColor
    {
        get
        {
            return layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) : UIColor.clear
        }
        
        set
        {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    /// The opacity of the view layer’s shadow.
    @IBInspectable internal var shadowOpacity: Float
    {
        get
        {
            return layer.shadowOpacity
        }
        
        set
        {
            layer.shadowOpacity = newValue
        }
    }
    
    /// The blur radius (in points) used to render the view layer’s shadow.
    @IBInspectable internal var shadowRadius: CGFloat
    {
        get
        {
            return layer.shadowRadius
        }
        
        set
        {
            layer.shadowRadius = newValue
        }
    }
    
    /// The offset (in points) of the view layer’s shadow.
    @IBInspectable internal var shadowOffset: CGSize
    {
        get
        {
            return layer.shadowOffset
        }
        
        set
        {
            layer.shadowOffset = newValue
        }
    }
    
    // MARK: Inherited properties from: UIView
    override var frame: CGRect
    {
        didSet
        {
            if(cornerState == .max)
            {
                cornerRadius = -1.0
            }
        }
    }
    
    // MARK: Properties
    
    /// The state of the view's corners.
    ///
    /// For further information on the states, see `SSViewCornerState`.
    private var cornerState: SSView.CornerState = .undefined
    
    // MARK: -
    
    /// The enumeration which contains all the possible states of a view's corners.
    ///
    /// - undefined: The __undefined__ corner state will use the default the corner radius of the view.
    /// - custom: The __custom__ corner state will use the user-specified corner radius for the view.
    /// - max: The __max__ corner radius state will use a corner radius which equals to half of the current height of the view. This will cause the view to be drawn with fully rounded corners without over-rounding them.
    enum CornerState
    {
        case undefined
        case custom
        case max
    }
}

// MARK: -
// MARK: -

/// A custom view of the application with a gradient-fill capability.
@IBDesignable
class SSGradientView: SSView
{
    // MARK: Inspectables
    
    /// The raw code of the view layer's gradient.
    ///
    /// If there is a valid code provided, the view will compile the code into an `SSGradient` and fill its layer with it.
    ///
    /// If there is no code provided or the code is invalid, the view will be filled with the background color.
    @IBInspectable internal var gradientCode: String = ""
    {
        didSet
        {
            gradient = SSGradient.compile(gradientCode)
        }
    }
    
    // MARK: Inherited variables from: UIView
    override open class var layerClass: Swift.AnyClass
    {
        get
        {
            return CAGradientLayer.self
        }
    }
    
    // MARK: Properties
    
    /// The gradient which fills the view's layer.
    ///
    /// If there is a gradient code or a gradient provided, the view's layer will be filled with the given gradient.
    ///
    /// If there is no code provided, the view's layer will be filled with the background color.
    var gradient: SSGradient? = nil
    {
        didSet
        {
            if(gradient != nil)
            {
                gradient!.toGradientLayer(gradientLayer)
            }
        }
    }
    
    /// The layer of the view as a gradient layer.
    private var gradientLayer: CAGradientLayer
    {
        get
        {
            return layer as! CAGradientLayer
        }
    }
}


/// A simple view which is capable of displaying a two-stop linear gradient.
@IBDesignable
class SSTwoStopGradientView: SSView
{
    // MARK: Inspectables
    
    /// The starting point of the gradient (ranging from 0 to 1), relative to its parent layer.
    @IBInspectable internal var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    {
        didSet
        {
            gradient?.startPoint = startPoint
            update()
        }
    }
    
    /// The end point of the gradient (ranging from 0 to 1), relative to its parent layer.
    @IBInspectable internal var endPoint: CGPoint = CGPoint(x: 1.0, y: 0.0)
    {
        didSet
        {
            gradient?.endPoint = endPoint
            update()
        }
    }
    
    /// The color of the first gradient stop
    @IBInspectable internal var color1: UIColor = UIColor.clear
    {
        didSet
        {
            gradient?.stops[0].color = color1.ssColor
            update()
        }
    }
    
    /// The color of the second gradient stop.
    @IBInspectable internal var color2: UIColor = UIColor.clear
    {
        didSet
        {
            gradient?.stops[1].color = color2.ssColor
            update()
        }
    }
    
    // MARK: Inherited variables from: UIView
    override open class var layerClass: Swift.AnyClass
    {
        get
        {
            return CAGradientLayer.self
        }
    }
    
    // MARK: Properties
    
    /// The gradient which fills the view's layer.
    ///
    /// If there is a gradient provided, the view's layer will be filled with the given gradient.
    ///
    /// If there is no gradient provided, the view's layer will be filled with the background color.
    var gradient: SSGradient? = nil
    {
        didSet
        {
            update()
        }
    }
    
    /// The layer of the view as a gradient layer.
    private var gradientLayer: CAGradientLayer
    {
        get
        {
            return layer as! CAGradientLayer
        }
    }
    
    // MARK: Inherited initializers from: UIView
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        prepare()
    }
    
    // MARK: Methods
    
    /// Prepares the gradient of the view.
    private func prepare()
    {
        gradient = SSGradient(startPoint: startPoint, endPoint: endPoint, stops: [SSGradientStop(color: color1.ssColor, point: 0.0), SSGradientStop(color: color2.ssColor, point: 1.0)])
    }
    
    /// Updates the gradient of the view.
    private func update()
    {
        if(gradient != nil)
        {
            gradient!.toGradientLayer(gradientLayer)
        }
    }
}
