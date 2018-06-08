//
//  SSAnimation.swift
//  Schedule School
//
//  Created by Máté on 2017. 12. 31..
//  Copyright © 2017. theMatys. All rights reserved.
//

import QuartzCore

/// The abstract animation protocol.
///
/// All custom animations (using the `SSAnimation` framework) must implement this protocol to qualify as executable animations.
///
/// __Stackable setter extension:__
///
/// For quicker declaration, it is advised to make a stackable setter extension to your custom implementer class. A stackable setter extension should contain setter functions for your custom propreties. The name of a setter function should be __"with"__ and the __first argument label__ should have __the name of your custom property__. The function should also __return the implementer class (Self)__ so that the setter functions can be stacked when declaring. For example:
///
///     class CustomAnimation: SSAnimation
///     {
///         ...
///         var customProperty1: Any
///         var customProperty2: Any
///         ...
///     }
///
///     extension CustomAnimation
///     {
///         func with(customProperty1: Any) -> Self
///         {
///             self.customProperty1 = customProperty1
///             return self
///         }
///
///         func with(customProperty2: Any) -> Self
///         {
///             self.customProperty2 = customProperty2
///             return self
///         }
///     }
///
/// Where declaration looks like:
///
///     let customAnimation: CustomAnimation = CustomAnimation().with(customProperty1: ...).with(customProperty2: ...)
protocol SSAnimation: AnyObject
{
    // MARK: Properties
    
    /// The duration of the animation (in seconds).
    ///
    /// Its value defaults to `0`.
    var duration: TimeInterval { get set }
    
    /// The amount of time (in seconds) which ellapses before the animation is performed.
    ///
    /// Its value defaults to `0`.
    var delay: TimeInterval? { get set }
    
    /// The timing curve which defines the pacing of the animation.
    ///
    /// Its value defaults to the linear timing function.
    var timingCurve: SSCubicTimingCurve? { get set }
    
    // MARK: - Methods
    
    /// Commits the animation with the specified duration, delay, media timing function and other properties implementing classes may add.
    func commit()
}

// MARK: - Stackable setter extension: SSAnimation
extension SSAnimation
{
    /// Specifies the duration (in seconds) to be used for the animation.
    ///
    /// - Parameter duration: The new duration.
    /// - Returns: The class (to enable stackable functions).
    func with(duration: TimeInterval) -> Self
    {
        self.duration = duration
        return self
    }
    
    /// Specifies the amount of time (in seconds) to ellapse before the animation is performed.
    ///
    /// - Parameter delay: The new delay.
    /// - Returns: The class (to enable stackable functions).
    func with(delay: TimeInterval) -> Self
    {
        self.delay = delay
        return self
    }
    
    /// Specifies the timing curve to be used to define the pacing of the animation.
    ///
    /// - Parameter timingCurve: The new timing curve.
    /// - Returns: The class (to enable stackable functions).
    func with(timingCurve: SSCubicTimingCurve) -> Self
    {
        self.timingCurve = timingCurve
        return self
    }
}

// MARK: -
// MARK: -

/// The class which generifies the independent properties of an animation, forming a template, from which animations can be instantiated with only the dependent properties, as the independent (generified) ones are copied over automatically.
///
/// The independent (generified) properties are the __duration__, the __delay__ and the __media timing function.__
class SSAnimationTemplate
{
    // MARK: Properties
    
    /// The duration of the animations created from the template (in seconds).
    ///
    /// If nil, instantiated animations will use the default (0.0) or an explicitly specified duration.
    var duration: TimeInterval?
    
    /// The amount of time (in seconds) which ellapses before animations (created from the template) are performed.
    ///
    /// If nil, instantiated animations will use the default (0.0) or an explicitly specified delay.
    var delay: TimeInterval?
    
    /// The timing curve which defines the pacing of animations created from the template.
    ///
    /// If nil, instantiated animations will use the default (linear) or an explicitly specified timing curve.
    var timingCurve: SSCubicTimingCurve?
    
    // MARK: - Methods
    
    /// Applies the template to an animation.
    ///
    /// - Parameter animation: The base animation object which the template will be applied to.
    /// - Returns: The specified animation object with the template applied.
    func applied<AnimationType: SSAnimation>(to animation: AnimationType) -> AnimationType
    {
        if(animation.duration == 0.0)
        {
            animation.duration = duration ?? 0.0
        }
        
        if(animation.delay == nil)
        {
            animation.delay = delay
        }
        
        if(animation.timingCurve == nil)
        {
            animation.timingCurve = timingCurve
        }
        
        return animation
    }
}

