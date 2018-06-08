//
//  SSFLSwipeInformerView.swift
//  ScheduleSchool
//
//  Created by Máté on 2018. 05. 24..
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

/// A view which informs about a swipe which either begins a sequence of other swipes, or it forwards the user to the next scene. Mainly used in the first launch setup.
@IBDesignable
@objc class SSFLSwipeInformerView: UIView
{
    // MARK: Inspectables
    
    /// The Interface Builder compatible copy of "`direction`".
    ///
    /// Whenever its value is set, it is clamped and used to create an `SSSwipeInfoView.Direction` instance.
    @IBInspectable internal var ibDirection: Int = 1
    {
        didSet
        {
            direction = Direction(rawValue: (ibDirection <?> (1, Direction.count)) - 1)!
        }
    }
    
    /// The Interface Builder compatible copy of "`alignment`".
    ///
    /// Whenever its value is set, it is clamped and used to create an `SSSwipeInfoView.Alignment` instance.
    @IBInspectable internal var ibAlignment: Int = 1
    {
        didSet
        {
            alignment = Alignment(rawValue: (ibAlignment <?> (1, Alignment.count)) - 1)!
        }
    }
    
    /// Indicates whether the view is collapsed (only shows the arrow and the text is hidden).
    @IBInspectable var collapsed: Bool
    {
        get
        {
            return _collapsed
        }
        
        set
        {
            setCollapsed(newValue, animated: false)
        }
    }
    
    /// Indicates whether the view informs about a swipe which begins a sequence of swipes (e.g the "Welcome" scene in first launch).
    @IBInspectable var informsBeginning: Bool = false
    {
        didSet
        {
            updateDirection()
        }
    }
    
    /// The color of the arrow and the label's text which inform about the swipe.
    @IBInspectable var color: UIColor = UIColor.white
    {
        didSet
        {
            arrow.tintColor = color
            label.textColor = color
        }
    }
    
    // MARK: Properties
    
    /// The direction of the swipe that the view informs about.
    ///
    /// For further details on the directions, see: `SSFLSwipeInformerView.Direction`.
    var direction: Direction = .up
    {
        didSet
        {
            updateDirection(oldValue: oldValue)
        }
    }
    
    /// The alignment of the view's contents.
    ///
    /// For further details on the possible alignments, see: `SSFLSwipeInformerView.Alignment`.
    var alignment: Alignment = .leading
    {
        didSet
        {
            updateAlignment()
        }
    }
    
    /// The arrow which represents the direction of the swipe that the view informs about.
    private var arrow: SSImageView!
    
    /// The label which informs about the swipe.
    private var label: UILabel!
    
    /// The constraint of the leading anchor of "`arrow`".
    private var arrowLeading: NSLayoutConstraint!
    
    /// The constraint of the trailing anchor of "`arrow`".
    private var arrowTrailing: NSLayoutConstraint!
    
    /// The constraint of the y cetner anchor of "`arrow`".
    private var arrowCenterY: NSLayoutConstraint!
    
    /// The constraint of the leading anchor of "`label`".
    private var labelLeading: NSLayoutConstraint!
    
    /// The constraint of the trailing anchor of "`label`".
    private var labelTrailing: NSLayoutConstraint!
    
    /// The constraint of the width of "`label`".
    private var labelWidth: NSLayoutConstraint!
    
    /// Indicates whether the animation of the arrow should replay itself after it has been finished.
    private var shouldContinueAnimation: Bool = true
    
    private var animator: SSRepeatingViewPropertyAnimator!
    
    // INTERNAL VALUES //
    
    /// The internal value of the boolean which indicates whether the view is collapsed (only shows the arrow and the text is hidden).
    private var _collapsed: Bool = false
    
    // MARK: - Inherited initializers from: UIStackView
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
    
    /// Sets the value of "`collapsed`", optionally animated.
    ///
    /// - Parameters:
    ///   - collapsed: The new value of `collapsed`.
    ///   - animated: Indicates whether the change to `collapsed` should be animated.
    func setCollapsed(_ collapsed: Bool, animated: Bool)
    {
        // Update the value
        _collapsed = collapsed
        
        // Update the constraints
        updateDirection(oldValue: direction == .right ? .left : .right)
        
        // Hide/show the label according to the new value
        label.isHidden = collapsed
    }
    
