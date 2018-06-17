//
//  SSButton.swift
//  Schedule School
//
//  Created by Máté on 2018. 02. 17..
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

/// The custom button of the application.
@IBDesignable
class SSButton: UICustomButton, SSCustomLocalizable
{
    // MARK: Implemented inspectables from: SSCustomLocalizable
    @IBInspectable var localizationKey: String!
    {
        didSet
        {
            setTitle(localizedText(), for: .normal)
        }
    }
    
    // MARK: Inspectables
    
    /// The Interface Builder compatible copy of "`highlightStyle`".
    ///
    /// Whenever its value is set, it is clamped and used to create an `SSButton.HighlightStyle` instance.
    @IBInspectable private var ibHighlightStyle: Int = 1
    {
        didSet
        {
            highlightStyle = HighlightStyle(rawValue: (ibHighlightStyle <?> (1, HighlightStyle.count)) - 1)!
        }
    }
    
    /// A boolean which indicates whether the button can be selected.
    @IBInspectable var selectable: Bool = false
    
    /// An image which is visible when the button is selected, but hidden when the button is deselected.
    ///
    /// The image is vertically centered in the button. As for the horizontal placement, the image will be insetted with `indicatorInsets` either from the left or the right (depending on the sign of `indicatorInset`).
    ///
    /// The image is drawn with the size `indicatorSize`.
    @IBInspectable var indicatorImage: UIImage? = UIImage()
    {
        didSet
        {
            selectionIndicator?.image = indicatorImage
        }
    }
    
    /// The horizontal inset of the indicator image.
    ///
    /// *Positive values* will be counted from the left side of the button's bounds.
    ///
    /// *Negative values* will be counted from the right side of the button's bounds.
    @IBInspectable var indicatorInset: CGFloat = 0.0
    {
        didSet
        {
            selectionIndicator?.inset = indicatorInset
        }
    }
    
    /// The size of the selection indicator image.
    @IBInspectable var indicatorSize: CGSize = CGSize()
    {
        didSet
        {
            selectionIndicator?.size = indicatorSize
        }
    }
    
    /// The color of the button's selection indicator image.
    @IBInspectable var indicatorColor: UIColor = UIColor.clear
    {
        didSet
        {
            selectionIndicator?.tintColor = indicatorColor
        }
    }
    
    // MARK: Inherited properties from: UICustomButton
    override var backgroundColor: UIColor?
    {
        get
        {
            return normalBackgroundColor
        }
        
        set
        {            
            normalBackgroundColor = newValue
        }
    }
    
    override var tintColor: UIColor!
    {
        didSet
        {
            selectionIndicator?.tintColor = tintColor
        }
    }
    
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
    
    override var isSelected: Bool
    {
        didSet
        {
            if(oldValue != isSelected)
            {
                updateSelected()
            }
        }
    }
    
    override var buttonType: UIButtonType
    {
        return .custom
    }
    
    // MARK: Properties
    
    /// The style of the button's highlight.
    ///
    /// For further information on the highlight styles, see: "`SSButton.HighlightStyle`"
    var highlightStyle: HighlightStyle = .opacity
    
    /// The selection indicator of the button.
    ///
    /// This property is the final image view which is constructed from its describind properties (`indicatorImage`, `indicatorInset`, `indicatorSize`, `indicatorColor`).
    internal var selectionIndicator: SelectionIndicator?
    
    /// Constraints the title label's leading anchor to the button's leading anchor, with an additional inset (see: "`labelInsetLeading`").
    internal var titleLabelLeadingConstraint: NSLayoutConstraint!
    
    /// Constraints the title label's trailing anchor to the button's trailing anchor, with an additional inset (see: "`labelInsetTrailing`").
    internal var titleLabelTrailingConstraint: NSLayoutConstraint!
    
    private var titleLabelVerticalConstraint: NSLayoutConstraint!
    
    /// The background color of the button in its normal state.
    internal var normalBackgroundColor: UIColor?
    {
        didSet
        {
            layer.backgroundColor = normalBackgroundColor?.cgColor
        }
    }
    
