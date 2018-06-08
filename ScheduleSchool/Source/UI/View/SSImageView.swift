//
//  SSImageView.swift
//  Schedule School
//
//  Created by Máté on 2017. 11. 17..
//  Copyright © 2017. theMatys. All rights reserved.
//

import UIKit

/// The custom image view of the application.
@IBDesignable
class SSImageView: UICustomImageView
{
    // MARK: Inspectable properties
    
    /// Indicates whether the image which the image view displays should be used as a template image.
    @IBInspectable var template: Bool = false
    {
        didSet
        {
            if(template)
            {
                image = image?.withRenderingMode(.alwaysTemplate)
                tintColorDidChange()
            }
            else
            {
                image = image?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    /// Indicates whether the image view should be automatically provided a highlighted image.
    @IBInspectable var highlightable: Bool = false
    {
        didSet
        {
            _init()
        }
    }
    
    // MARK: Inherited properties from: UICustomImageView
    override var image: UIImage?
    {
        didSet
        {
            if(image != oldValue || image == oldValue?.withRenderingMode(.alwaysTemplate))
            {
                // Update the highlighted image if there was a change to the image
                updateHighlightedImage()
             
                if(image != oldValue?.withRenderingMode(.alwaysTemplate) && template)
                {
                    image = image?.withRenderingMode(.alwaysTemplate)
                    tintColorDidChange()
                }
            }
        }
    }
    
    // MARK: - Inherited initializers from: UICustomImageView
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        _init()
    }
    
    override init(image: UIImage?)
    {
        super.init(image: image)
        _init()
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?)
    {
        super.init(image: image, highlightedImage: highlightedImage)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        _init()
    }
    
    // MARK: Methods
    
    /// The custom initializer of the image view.
    private func _init()
    {
        // Initialize the style-based appearance of the image view and the highlighted image if necessary
        updateHighlightedImage()
    }
    
    private func updateHighlightedImage()
    {
        if(highlightable && image != nil)
        {
            highlightedImage = image?.withAlphaValue(0.75)
        }
    }
}

/// The base class of the application's custom image view with specific inspectable layer properties.
internal class UICustomImageView: UIImageView
{
    /// The radius to use when drawing rounded corners for the image view’s background.
    ///
    /// If its value is not set, the image view will use its default corner radius.
    ///
    /// If its value is less than zero, the image view will use a corner radius of half of its height. This will cause the image view to be drawn with fully rounded corners without over-rounding them.
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
    
    /// The color of the image view's border.
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
    
    /// The width of the image view’s border.
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
    
    /// The color of the image view’s shadow.
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
    
    /// The opacity of the image view’s shadow.
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
    
    /// The blur radius (in points) used to render the image view’s shadow.
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
    
    /// The offset (in points) of the image view’s shadow.
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
    
    // MARK: Inherited properties from: UIImageView
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
    
    /// The state of the image image view's corners.
    ///
    /// For further information on the states, see `SSView.CornerState`.
    private var cornerState: SSView.CornerState = .undefined
}