// MARK: - Stackable setter extension: SSAnimationTemplate
extension SSAnimationTemplate
{
    /// Specifies the duration (in seconds) to be used for animations created from the template.
    ///
    /// - Parameter duration: The new duration.
    /// - Returns: The class (to enable stackable functions).
    func with(duration: TimeInterval) -> Self
    {
        self.duration = duration
        return self
    }
    
    /// Specifies the amount of time (in seconds) to ellapse before animations (created from the template) are performed.
    ///
    /// - Parameter delay: The new delay.
    /// - Returns: The class (to enable stackable functions).
    func with(delay: TimeInterval) -> Self
    {
        self.delay = delay
        return self
    }
    
    /// Specifies the timing curve to be used to define the pacing of animations created from the template.
    ///
    /// - Parameter timingCurve: The new timing curve.
    /// - Returns: The class (to enable stackable functions).
    func with(timingCurve: SSCubicTimingCurve) -> Self
    {
        self.timingCurve = timingCurve
        return self
    }
}

// MARK: -
// MARK: -

typealias SSAnimatableProperties = SSAnimatableProperty<Any>

/// The class which represents an animatable property of a layer.
class SSAnimatableProperty<PropertyType>
{
    /// The string representation of the property's name.
    private var name: String
    
    /// The variant of the property.
    ///
    /// In case the property is a `CGPoint`, possible variants are __x__ and __y.__
    ///
    /// In case the property is a `CGSize`, possible variants are __width__ and __height.__
    ///
    /// In case the property is a `CGRect`, possible variants are __origin__ and __size.__
    private var variant: String?
    
    /// Initializes an `SSAnimatableProperty` object out of the given parameters.
    ///
    /// - Parameters:
    ///   - name: The string representation of the property's name.
    ///   - variant: The variant of the property.
    init(name: String, variant: String? = nil)
    {
        self.name = name
        self.variant = variant
    }
    
    /// Creates a string representation of the animatable property with the variant applied.
    ///
    /// - Returns: The string representation of the animatable property with the variant applied.
    func toString() -> String
    {
        return variant == nil ? name : name + "." + variant!
    }
}

// MARK: - Variant convenience extension (SSAnimatableProperty)
extension SSAnimatableProperty
{
    /// Returns the __x__ variant of the current property.
    var x: SSAnimatableProperty<CGFloat>
    {
        get
        {
            return SSAnimatableProperty<CGFloat>(name: toString(), variant: "x")
        }
    }
    
    /// Returns the __y__ variant of the current property.
    var y: SSAnimatableProperty<CGFloat>
    {
        get
        {
            return SSAnimatableProperty<CGFloat>(name: toString(), variant: "y")
        }
    }
    
    /// Returns the __width__ variant of the current property.
    var height: SSAnimatableProperty<CGFloat>
    {
        get
        {
            return SSAnimatableProperty<CGFloat>(name: toString(), variant: "width")
        }
    }
    
    /// Returns the __height__ variant of the current property.
    var width: SSAnimatableProperty<CGFloat>
    {
        get
        {
            return SSAnimatableProperty<CGFloat>(name: toString(), variant: "height")
        }
    }
    
    /// Returns the __origin__ variant of the current property.
    var origin: SSAnimatableProperty<CGPoint>
    {
        get
        {
            return SSAnimatableProperty<CGPoint>(name: toString(), variant: "origin")
        }
    }
    
    /// Returns the __size__ variant of the current property.
    var size: SSAnimatableProperty<CGSize>
    {
        get
        {
            return SSAnimatableProperty<CGSize>(name: toString(), variant: "size")
        }
    }
}

