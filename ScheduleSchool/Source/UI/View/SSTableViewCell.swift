//
//  SSTableViewCell.swift
//  Schedule School
//
//  Created by Máté on 2018. 02. 18..
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

/// The custom table view cell of the application.
class SSTableViewCell: UICustomTableViewCell
{
    // MARK: Inspectables
    
    /// The Interface Builder compatible copy of `behavior`.
    ///
    /// Whenever its value is set, it is clamped and used to create an `SSTableViewCell.Behavior` instance.
    @IBInspectable internal var ibBehavior: Int = 1
    {
        didSet
        {
            behavior = Behavior(rawValue: (ibBehavior <?> (1, Behavior.count)) - 1)!
        }
    }
    
    // MARK: Inherited properties from: UICustomTableViewCell
    override var selectionStyle: UITableViewCellSelectionStyle
    {
        set
        {
            // No operation, because "SSTableViewCell" uses a fully custom selection style
        }
        
        get
        {
            // Always return "none", to enable the fully custom selection style
            return .none
        }
    }
    
    // MARK: Inherited properties from: UICustomTableViewCell
    override var backgroundColor: UIColor?
    {
        get
        {
            return normalBackgroundColor ?? UIColor.white
        }
        
        set
        {
            normalBackgroundColor = newValue
            highlightedBackgroundColor = newValue != nil && newValue!.whiteValue <= 0.5 ? newValue?.added(.ssTableViewCellHighlightAmount) : newValue?.subtracted(.ssTableViewCellHighlightAmount)
        }
    }
    
    override var isUserInteractionEnabled: Bool
    {
        didSet
        {
            updateEnabled()
        }
    }
    
    override var isHighlighted: Bool
    {
        get
        {
            return sIsHighlighted
        }
        
        set
        {
            setHighlighted(newValue, animated: false)
        }
    }
    
    override var isSelected: Bool
    {
        get
        {
            return sIsSelected
        }
        
        set
        {
            setSelected(newValue, animated: false)
        }
    }
    
    // MARK: Properties
    
    /// The behavior of the table view cell.
    ///
    /// For further information on the behaviors, see: `SSTableViewCell.Behavior`.
    var behavior: Behavior = .interactable
    
    /// The background color of the button for the "normal" state.
    internal var normalBackgroundColor: UIColor?
    {
        didSet
        {
            layer.backgroundColor = normalBackgroundColor?.cgColor
        }
    }
    
    /// The background color of the button for the "highlighted" state.
    internal var highlightedBackgroundColor: UIColor?
    
    /// The stored value of "`isHighlighted`".
    private var sIsHighlighted: Bool = false
    
    /// The stored value of "`isSelected`".
    private var sIsSelected: Bool = false
    