    /// The background color of the button in its highlighted state.
    ///
    /// The value of this property is dynamically calculated from the button's background color in normal state.
    ///
    /// If the normal background color is considered light, the highlighted background color will be slightly darker.
    ///
    /// If the normal background color is considered dark, the hihglighted background color will be slightly lighter.
    internal var highlightedBackgroundColor: UIColor?
    {
        return normalBackgroundColor != nil ? normalBackgroundColor!.whiteValue <= 0.5 ? normalBackgroundColor?.added(.ssTableViewCellHighlightAmount) : normalBackgroundColor?.subtracted(.ssTableViewCellHighlightAmount) : nil
    }
    
    // MARK: - Inherited initializers from: UICustomButton
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
    
    /// Prepares the button after it has been initialized.
    private func prepare()
    {
        // Prepare the appearance of the button
        selectionIndicator = SelectionIndicator(button: self)
        
        // Prepare the basic events of the button
        addTarget(self, action: #selector(SSButton.touchDown), for: .touchDown)
        addTarget(self, action: #selector(SSButton.touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(SSButton.touchDragEnter), for: .touchDragEnter)
        addTarget(self, action: #selector(SSButton.touchDragExit), for: .touchDragExit)
    }
    
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
    
    /// Updates the button after it has been highlighted/unhighlighted.
    ///
    /// - Parameter drag: A boolean which indicates whether the highlightion of the button has been toggled by a drag or by a single touch.
    internal func updateHighlighted(drag: Bool)
    {
        switch highlightStyle
        {
        case .opacity:
            if(isHighlighted)
            {
                if(drag)
                {
                    let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: SSCubicTimingCurve.linear) {
                        self.alpha = .ssControlStateHighlightedOpacity
                    }
                    
                    animator.startAnimation()
                }
                else
                {
                    alpha = .ssControlStateHighlightedOpacity
                }
            }
            else
            {
                let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: SSCubicTimingCurve.linear) {
                    self.alpha = .ssControlStateNormalOpacity
                }
                
                animator.startAnimation()
            }
            
            break
        case .background:
            if(isHighlighted)
            {
                if(drag)
                {
                    let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: SSCubicTimingCurve.linear) {
                        self.layer.backgroundColor = self.highlightedBackgroundColor?.cgColor
                    }
                    
                    animator.startAnimation()
                }
                else
                {
                    layer.backgroundColor = highlightedBackgroundColor?.cgColor
                }
            }
            else
            {
                let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: SSCubicTimingCurve.linear) {
                    self.layer.backgroundColor = self.normalBackgroundColor?.cgColor
                }
                
                animator.startAnimation()
            }
            
            break
        }
    }
    
    /// Updates the button after it has been selected/deselected.
    internal func updateSelected()
    {
        if(isSelected)
        {
            selectionIndicator = SelectionIndicator(button: self)
            selectionIndicator?.show()
        }
        else
        {
            selectionIndicator?.hide()
        }
    }
    
    /// Handles a "touchDown" event for the button.
    ///
    /// Calls `updateHighlighted(isHighlighted:drag:)` with parameter `drag` set to `false` to perform the highlight operations.
    @objc private func touchDown()
    {
        isHighlighted = true
        updateHighlighted(drag: false)
    }
    
    /// Handles a "touchUpInside" event for the button.
    ///
    /// If the button is selectable, it calls `updateSelected(isSelected:)` with the parameter `isSelected` set to the inverse of its current value in the button to perfrom the selection operations.
    ///
    /// If the button is not selectable, it calls `updateHighlighted(isHighlighted:drag:)` with both parameters set to `false` to perform the highlight operation.
    @objc private func touchUpInside()
    {
        isHighlighted = false
        updateHighlighted(drag: false)
        
        if(selectable)
        {
            isSelected=!
        }
    }
    
    /// Handles a "touchDragEnter" event for the button.
    ///
    /// Calls `updateHighlighted(isHighlighted:drag:)` with parameter `drag` set to `true` to perform the hihglight operations.
    @objc private func touchDragEnter()
    {
        isHighlighted = true
        updateHighlighted(drag: true)
    }
    
    /// Handles a "touchDragExit" event for the button.
    ///
    /// Calls `updateHighlighted(isHighlighted:drag:)` with parameter `drag` set to `true` to perform the highlight operations.
    @objc private func touchDragExit()
    {
        isHighlighted = false
        updateHighlighted(drag: true)
    }
    
    // MARK: -
    
    /// The possible highlight styles of an `SSButton`.
    enum HighlightStyle: Int
    {
        /// Highlight style "`opacity`" decreases the button's opacity upon highlight.
        case opacity
        
        /// Highlight style "`background`" makes the button's background darker/lighter upon highlight.
        ///
        /// The direction of the change (darker/lighter) is determined by the original background of the button.
        case background
        
        /// The total number of cases in the enumeration.
        static var count: Int
        {
            return background.rawValue + 1
        }
    }
    
    // MARK: -
    
    /// The image view which displays the selection indicator image of an `SSButton` when it is selected.
    @IBDesignable
    internal class SelectionIndicator: UIImageView
    {
        // MARK: Inherited properties from: UIImageView
        override var image: UIImage?
        {
            didSet
            {
                if(image?.renderingMode != .alwaysTemplate)
                {
                    image = image?.withRenderingMode(.alwaysTemplate)
                }
            }
        }
        
        // MARK: Properties
        
        /// The horizontal inset of the indicator image (either from the left or the right side of the button's bounds).
        var inset: CGFloat!
        {
            didSet
            {
                xConstraint = (inset.sign == .plus ? leadingAnchor : trailingAnchor).constraint(equalTo: inset.sign == .plus ? button.leadingAnchor : button.trailingAnchor, constant: inset)
            }
        }
        
        /// The size of the selection indicator image.
        var size: CGSize!
        {
            didSet
            {
                widthConstraint = widthAnchor.constraint(equalToConstant: size.width)
                heightConstraint = heightAnchor.constraint(equalToConstant: size.height)
                
                layoutIfNeeded()
            }
        }
        
        /// The constraint which attains the horizontal inset of the selector indicator image.
        var xConstraint: NSLayoutConstraint!
        
        /// The constraint which centers the selection indicator image vertically in the button.
        private var yConstraint: NSLayoutConstraint!
        
        /// The constraint which attains the width of the selector indicator image.
        var widthConstraint: NSLayoutConstraint!
        
        /// The constraint which attains the height of the selector indicator image.
        var heightConstraint: NSLayoutConstraint!
        
        /// The button which the selection indicator belongs to.
        private var button: SSButton!
        
        // MARK: - Inherited initializers from: UIImageView
        required init?(coder aDecoder: NSCoder)
        {
            super.init(coder: aDecoder)
            
            SSLogError("An \"SSButton.SelectionIndicator\" has been initialized using \"required init?(coder:)\"! You should not use this initializer for a button's selection indicator. Use \"init(button:inset:size:image:)\" instead. The current selection indicator will be useless.")
        }
        
        // MARK: Initializers
        
        /// Initializes an `SSButton.SelectionIndicator` out of the given parameters and adds it to the specified button.
        ///
        /// - Parameters:
        ///   - button: The button which the selection indicator belongs to.
        ///   - image: The selection indicator image.
        ///   - inset: The horizontal inset of the selection indicator image (either from the left or the right side of the button's bounds).
        ///   - size: The size of the indicator image.
        ///   - tintColor: The tint color of the selection indicator image.
        init(button: SSButton)
        {
            super.init(frame: CGRect.zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            image = button.indicatorImage?.withRenderingMode(.alwaysTemplate)
            inset = button.indicatorInset
            size = button.indicatorSize
            tintColor = button.indicatorColor
            
            add(to: button)
        }
        
        // MARK: Methods
        
        /// Adds the selection indicator to the specified button.
        ///
        /// - Parameter button: The button which the selection indicator should be added to.
        func add(to button: SSButton)
        {
            self.button = button
            
            xConstraint = (inset.sign == .plus ? leadingAnchor : trailingAnchor).constraint(equalTo: inset.sign == .plus ? button.leadingAnchor : button.trailingAnchor, constant: inset)
            yConstraint = centerYAnchor.constraint(equalTo: button.centerYAnchor)
            widthConstraint = widthAnchor.constraint(equalToConstant: size.width)
            heightConstraint = heightAnchor.constraint(equalToConstant: size.height)
            
            widthConstraint.isActive = true
            heightConstraint.isActive = true
            
            button.addSubview(self)
            button.addConstraints([xConstraint, yConstraint])
        }
        
        /// Shows the selection indicator in the specified button, optionally animated.
        ///
        /// - Parameter animated: Indicates whether the selection indicator should be shown animated.
        func show(animated: Bool = true)
        {
            if(animated)
            {
                let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: SSCubicTimingCurve.linear) {
                    self.alpha = 1.0
                }
                
                animator.startAnimation()
            }
            else
            {
                alpha = 1.0
            }
        }
        
        /// Hides the selection indicator in the specified button, optionally animated.
        ///
        /// - Parameter animated: Indicates whether the selection indicator should be hidden animated.
        func hide(animated: Bool = true)
        {
            if(animated)
            {
                let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: SSCubicTimingCurve.linear) {
                    self.alpha = 0.0
                }
                
                animator.startAnimation()
            }
            else
            {
                alpha = 0.0
            }
        }
    }
}



