//
//  SSDefaultAnimations.swift
//  Schedule School
//
//  Created by Máté on 2018. 01. 27.
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

/// Holds property animation types for layers.
struct SSLayerPropertyAnimation
{
    /// Animates a property of a single or multiple layers with a starting and a final value.
    class Basic<PropertyType>: SSAnimation
    {        
        // MARK: Implemented properties from: SSLayerPropertyAnimation
        var duration: TimeInterval
        {
            didSet
            {
                updateDuration()
            }
        }
        
        var delay: TimeInterval?
        {
            didSet
            {
                updateAnimation()
            }
        }
        
        var timingCurve: SSCubicTimingCurve?
        {
            didSet
            {
                updateTimingCurve()
            }
        }
        
        // MARK: Properties
        
        /// The starting value of the animated layer property.
        var fromValue: PropertyType!
        {
            didSet
            {
                updateValues()
            }
        }
        
        /// The final value of the animated layer property.
        var toValue: PropertyType!
        {
            didSet
            {
                updateValues()
            }
        }
        
        /// A boolean which indicates whether the value of `fromValue` and `toValue` should be added to the current value of the animated property.
        var isAdditive: Bool
        {
            didSet
            {
                representedAnimation.isAdditive = isAdditive
            }
        }
        
        /// The layer(s) on which the animation is performed.
        var layers: [CALayer]
        
        /// The propety of the layer(s) whose change is animated.
        var property: SSAnimatableProperty<PropertyType>!
        {
            didSet
            {
                representedAnimation.keyPath = property.toString()
            }
        }
        
        /// Indicates whether the animation has a delay.
        internal var hasDelay: Bool
        {
            return delay != nil && delay! > 0.0
        }
        
        /// The represented `CAKeyframeAnimation`.
        internal var representedAnimation: CAKeyframeAnimation
        {
            didSet
            {
                representedAnimation.keyPath = property.toString()
            }
        }
        
        // MARK: - Initializers
        
        /// Initializes an `SSLayerPropertyAnimation.Basic` object out of the given parameters.
        ///
        /// - Parameters:
        ///   - layer: The layer on which the animation is executed.
        ///   - property: The propety of the layer whose change is animated.
        convenience init(layer: CALayer, property: SSAnimatableProperty<PropertyType>)
        {
            self.init(layers: [layer], property: property)
        }
        
        /// Initializes an `SSLayerPropertyAnimation.Basic` object out of the given parameters.
        ///
        /// - Parameters:
        ///   - layers: The layers on which the animation is executed.
        ///   - property: The propety of the layers whose change is animated.
        convenience init(layers: [CALayer], property: SSAnimatableProperty<PropertyType>)
        {
            self.init(layers: layers)
            self.property = property
            
            representedAnimation.keyPath = property.toString()
        }
        
        /// Initializes an `SSLayerPropertyAnimation.Basic` object out of the given parameters.
        ///
        /// __NOTE:__ This initializer should not be used directly; only from convenience intializers.
        ///
        /// - Parameter layers: The layers on which the animation is executed.
        internal init(layers: [CALayer])
        {
            self.layers = layers
            representedAnimation = CAKeyframeAnimation()
            isAdditive = false
            duration = 0.0
        }
        
        // MARK: Implemented methods from: SSAnimation
        func commit()
        {
            if(layers.count > 0)
            {
                for layer in layers
                {
                    layer.add(representedAnimation, forKey: String(arc4random()))
                }
            }
        }
        
        // MARK: Methods
        
        /// Updates the describing properties of the represented `CAKeyframeAnimation`.
        private func updateAnimation()
        {
            updateDuration()
            updateTimingCurve()
            updateValues()
        }
        
        /// Updates the duration of the represented `CAKeyframeAnimation` corresponding to whether the animation is delayed.
        private func updateDuration()
        {
            if(hasDelay)
            {
                let totalDuration = delay! + duration
                representedAnimation.duration = totalDuration
                representedAnimation.keyTimes = [0.0, NSNumber(value: delay! / totalDuration), 1.0]
            }
            else
            {
                representedAnimation.duration = duration
                representedAnimation.keyTimes = [0.0, 1.0]
            }
        }
        