// MARK: - Default animatable properties extension (SSAnimatableProperty)
extension SSAnimatableProperty
{
    static var anchorPoint:         SSAnimatableProperty<CGPoint>       { return SSAnimatableProperty<CGPoint>(name: "anchorPoint")             }
    static var backgroundColor:     SSAnimatableProperty<CGColor?>      { return SSAnimatableProperty<CGColor?>(name: "backgroundColor")        }
    static var backgroundFilters:   SSAnimatableProperty<[Any]?>        { return SSAnimatableProperty<[Any]?>(name: "backgroundFilters")        }
    static var borderColor:         SSAnimatableProperty<CGColor?>      { return SSAnimatableProperty<CGColor?>(name: "borderColor")            }
    static var borderWidth:         SSAnimatableProperty<CGFloat>       { return SSAnimatableProperty<CGFloat>(name: "borderWidth")             }
    static var bounds:              SSAnimatableProperty<CGRect>        { return SSAnimatableProperty<CGRect>(name: "bounds")                   }
    static var compositingFilter:   SSAnimatableProperty<Any?>          { return SSAnimatableProperty<Any?>(name: "compositingFilter")          }
    static var contents:            SSAnimatableProperty<Any?>          { return SSAnimatableProperty<Any?>(name: "contents")                   }
    static var contentsRect:        SSAnimatableProperty<CGRect>        { return SSAnimatableProperty<CGRect>(name: "contentsRect")             }
    static var cornerRadius:        SSAnimatableProperty<CGFloat>       { return SSAnimatableProperty<CGFloat>(name: "cornerRadius")            }
    static var doubleSided:         SSAnimatableProperty<Bool>          { return SSAnimatableProperty<Bool>(name: "doubleSided")                }
    static var filters:             SSAnimatableProperty<[Any]?>        { return SSAnimatableProperty<[Any]?>(name: "filters")                  }
    static var hidden:              SSAnimatableProperty<Bool>          { return SSAnimatableProperty<Bool>(name: "hidden")                     }
    static var mask:                SSAnimatableProperty<CALayer?>      { return SSAnimatableProperty<CALayer?>(name: "mask")                   }
    static var masksToBounds:       SSAnimatableProperty<Bool>          { return SSAnimatableProperty<Bool>(name: "masksToBounds")              }
    static var opacity:             SSAnimatableProperty<Float>         { return SSAnimatableProperty<Float>(name: "opacity")                   }
    static var position:            SSAnimatableProperty<CGPoint>       { return SSAnimatableProperty<CGPoint>(name: "position")                }
    static var shadowColor:         SSAnimatableProperty<CGColor?>      { return SSAnimatableProperty<CGColor?>(name: "shadowColor")            }
    static var shadowOffset:        SSAnimatableProperty<CGSize>        { return SSAnimatableProperty<CGSize>(name: "shadowOffset")             }
    static var shadowOpacity:       SSAnimatableProperty<CGFloat>       { return SSAnimatableProperty<CGFloat>(name: "shadowOpacity")           }
    static var shadowPath:          SSAnimatableProperty<CGPath?>       { return SSAnimatableProperty<CGPath?>(name: "shadowPath")              }
    static var shadowRadius:        SSAnimatableProperty<CGFloat>       { return SSAnimatableProperty<CGFloat>(name: "shadowRadius")            }
    static var sublayers:           SSAnimatableProperty<[CALayer]?>    { return SSAnimatableProperty<[CALayer]?>(name: "sublayers")            }
    static var sublayerTransform:   SSAnimatableProperty<CATransform3D> { return SSAnimatableProperty<CATransform3D>(name: "sublayerTransform") }
    static var transform:           SSAnimatableProperty<CATransform3D> { return SSAnimatableProperty<CATransform3D>(name: "transform")         }
    static var zPosition:           SSAnimatableProperty<CGFloat>       { return SSAnimatableProperty<CGFloat>(name: "zPosition")               }
}

/// The protocol which all animation holder classes should implement.
protocol SSAnimationGroup: SSAnimation
{
    // MARK: Properties
    
    /// The animations in the current animation group.
    var animations: [SSAnimation] { get set }
    
    /// The set of actions which should be executed after all the animations have finished.
    var completions: [() -> ()] { get set }
    
    // MARK: - Methods
    
    /// Adds an animation to the current animation group.
    ///
    /// - Returns: The class (to enable stackable functions).
    func added(_ animation: SSAnimation) -> Self
    
    /// Defines a set of actions that should be executed after all the animations have finished.
    ///
    /// This function should go at the end of the function stack, before committing the animations.
    ///
    /// - Returns: The class (to enable stackable functions).
    func appendingCompletion(_ completion: @escaping () -> ()) -> Self
}