// MARK: -
// MARK: -

/// A button which behaves like a basic table view cell (aka a table view cell with a single label and an optional accessory).
@IBDesignable
class SSCellButton: SSButton
{
    // MARK: Inspectables
    
    /// A boolean which indicates whether the selection indicator should always be displayed in the button (like an accessory).
    @IBInspectable var indicatorAlwaysVisible: Bool = false
    {
        didSet
        {
            if(indicatorAlwaysVisible)
            {
                selectionIndicator = SSButton.SelectionIndicator(button: self)
                selectionIndicator?.show()
            }
            else
            {
                selectionIndicator?.hide()
            }
        }
    }
    
    // MARK: Inherited methods from: SSButton
    override func updateEnabled()
    {
        if(titleLabel != nil)
        {
            if(isEnabled)
            {
                let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: SSCubicTimingCurve.linear) {
                    self.titleLabel!.alpha = .ssControlStateNormalOpacity
                }
                
                animator.startAnimation()
            }
            else
            {
                let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: SSCubicTimingCurve.linear) {
                    self.titleLabel!.alpha = .ssControlStateDisabledOpacity
                }
                
                animator.startAnimation()
            }
        }
    }
    
    override func updateSelected()
    {
        if(!indicatorAlwaysVisible)
        {
            super.updateSelected()
        }
    }
}