        /// Updates the timing function of the represented `CAKeyframeAnimation` corresponding to whether the animation is delayed.
        private func updateTimingCurve()
        {
            representedAnimation.timingFunctions = hasDelay ? [CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear), timingCurve?.caMediaTimingFunction ?? CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)] : [timingCurve?.caMediaTimingFunction ?? CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)]
        }
        
        /// Updates the starting and final value of the represented `CAKeyframeAnimation` corresponding to whether the animation is delayed.
        private func updateValues()
        {
            representedAnimation.values = hasDelay ? [fromValue, fromValue, toValue] : [fromValue, toValue]
        }
    }
}

// MARK: -
// MARK: -

/// Holds all autoresizing animation types for layers.
struct SSAutoresizingLayerAnimation
{
    /// Resizes a single or multiple layers and their sublayers with a starting and a final size.
    ///
    /// __NOTE:__ A layer draws its contents as a bitmap image. Therefore, expect quality loss when scaling up.
    class Basic: SSLayerPropertyAnimation.Basic<CGSize>
    {
        // MARK: Inherited initializers from: SSLayerPropertyAnimation.Basic
        override init(layers: [CALayer])
        {
            super.init(layers: layers)
            property = SSAnimatableProperties.bounds.size
        }
        
        // MARK: Intializers
        convenience init(layer: CALayer)
        {
            self.init(layers: [layer])
        }
        
        // MARK: Inherited methods from: SSLayerPropertyAnimation.Basic
        override func commit()
        {
            if(layers.count > 0)
            {
                for layer in layers
                {
                    layer.layoutIfNeeded()
                    
                    // Define the required layer properties
                    let layerBoundsSize: CGSize = layer.bounds.size
                    
                    // Define the required size multipliers
                    let multiplierFromValue: CGSize = isAdditive ? (layerBoundsSize + fromValue) / layerBoundsSize : fromValue / layerBoundsSize
                    let multiplierToValue: CGSize = isAdditive ? (layerBoundsSize + toValue) / layerBoundsSize : toValue / layerBoundsSize
                    
                    // Perform the animation on all sublayers of the given layer(s)
                    layer.onAllSublayers({ (sublayer: CALayer) in
                        // Define the required sublayer properties
                        let size: CGSize = sublayer.bounds.size
                        let position: CGPoint = sublayer.position
                        
                        // Define the starting and final values of the sublayer's size
                        let fromSize: CGSize = multiplierFromValue * size
                        let toSize: CGSize = multiplierToValue * size
                        
                        // Define the starting and final values of the sublayer's position
                        let fromPosition: CGPoint = (multiplierFromValue * position.distance).point
                        let toPosition: CGPoint = (multiplierToValue * position.distance).point
                        
                        // Save the contents gravity of the sublayer
                        let sContentsGravity: String = sublayer.contentsGravity
                        
                        // Prepare the resize animation
                        sublayer.contentsGravity = kCAGravityResize
                        
                        representedAnimation.isAdditive = false
                        representedAnimation.values = hasDelay ? [fromSize, fromSize, toSize] : [fromSize, toSize]
                        
                        // Add the resize animation to the sublayer
                        CATransaction.begin()
                        CATransaction.setCompletionBlock({
                            // Restore the contents gravity of the sublayer
                            sublayer.contentsGravity = sContentsGravity
                        })
                        
                        sublayer.add(representedAnimation, forKey: String(arc4random()))
                        
                        // Prepare and add the position offset animation to the sublayer
                        if(sublayer != layer)
                        {
                            representedAnimation.keyPath = SSAnimatableProperties.position.toString()
                            representedAnimation.values = hasDelay ? [fromPosition, fromPosition, toPosition] : [fromPosition, toPosition]
                            sublayer.add(representedAnimation, forKey: String(arc4random()))
                            
                            representedAnimation.keyPath = property.toString()
                        }
                        
                        
                        // Commit the animations
                        CATransaction.commit()
                    })
                }
            }
        }
    }
}

// MARK: - Stackable setter extension (SSLayerPropertyAnimation.Basic)
extension SSLayerPropertyAnimation.Basic
{
    /// Specifies the starting value of the animation.
    ///
    /// - Parameter fromValue: The new value starting value.
    /// - Returns: The class (to enable stackable functions).
    func with(fromValue: PropertyType) -> Self
    {
        self.fromValue = fromValue
        return self
    }
    
    /// Specifies the final value of the animation.
    ///
    /// - Parameter duration: The new value final value.
    /// - Returns: The class itself (to enable stacked functions).
    func with(toValue: PropertyType) -> Self
    {
        self.toValue = toValue
        return self
    }
    
