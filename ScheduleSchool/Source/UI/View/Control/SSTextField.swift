//
//  SSTextField.swift
//  Schedule School
//
//  Created by Máté on 2018. 01. 28..
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

/// The custom text field of the application.
@IBDesignable
class SSTextField: UICustomTextField, SSCustomLocalizable
{
    // MARK: Implemented inspectable properties from: SSCustomLocalizable
    @IBInspectable var localizationKey: String!
    {
        didSet
        {
            placeholder = localizedText()
        }
    }
    
    // MARK: Inspectables
    
    /// The color of the text field's placeholder.
    @IBInspectable var placeholderColor: UIColor = UIColor.black
    {
        didSet
        {
            updatePlaceholder()
        }
    }
    
    /// The left inset of the text field's text rectangle.
    @IBInspectable private var leftInset: CGFloat
    {
        get
        {
            return textRectInsets.left
        }
        
        set
        {
            textRectInsets.left = newValue
        }
    }
    
    /// The right inset of the text field's text rectangle.
    @IBInspectable private var rightInset: CGFloat
    {
        get
        {
            return textRectInsets.right
        }
        
        set
        {
            textRectInsets.right = newValue
        }
    }
    
    /// The top inset of the text field's text rectangle.
    @IBInspectable private var topInset: CGFloat
    {
        get
        {
            return textRectInsets.top
        }
        
        set
        {
            textRectInsets.top = newValue
        }
    }
    
    /// The bottom inset of the text field's text rectangle.
    @IBInspectable private var bottomInset: CGFloat
    {
        get
        {
            return textRectInsets.bottom
        }
        
        set
        {
            textRectInsets.bottom = newValue
        }
    }
    
    // MARK: Inherited properties from: UICustomTextField
    override var isEnabled: Bool
    {
        didSet
        {
            if(oldValue != isEnabled)
            {
                updateEnabled()
            }
        }
    }
    
    override var placeholder: String?
    {
        didSet
        {
            updatePlaceholder()
        }
    }
    
    // MARK: Properties
    
    /// The insets of the rectangle in which the text is displayed.
    var textRectInsets: UIEdgeInsets = UIEdgeInsets(top: 2.0, left: 7.0, bottom: 2.0, right: 7.0)
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    /// The stored value of the text field's attributed placeholder.
    ///
    /// The value of this property is used to restore the placeholder after it has been hidden.
    private var sAttributedPlaceholder: NSAttributedString?
    
    // MARK: - Inherited initializers from: UICustomTextField
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
    
    // MARK: Inherited methods from: UICustomTextField
    override func textRect(forBounds bounds: CGRect) -> CGRect
    {
        return CGRect(x: bounds.origin.x + textRectInsets.left, y: bounds.origin.y + textRectInsets.top, width: bounds.width - textRectInsets.left - textRectInsets.right, height: bounds.height - textRectInsets.top - textRectInsets.bottom)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        return textRect(forBounds: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect
    {
        return textRect(forBounds: bounds)
    }
    
    override func becomeFirstResponder() -> Bool
    {
        let superResult: Bool = super.becomeFirstResponder()
        
        if(superResult && isEditing)
        {
            updateEditing()
        }
        
        return superResult
    }
    
    override func resignFirstResponder() -> Bool
    {
        let superResult: Bool = super.resignFirstResponder()
        
        if(superResult && isEditing)
        {
            updateEditing()
        }
        
        return superResult
    }
    
    // MARK: Methods
    
    /// Updates the button after it has been enabled/disabled.
    internal func updateEnabled()
    {
        if(isEnabled)
        {
            let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: SSCubicTimingCurve.linear) {
                self.alpha = .ssControlStateNormalOpacity
            }
            
            animator.startAnimation()
        }
        else
        {
            let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: SSCubicTimingCurve.linear) {
                self.alpha = .ssControlStateDisabledOpacity
            }
            
            animator.startAnimation()
        }
    }
    