// MARK: -
// MARK: -

/// A button with full image customizability.
class SSImageButton: SSButton
{
    // MARK: Inspectables
    
    /// The space between the image and the title label for the button's "normal" state.
    @IBInspectable private var imageSpacing: CGFloat
    {
        get
        {
            return imageStateConfigurations[.normal].spacing ?? 0.0
        }
        
        set
        {
            imageStateConfigurations[.normal].spacing = newValue
            updateImage()
        }
    }
    
    /// Indicates whether the size of the image for the button's "normal" state uses a fixed aspect ratio.
    @IBInspectable private var imageAspectRatioLock: Bool
    {
        get
        {
            return imageStateConfigurations[.normal].aspectRatioLock ?? false
        }
        
        set
        {
            imageStateConfigurations[.normal].aspectRatioLock = newValue
            updateImage()
        }
    }
    
    /// The size of the image for the button's "normal" state.
    @IBInspectable private var imageSize: CGSize
    {
        get
        {
            return imageStateConfigurations[.normal].size ?? CGSize.zero
        }
        
        set
        {
            imageStateConfigurations[.normal].size = newValue
            updateImage()
        }
    }
    
    /// The color of the image for the button's "normal" state.
    @IBInspectable private var imageColor: UIColor
    {
        get
        {
            return imageStateConfigurations[.normal].color ?? UIColor.clear
        }
        
        set
        {
            imageStateConfigurations[.normal].color = newValue
            updateImage()
        }
    }
    