    /// Specifies whether the value of `fromValue` and `toValue` should be added to the current value of the animated property.
    ///
    /// - Parameter isAdditive: The new additive procedure.
    /// - Returns: The class (to enable stackable functions).
    func with(additiveness isAdditive: Bool) -> Self
    {
        self.isAdditive = isAdditive
        return self
    }
    
    /// Adds a layer to the animation.
    ///
    /// - Parameter layers: The layer to be added to the animation.
    /// - Returns: The class (to enable stackable functions).
    func with(additionalLayer layer: CALayer) -> Self
    {
        layers.append(layer)
        return self
    }
    
    /// Adds an array of layers to the animation.
    ///
    /// - Parameter layers: The layers to be added to the animation.
    /// - Returns: The class (to enable stackable functions).
    func with(additionalLayers layers: [CALayer]) -> Self
    {
        self.layers.append(contentsOf: layers)
        return self
    }
    
    /// Specifies the propety of the layer(s) whose change is animated.
    ///
    /// - Parameter property: The new animated property.
    /// - Returns: The class (to enable stackable functions).
    func with(property: SSAnimatableProperty<PropertyType>) -> Self
    {
        self.property = property
        return self
    }
}

// MARK: -
// MARK: -

/// A class which holds some animations executed with the same duration all at once.
class SSSimultaniousAnimations: SSAnimationGroup
{
    // MARK: Implemented properties from: SSAnimationGroup
    var duration: TimeInterval
    var delay: TimeInterval?
    var timingCurve: SSCubicTimingCurve?
    
    internal var animations: [SSAnimation]
    internal var completions: [() -> ()]
    
    // MARK: - Initializers
    
    /// Initializes an `SSSynchronousAnimations` object.
    init()
    {
        animations = [SSAnimation]()
        completions = [() -> ()]()
        
        duration = 0.0
    }
    
    // MARK: Implemented methods from: SSAnimationGroup
    func added(_ animation: SSAnimation) -> Self
    {
        animations.append(animation)
        return self
    }
    
    func appendingCompletion(_ completion: @escaping () -> ()) -> Self
    {
        completions.append(completion)
        return self
    }
    
    func commit()
    {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            for completion in self.completions
            {
                completion()
            }
        }
        
        for animation in animations
        {
            if(animation.duration == 0.0)
            {
                animation.duration = duration
            }
            
            if(animation.delay == nil)
            {
                animation.delay = delay
            }
            
            if(animation.timingCurve == nil)
            {
                animation.timingCurve = timingCurve
            }
            
            animation.commit()
        }
        
        CATransaction.commit()
    }
}

// MARK: -
// MARK: -

/// A class which holds some animations executed consecutively with an optional delay in between.
class SSConsecutiveAnimations: SSAnimationGroup
{
    // MARK: Implemented properties from: SSAnimationGroup
    var duration: TimeInterval
    var delay: TimeInterval?
    var timingCurve: SSCubicTimingCurve?
    
    internal var animations: [SSAnimation]
    internal var completions: [() -> ()]
    
    // MARK: - Initializers
    
    /// Initializes an `SSConsecutiveAnimations` object out of the given parameters.
    ///
    /// - Parameters:
    ///   - duration: The common duration of the animations handled by the class.
    ///   - delay: The delay in between the consecutive animations.
    init(delay: TimeInterval = 0.0)
    {
        self.delay = delay
        
        animations = [SSAnimation]()
        completions = [() -> ()]()
        
        duration = 0.0
    }
    
    // MARK: Implemented methods from: SSAnimationGroup
    func added(_ animation: SSAnimation) -> Self
    {
        animations.append(animation)
        return self
    }
    
    func appendingCompletion(_ completion: @escaping () -> ()) -> Self
    {
        completions.append(completion)
        return self
    }
    
    func commit()
    {
        var totalDuration: TimeInterval = 0.0
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            for completion in self.completions
            {
                completion()
            }
        }
        
        for (i, animation) in animations.enumerated()
        {
            if(animation.duration == 0.0)
            {
                animation.duration = duration
            }
            
            if(delay != nil && delay! > 0.0)
            {
                animation.delay = animation.delay == nil ? TimeInterval(i) * delay! : animation.delay! + TimeInterval(i) * delay!
            }
            else if(delay != nil && delay! <= 0.0)
            {
                animation.delay = animation.delay == nil ? totalDuration : animation.delay! + totalDuration
                totalDuration += animation.duration
            }
            
            if(animation.timingCurve == nil)
            {
                animation.timingCurve = timingCurve
            }
            
            animation.commit()
        }
        
        CATransaction.commit()
    }
}