    // MARK: - Inherited initializers from: UICustomTableViewCell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        prepare()
    }
    
    // MARK: Inherited methods from: UICustomTableViewCell
    override func setHighlighted(_ highlighted: Bool, animated: Bool)
    {
        sIsHighlighted = highlighted
        
        if(behavior == .toggleable || behavior == .selectable)
        {
            if(highlighted)
            {
                if(animated)
                {
                    let animation: SSLayerPropertyAnimation.Basic = SSLayerPropertyAnimation.Basic(layer: layer, property: .backgroundColor).with(duration: 0.2).with(fromValue: normalBackgroundColor?.cgColor).with(toValue: highlightedBackgroundColor?.cgColor)
                    
                    layer.backgroundColor = highlightedBackgroundColor?.cgColor
                    animation.commit()
                }
                else
                {
                    layer.backgroundColor = highlightedBackgroundColor?.cgColor
                }
            }
            else if(!isSelected)
            {
                if(animated)
                {
                    let animation: SSLayerPropertyAnimation.Basic = SSLayerPropertyAnimation.Basic(layer: layer, property: .backgroundColor).with(duration: 0.2).with(fromValue: highlightedBackgroundColor?.cgColor).with(toValue: normalBackgroundColor?.cgColor)
                    
                    layer.backgroundColor = normalBackgroundColor?.cgColor
                    animation.commit()
                }
                else
                {
                    layer.backgroundColor = normalBackgroundColor?.cgColor
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        sIsSelected = selected
        
        if(behavior == .toggleable)
        {
            let animations: SSSimultaniousAnimations = SSSimultaniousAnimations()
                .with(duration: animated ? 0.2 : 0.0)
                .added(SSLayerPropertyAnimation.Basic(layer: layer, property: .backgroundColor).with(fromValue: highlightedBackgroundColor?.cgColor).with(toValue: normalBackgroundColor?.cgColor))
            
            if(accessoryView != nil)
            {
                let _: SSSimultaniousAnimations = animations
                    .added(SSLayerPropertyAnimation.Basic(layer: accessoryView!.layer, property: .opacity).with(fromValue: isSelected ? 0.0 : 1.0).with(toValue: isSelected ? 1.0 : 0.0))
                
                accessoryView!.layer.opacity = isSelected ? 1.0 : 0.0
            }
            
            layer.backgroundColor = normalBackgroundColor?.cgColor
            animations.commit()
        }
        else if(behavior == .selectable)
        {
            if(selected)
            {
                if(animated)
                {
                    let animation: SSLayerPropertyAnimation.Basic = SSLayerPropertyAnimation.Basic(layer: layer, property: .backgroundColor).with(duration: 0.2).with(fromValue: normalBackgroundColor?.cgColor).with(toValue: highlightedBackgroundColor?.cgColor)
                    
                    layer.backgroundColor = highlightedBackgroundColor?.cgColor
                    animation.commit()
                }
                else
                {
                    layer.backgroundColor = highlightedBackgroundColor?.cgColor
                }
            }
            else
            {
                if(animated)
                {
                    let animation: SSLayerPropertyAnimation.Basic = SSLayerPropertyAnimation.Basic(layer: layer, property: .backgroundColor).with(duration: 0.2).with(fromValue: highlightedBackgroundColor?.cgColor).with(toValue: normalBackgroundColor?.cgColor)
                    
                    layer.backgroundColor = normalBackgroundColor?.cgColor
                    animation.commit()
                }
                else
                {
                    layer.backgroundColor = normalBackgroundColor?.cgColor
                }
            }
        }
    }

    // MARK: Methods
    
    /// Prepares the table view cell after it has been initialized.
    private func prepare()
    {
        
    }
    
    /// Updates the table view cell after it has been enabled/disabled.
    internal func updateEnabled()
    {
        if(isUserInteractionEnabled)
        {
            let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: SSCubicTimingCurve.linear) {
                self.contentView.alpha = .ssControlStateNormalOpacity
            }
            
            animator.startAnimation()
        }
        else
        {
            let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: SSCubicTimingCurve.linear) {
                self.contentView.alpha = .ssControlStateDisabledOpacity
            }
            
            animator.startAnimation()
        }
    }
    
    /// Updates the table view cell after it has been highlighted/unhighlighted.
    internal func updateHighlighted(_ highlighted: Bool)
    {
        
    }
    
    /// Updates the table view cell after it has been selected/deselected.
    internal func updateSelected(_ selected: Bool)
    {
        
    }
    
    // MARK: -
    
    /// The enumeration which describes all the possible behaviors of a table view cell.
    enum Behavior: Int
    {
        /// Behavior "`interactable`" means that the user can interact with the table view cell, however they can not highlight or select it.
        case interactable
        
        /// Behavior "`editable`" means that the user can edit the table view cell, however they can not highlight or select it.
        case editable
        
        /// Behavior "`toggleable`" means that the user can toggle the selection of the cell with each tap. The accessory of the cell is only displayed when the cell is selected.
        case toggleable
        
        /// Behavior "`selectable`" means that the user can highlight and select the table view cell once. The cell stays selected until it is programatically deselected.
        case selectable
        
        /// The total number of cases in the enumeration.
        static var count: Int
        {
            return selectable.hashValue + 1
        }
    }
}

/// The base class of the application's custom table view cell with specific inspectable layer properties and full customizability.
@IBDesignable
internal class UICustomTableViewCell: UITableViewCell
{
    // MARK: Inspectables
    
    /// The radius to use when drawing rounded corners for the button’s background.
    ///
    /// If its value is not set, the button will use its default corner radius.
    ///
    /// If its value is less than zero, the button will use a corner radius of half of its height. This will cause the button to be drawn with fully rounded corners without over-rounding them.
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
    
    /// The color of the button's border.
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
    
    /// The raw code of the button's gradient.
    ///
    /// If there is a valid code provided, the view will compile the code into an `SSGradient` and fill its layer with it.
    ///
    /// If there is no code provided or the code is invalid, the view will be filled with the background color.
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
    
    // MARK: Inherited static variables from: UIButton
    override open class var layerClass: Swift.AnyClass
    {
        get
        {
            return CAGradientLayer.self
        }
    }
    
    // MARK: Inherited properties from: UIButton
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
    
    /// The gradient which fills the button's layer.
    ///
    /// If there is a gradient code or a gradient provided, the button's layer will be filled with the given gradient.
    ///
    /// If there is no code provided, the button's layer will be filled with the background color.
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
    
    /// The layer of the button as a gradient layer.
    private var gradientLayer: CAGradientLayer
    {
        get
        {
            return layer as! CAGradientLayer
        }
    }
    
    /// The state of the button's corners.
    ///
    /// For further information on the states, see `SSViewCornerState`.
    private var cornerState: SSView.CornerState = .undefined
}