    /// The space between the image and the title label for the button's "highlighted" state.
    @IBInspectable private var hiSpacing: CGFloat
    {
        get
        {
            return imageStateConfigurations[.highlighted].spacing ?? 0.0
        }
        
        set
        {
            imageStateConfigurations[.highlighted].spacing = newValue
            updateImage()
        }
    }
    
    /// Indicates whether the size of the image for the button's "highlighted" state uses a fixed aspect ratio.
    @IBInspectable private var hiImageAspectRatioLock: Bool
    {
        get
        {
            return imageStateConfigurations[.highlighted].aspectRatioLock ?? false
        }
        
        set
        {
            imageStateConfigurations[.highlighted].aspectRatioLock = newValue
            updateImage()
        }
    }
    
    /// The size of the image for the button's "highlighted" state.
    @IBInspectable private var hiImageSize: CGSize
    {
        get
        {
            return imageStateConfigurations[.highlighted].size ?? CGSize.zero
        }
        
        set
        {
            imageStateConfigurations[.highlighted].size = newValue
            updateImage()
        }
    }
    
    /// The color of the image for the button's "highlighted" state.
    @IBInspectable private var hiImageColor: UIColor
    {
        get
        {
            return imageStateConfigurations[.highlighted].color ?? UIColor.clear
        }
        
        set
        {
            imageStateConfigurations[.highlighted].color = newValue
            updateImage()
        }
    }
    
    /// The space between the image and the title label for the button's "selected" state.
    @IBInspectable private var selSpacing: CGFloat
    {
        get
        {
            return imageStateConfigurations[.selected].spacing ?? 0.0
        }
        
        set
        {
            imageStateConfigurations[.selected].spacing = newValue
            updateImage()
        }
    }
    
    /// Indicates whether the size of the image for the button's "selected" state uses a fixed aspect ratio.
    @IBInspectable private var selImageAspectRatioLock: Bool
    {
        get
        {
            return imageStateConfigurations[.selected].aspectRatioLock ?? false
        }
        
        set
        {
            imageStateConfigurations[.selected].aspectRatioLock = newValue
            updateImage()
        }
    }
    
    /// The size of the image for the button's "selected" state.
    @IBInspectable private var selImageSize: CGSize
    {
        get
        {
            return imageStateConfigurations[.selected].size ?? CGSize.zero
        }
        
        set
        {
            imageStateConfigurations[.selected].size = newValue
            updateImage()
        }
    }
    
    /// The color of the image for the button's "selected" state.
    @IBInspectable private var selImageColor: UIColor
    {
        get
        {
            return imageStateConfigurations[.selected].color ?? UIColor.clear
        }
        
        set
        {
            imageStateConfigurations[.selected].color = newValue
            updateImage()
        }
    }
    
    /// The space between the image and the title label for the button's "disabled" state.
    @IBInspectable private var disSpacing: CGFloat
    {
        get
        {
            return imageStateConfigurations[.disabled].spacing ?? 0.0
        }
        
        set
        {
            imageStateConfigurations[.disabled].spacing = newValue
            updateImage()
        }
    }
    
    /// Indicates whether the size of the image for the button's "disabled" state uses a fixed aspect ratio.
    @IBInspectable private var disImageAspectRatioLock: Bool
    {
        get
        {
            return imageStateConfigurations[.disabled].aspectRatioLock ?? false
        }
        
        set
        {
            imageStateConfigurations[.disabled].aspectRatioLock = newValue
            updateImage()
        }
    }
    
    /// The size of the image for the button's "disabled" state.
    @IBInspectable private var disImageSize: CGSize
    {
        get
        {
            return imageStateConfigurations[.disabled].size ?? CGSize.zero
        }
        
        set
        {
            imageStateConfigurations[.disabled].size = newValue
            updateImage()
        }
    }
    