    /// Updates the button after the editing has started/ended.
    ///
    /// The default implementation of this function does nothing. Subclasses may override this function to add operations upon the editing has started/ended.
    @objc internal func updateEditing() {}
    
    internal func showPlaceholder()
    {
        attributedPlaceholder = sAttributedPlaceholder
        sAttributedPlaceholder = nil
    }
    
    internal func hidePlaceholder()
    {
        sAttributedPlaceholder = attributedPlaceholder
        attributedPlaceholder = nil
    }

    /// Prepares the text field after it has been initialized.
    private func prepare()
    {
        // Prepare the appearance of the text field
        updatePlaceholder()
    }
    
    /// Updates the placeholder according to its style.
    private func updatePlaceholder()
    {
        if(placeholder != nil && sAttributedPlaceholder == nil)
        {
            attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSAttributedStringKey.foregroundColor : placeholderColor.withAlphaComponent(0.22)])
        }
    }
}

// MARK: -
// MARK: -

/// The base class of the application's custom text field with specific inspectable layer properties and full customizability.
internal class UICustomTextField: UITextField
{
    // MARK: Inspectables
    
    /// The radius to use when drawing rounded corners for the text field’s background.
    ///
    /// If its value is not set, the text field will use its default corner radius.
    ///
    /// If its value is less than zero, the text field will use a corner radius of half of its height. This will cause the text field to be drawn with fully rounded corners without over-rounding them.
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
    
    /// The color of the text field's border.
    ///
    /// An invalid color by default. If its value is an invalid color, the text field will use the default border color for the corresponding border style.
    @IBInspectable internal var borderColor: UIColor
    {
        get
        {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        
        set
        {
            layer.borderColor = newValue.cgColor
        }
    }
    
    /// The width of the text field’s border.
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
    
    /// The color of the text field’s shadow.
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
    
    /// The opacity of the text field’s shadow.
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
    
    /// The blur radius (in points) used to render the text field’s shadow.
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
    
    /// The offset (in points) of the text field’s shadow.
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
    
    /// The raw code of the text field's gradient.
    ///
    /// If there is a valid code provided, the text field will compile the code into an `SSGradient` and fill its layer with it.
    ///
    /// If there is no code provided or the code is invalid, the text field will be filled with the background color.
    @IBInspectable internal var gradientCode: String = ""
    {
        didSet
        {
            if(gradientCode != "")
            {
                gradient = SSGradient.compile(gradientCode)
            }
        }
    }
    
    // MARK: Inherited properties from: UITextField
    override var borderStyle: UITextBorderStyle
    {
        didSet
        {
            if(borderStyle != .none)
            {
                borderStyle = .none
            }
        }
    }
    
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
    
    override var backgroundColor: UIColor?
    {
        get
        {
            return layer.backgroundColor != nil ? UIColor(cgColor: layer.backgroundColor!) : nil
        }
        
        set
        {
            layer.backgroundColor = newValue?.cgColor
        }
    }
    
    // MARK: Inherited variables from: UITextField
    override open class var layerClass: Swift.AnyClass
    {
        get
        {
            return CAGradientLayer.self
        }
    }
    
    // MARK: Properties
    
    /// The gradient which fills the text field's layer.
    ///
    /// If there is a gradient code or a gradient provided, the text field's layer will be filled with the given gradient.
    ///
    /// If there is no code provided, the text field's layer will be filled with the background color.
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
    
    /// The layer of the text field as a gradient layer.
    private var gradientLayer: CAGradientLayer
    {
        get
        {
            return layer as! CAGradientLayer
        }
    }
    
    /// The state of the text field's corners.
    ///
    /// For further information on the states, see `SSViewCornerState`.
    private var cornerState: SSView.CornerState = .undefined
    
    // MARK: - Inherited initializers from: UITextField
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
    
    /// Prepares the text field after it has been initialized.
    private func prepare()
    {
        backgroundColor = backgroundColor ?? UIColor.white
        cornerRadius = cornerState == .undefined ? 5.0 : cornerRadius
    }
}