    func startAnimation(afterDelay delay: TimeInterval? = nil)
    {
        animator = SSRepeatingViewPropertyAnimator(duration: 0.25, curve: .ssEaseInOUT) {
            self.arrowCenterY.constant = 5.0
            self.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
    
    func stopAnimation()
    {
        shouldContinueAnimation = false
    }
    
    /// Prepares the arrow and the label which inform about the swipe.
    private func prepare()
    {
        // Initialize the arrow and the label
        arrow = SSImageView(image: UIImage(named: "ss_glyph_arrow_rect_base_1.5", in: Bundle(for: type(of: self)), compatibleWith: traitCollection))
        label = UILabel(frame: .zero)
        
        // Set up the stack view
        addSubview(arrow)
        addSubview(label)
        
        // Set up the arrow
        arrow.template = true
        arrow.tintColor = color
        
        arrow.translatesAutoresizingMaskIntoConstraints = false
        
        arrow.heightAnchor.constraint(equalTo: arrow.widthAnchor, multiplier: arrow.image!.size.height / arrow.image!.size.width).isActive = true
        arrow.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        arrowCenterY = arrow.centerYAnchor.constraint(equalTo: centerYAnchor); arrowCenterY.isActive = true
        
        arrow.layoutIfNeeded()
        
        // Set up the view's height
        heightAnchor.constraint(equalToConstant: arrow.frame.width).isActive = true
        
        // Set up the label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        labelWidth = label.widthAnchor.constraint(equalToConstant: 0.0)
        label.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        // Set up the arrow rotation and the label text, along with the constraints
        // The alignment is automatically set up by the "updateDirection(oldValue:)" method
        updateDirection(oldValue: direction == .right ? .left : .right)
    }
    
    /// Updates the arrow's direction/rotation along with the text which informs about the swipe.
    ///
    /// - Parameter oldValue: The old value of "`direction`".
    private func updateDirection(oldValue: Direction? = nil)
    {
        // Set up the arrow's rotation and the label's text
        switch direction
        {
        case .up:
            // In case "up", the arrow is rotated 90 degrees counter-clockwise
            arrow.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 2))
            
            // Display the corresponding text
            if(informsBeginning)
            {
                // If the informer is set to inform about a swipe which begins another sequence of swipes, set the text accordingly
                label.text = NSLocalizedString(String.LocalizationKeys.swipeInformerUpBegin, tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: "")
            }
            else
            {
                label.text = NSLocalizedString(String.LocalizationKeys.swipeInformerUp, tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: "")
            }
            break
            
        case .down:
            // In case "down", the arrow is rotated 90 degrees clockwise
            arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            
            // Display the corresponding text
            label.text = NSLocalizedString(String.LocalizationKeys.swipeInformerDown, tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: "")
            break
            
        case .left:
            // In case "left", the arrow is rotated 180 degrees counter-clockwise
            arrow.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi))
            
            // Display the corresponding text
            label.text = NSLocalizedString(String.LocalizationKeys.swipeInformerLeft, tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: "")
            break
            
        case .right:
            // In case "right", the arrow is not rotated, because the arrow points in the "right" direction by default
            arrow.transform = .identity
            
            // Display the corresponding text
            label.text = NSLocalizedString(String.LocalizationKeys.swipeInformerRight, tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: "")
            break
        }

        // Upate the label's width constraint according to the new text
        labelWidth.constant = label.intrinsicContentSize.width
        
        // Update the leading and trailing constraints if the function was called, because the direction has changed.
        // NOTE: The method may also be called if "informsBeginning" is modified, however in this case, the leading and trailing constraints do not need to be updated
        if(oldValue != nil)
        {
            if(collapsed)
            {
                // If the view is collapsed, set up only the arrow's constraints
                arrowLeading?.isActive = false; arrowLeading = arrow.leadingAnchor.constraint(equalTo: leadingAnchor)
                arrowTrailing?.isActive = false; arrowTrailing = arrow.trailingAnchor.constraint(equalTo: trailingAnchor)
            }
            else
            {
                if(direction == .right && oldValue != .right)
                {
                    // Swap the arrow and the text, if the desired direction is "right"
                    arrowLeading?.isActive = false; arrowLeading = arrow.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8.0)
                    arrowTrailing?.isActive = false; arrowTrailing = arrow.trailingAnchor.constraint(equalTo: trailingAnchor)
                    labelLeading?.isActive = false; labelLeading = label.leadingAnchor.constraint(equalTo: leadingAnchor)
                    labelTrailing?.isActive = false; labelTrailing = label.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: -8.0)
                }
                else if(oldValue == .right)
                {
                    // Swap the arrow and the text back, if the previous direction was "right" and the new one is not "right"
                    arrowLeading?.isActive = false; arrowLeading = arrow.leadingAnchor.constraint(equalTo: leadingAnchor)
                    arrowTrailing?.isActive = false;arrowTrailing = arrow.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -8.0)
                    labelLeading?.isActive = false; labelLeading = label.leadingAnchor.constraint(equalTo: arrow.trailingAnchor, constant: 8.0)
                    labelTrailing?.isActive = false; labelTrailing = label.trailingAnchor.constraint(equalTo: trailingAnchor)
                }
            }
            
            // Apply the changes
            updateAlignment()
        }
    }
    
    /// Updates the aligment of the arrow and the label inside the view.
    private func updateAlignment()
    {
        switch alignment
        {
        case .leading:
            labelTrailing.isActive = false; arrowTrailing.isActive = false
            labelLeading.isActive = !collapsed; arrowLeading.isActive = true
            break
            
        case .trailing:
            labelLeading.isActive = false; arrowLeading.isActive = false
            labelTrailing.isActive = !collapsed; arrowTrailing.isActive = true
            break
        }
        
        labelWidth.isActive = true
    }
    
    // MARK: -
    
    /// The possible directions of the swipe that the view informs about.
    enum Direction: Int
    {
        /// In case "`up`", an up-pointing arrow will be displayed, along with an according label.
        case up
        
        /// In case "`down`", a down-pointing arrow will be displayed, along with an according label.
        case down
        
        /// In case "`left`", a left-pointing arrow will be displayed, along with an according label.
        case left
        
        /// In case "`right`", a right-pointing arrow will be displayed, along with an according label.
        case right
        
        /// The total number of cases in this enumeration.
        static var count: Int
        {
            return right.hashValue + 1
        }
    }
    
    /// The possible alignments of the view's contents.
    enum Alignment: Int
    {
        /// In case "`leading`", the contents of the view are aligned to its leading anchor.
        case leading
        
        /// In case "`trailing`", the contents of the view are aligned to its trailing anchor.
        case trailing
        
        /// The total number of cases in this enumeration.
        static var count: Int
        {
            return trailing.hashValue + 1
        }
    }
}