    /// The color of the image for the button's "disabled" state.
    @IBInspectable private var disImageColor: UIColor
    {
        get
        {
            return imageStateConfigurations[.disabled].color ?? UIColor.clear
        }
        
        set
        {
            imageStateConfigurations[.disabled].color = newValue
            updateImage()
        }
    }
    
    // MARK: Inherited properties from: SSButton
    override var intrinsicContentSize: CGSize
    {
        return unalignedImageRect(forContentRect: contentRect(forBounds: bounds)).size + CGSize(width: self.imageSpacing(for: state), height: 0.0) + unalignedTitleRect(forContentRect: contentRect(forBounds: bounds)).size
    }
    
    override var adjustsImageWhenHighlighted: Bool
    {
        get
        {
            return false
        }
        
        set {}
    }
    
    override var adjustsImageWhenDisabled: Bool
    {
        get
        {
            return false
        }
        
        set {}
    }
    
    // MARK: Properties
    
    /// The configurations of the button's image for each of the button's control states.
    internal var imageStateConfigurations: [ImageStateConfiguration] = [ImageStateConfiguration](for: .normal, .highlighted, .selected, .disabled)
    
    /// Returns the size of the current title, in points, without the specified title insets.
    private var currentTitleSize: CGSize?
    {
        return titleRect(forContentRect: self.contentRect(forBounds: bounds)).size
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        updateImage()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        updateImage()
    }
    
    // MARK: - Inherited methods from: SSButton
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect
    {
        // Define the unaligned frames
        let unalignedImageRect: CGRect = self.unalignedImageRect(forContentRect: contentRect)
        
        // Define the result
        var result: CGRect = unalignedImageRect
        
        switch contentHorizontalAlignment
        {
        case .right, .trailing:
            if(contentHorizontalAlignment == .right || (contentHorizontalAlignment == .trailing && isLeftToRight))
            {
                result.origin.x += contentRect.width - intrinsicContentSize.width
            }
            break
            
        case .center:
            result.origin.x += (contentRect.width - intrinsicContentSize.width) / 2
            break
            
        default:
            break
        }
        
        switch contentVerticalAlignment
        {
        case .center:
            result.origin.y += (contentRect.height - result.height) / 2
            break
            
        default:
            break
        }
        
        result.origin.x += contentRect.origin.x
        result.origin.y += contentRect.origin.y
        return result
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect
    {
        var result: CGRect = super.titleRect(forContentRect: contentRect)
        var currentTitle: String?
        
        if(self.currentTitle != nil)
        {
            currentTitle = self.currentTitle
        }
        else if(currentAttributedTitle != nil)
        {
            currentTitle = currentAttributedTitle!.string
        }
        
        if(result.size != .zero && titleLabel != nil && currentTitle != nil)
        {
            let imageSpacing: CGFloat = self.imageSpacing(for: state)
            
            let unalignedImageRect: CGRect = self.unalignedImageRect(forContentRect: contentRect)
            result = self.unalignedTitleRect(forContentRect: contentRect)
            
            switch contentHorizontalAlignment
            {
            case .left, .leading, .right, .trailing:
                if(contentHorizontalAlignment == .left || (contentHorizontalAlignment == .leading && isLeftToRight))
                {
                    result.origin.x = unalignedImageRect.maxX + imageSpacing
                }
                else
                {
                    result.origin.x += unalignedImageRect.maxX + contentRect.width - intrinsicContentSize.width + imageSpacing
                }
                break
                
            case .center:
                result.origin.x += unalignedImageRect.maxX + (contentRect.width - intrinsicContentSize.width) / 2 + imageSpacing
                break
                
            case .fill:
                result.origin.x = unalignedImageRect.maxX + imageSpacing
                result.size.width = contentRect.width - result.origin.x
                break
            }
            
            switch contentVerticalAlignment
            {
            case .center:
                result.origin.y += (contentRect.height - result.height) / 2
                break
                
            default:
                break
            }
            
            result.origin.x += contentRect.origin.x
            result.origin.y += contentRect.origin.y
        }
        
        return result
    }
    
    override func updateEnabled()
    {
        super.updateEnabled()
        updateImage()
    }
    
    override func updateHighlighted(drag: Bool)
    {
        super.updateHighlighted(drag: drag)
        updateImage()
    }
    
    override func updateSelected()
    {
        super.updateSelected()
        updateImage()
    }
    
    // MARK: Methods
    
    /// Retrieves the size of the button's image for the given control state.
    ///
    /// If there was no size speicified for the given control state, the method will use the image's size for the button's "normal" state.
    ///
    /// - Parameter controlState: The control state for which the color of the button's image should be retrieved.
    /// - Returns: The size of the button's image for the given control state or for the "normal" state (if there was no color specified for the given control state).
    func imageSize(for controlState: UIControlState) -> CGSize
    {
        // Define the result
        var result: CGSize = .zero
        
        // Define the configurations and the image's image
        let configuration: ImageStateConfiguration = imageStateConfigurations[controlState]
        let normalConfiguration: ImageStateConfiguration = imageStateConfigurations[.normal]
        let image: UIImage? = self.image(for: controlState) ?? self.image(for: .normal)
        
        // Attempt to calculate the size if there is a valid image
        if(image != nil)
        {
            // Define the key properties to the image's size
            var aspectRatioLock: Bool = false
            var width: CGFloat = image!.size.width
            var height: CGFloat = image!.size.height
            
            if(configuration.size != nil)
            {
                // Retrieve the key properties if the configuration for the given control state has a valid size specified
                width = configuration.size!.width
                height = configuration.size!.height
                aspectRatioLock = configuration.aspectRatioLock ?? false
            }
            else if(normalConfiguration.size != nil)
            {
                // Retrieve the key properties from the "normal" configuration if the configuration for the given control state has no valid position speicifed
                width = normalConfiguration.size!.width
                height = normalConfiguration.size!.height
                aspectRatioLock = normalConfiguration.aspectRatioLock ?? false
            }
            
            // Calculate the actual width and height if there is an aspect ratio lock specified
            if(aspectRatioLock)
            {
                if(width > 0 && height > 0)
                {
                    // If both the width and the height is positive, take both of them as absolute components
                    result.width = width
                    result.height = height
                }
                else if(width < 0 && height > 0)
                {
                    // If the width is negative and the height is positive, calculate the width from the absolute height
                    result.height = height
                    result.width = image!.aspectRatio * height
                }
                else if(width > 0 && height < 0)
                {
                    // If the height is negative and the width is positive, calculate the height from the absolute width
                    result.width = width
                    result.height = image!.aspectRatio * width
                }
                else
                {
                    // If both components are negative, use the default size of the image
                    result.width = image!.size.width
                    result.height = image!.size.height
                }
            }
            else
            {
                // If there is no aspect ratio lock specified, take both components absolute
                result.width = width
                result.height = height
            }
        }
        
        return result
    }
    
    /// Retrieves the color of the button's image for the given control state.
    ///
    /// If there was no color speicified for the given control state, the method will use the image's color for the button's "normal" state.
    ///
    /// - Parameter controlState: The control state for which the color of the button's image should be retrieved.
    /// - Returns: The color of the button's image for the given control state or for the "normal" state (if there was no color specified for the given control state).
    func imageColor(for controlState: UIControlState) -> UIColor
    {
        return imageStateConfigurations[controlState].color ?? imageStateConfigurations[.normal].color ?? UIColor.clear
    }
    
    /// Retrieves the spacing between the button's image and title label for the given control state.
    ///
    /// If there was no spacing speicified for the given control state, the method will use the image's spacing for the button's "normal" state.
    ///
    /// - Parameter controlState: The control state for which the spacing between the button's image and title label should be retrieved.
    /// - Returns: The spacing between the button's image and title label for the given control state or for the "normal" state (if there was no spacing specified for the given control state).
    func imageSpacing(for controlState: UIControlState) -> CGFloat
    {
        return imageStateConfigurations[controlState].spacing ?? imageStateConfigurations[.normal].spacing ?? 0.0
    }
    
    /// Updates the button's image based on the current state.
    private func updateImage()
    {
        imageView?.tintImage(with: imageColor(for: state))
        imageView?.frame = imageRect(forContentRect: contentRect(forBounds: bounds))
        titleLabel?.frame = titleRect(forContentRect: contentRect(forBounds: bounds))
    }
    
    /// Calculates the frame of the button's image without respect to the content alignment mode.
    ///
    /// - Parameter contentRect: The content rect for which the frame of the button's image should be caluclated.
    /// - Returns: The frame of the button's image for the given content rectangle.
    private func unalignedImageRect(forContentRect contentRect: CGRect) -> CGRect
    {
        return CGRect(origin: CGPoint(x: imageEdgeInsets.left - imageEdgeInsets.right, y: imageEdgeInsets.top - imageEdgeInsets.bottom), size: imageSize(for: state))
    }
    
    /// Calculates the frame of the button's title without respect to the content alignment mode.
    ///
    /// - Parameter contentRect: The content rect for which the frame of the button's title should be caluclated.
    /// - Returns: The frame of the button's title for the given content rectangle.
    private func unalignedTitleRect(forContentRect contentRect: CGRect) -> CGRect
    {
        return CGRect(origin: CGPoint(x: titleEdgeInsets.left - titleEdgeInsets.right, y: titleEdgeInsets.top - titleEdgeInsets.bottom), size: currentTitle?.size(with: titleLabel!.font, max: contentRect.size) ?? currentAttributedTitle?.string.size(with: titleLabel!.font, max: contentRect.size) ?? .zero)
    }
    
    // MARK: -
    
    /// The configuration of the button's image for a single state.
    class ImageStateConfiguration: Equatable
    {
        // MARK: Properties
        
        /// Indicates whether the size of the image uses a fixed aspect ratio.
        var aspectRatioLock: Bool?
        
        /// The spacing between the image and the button's title label.
        var spacing: CGFloat?
        
        /// The size of the image.
        ///
        /// If you have locked the aspect ratio, you may set either of the coordinates to `-1` to indicate that that coordinate should be calculated from the image's aspect ratio.
        ///
        /// If both coordinates are positive numbers and if aspect ratio lock is specified, the smaller coordinate will be taken as the fix coordinate, and the coordinate calculated from the aspect ratio will be used, instead of the larger one.
        ///
        /// You can lock the aspect ratio by setting "`aspectRatioLock`" to `true`.
        var size: CGSize?
        
        /// The color of the image.
        var color: UIColor?
        
        /// The state of the button which the configuration is bound to.
        var controlState: UIControlState
        
        // MARK: - Initializers
        
        /// Initializes an `SSButton.imageStateConfigurations.imageStateConfiguration` instance out of the given parameters.
        ///
        /// - Parameter controlState: The state of the button which the configuration is bound to.
        init(for controlState: UIControlState)
        {
            self.controlState = controlState
        }
        
        // MARK: Static functions
        static func ==(lhs: SSImageButton.ImageStateConfiguration, rhs: SSImageButton.ImageStateConfiguration) -> Bool
        {
            return lhs.aspectRatioLock == rhs.aspectRatioLock && lhs.spacing == rhs.spacing && lhs.size == rhs.size && lhs.color == rhs.color && lhs.controlState == rhs.controlState
        }
    }
}

// MARK: -
// MARK: -

/// The base class of the application's custom button with specific inspectable layer properties and full customizability.
internal class UICustomButton: UIButton
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
    
    /// A boolean value that indicates whether the receiver handles touch events exclusively.
    @IBInspectable internal var exclusive: Bool = false
    {
        didSet
        {
            isExclusiveTouch = exclusive
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
    
    // MARK: - Inherited initializers from: UIButton
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
    
    /// Prepares the button after it has been initialized.
    private func prepare()
    {
        // Prepare the appearance of the button
        cornerRadius = cornerState == .undefined ? 5.0 : cornerRadius
    }
}
