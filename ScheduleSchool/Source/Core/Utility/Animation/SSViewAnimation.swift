//
//  SSViewAnimation.swift
//  ScheduleSchool
//
//  Created by Máté on 2018. 05. 20.
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

/// A custom view property animator which executes a set of animations on a given array of views, giving each one of them a specific delay.
class SSDelayedViewPropertyAnimator: UIViewPropertyAnimator
{
    // MARK: Properties
    
    /// The views on which the given animations should be executed individually.
    var views: [UIView] = [UIView]()
    
    /// The duration of the individual animations, in seconds.
    var individualDuration: TimeInterval = 0.0
    
    /// The delay which defines the time that should ellapse between the execution of one individual animation and another.
    ///
    /// The actual delay for the individual animations on a view is proportional with the index of the view in the "`views`" array.
    var individualDelay: CGFloat = 0.0
    
    /// The timing parameters which define the pacing of each individual animation.
    var individualTimingParameters: UITimingCurveProvider = UICubicTimingParameters(animationCurve: .linear)
    
    /// The animations which are executed on each view of the "`views`" array after the given individual delay has ellapsed.
    ///
    /// The actual delay for the individual animations on a view is proportional with the index of the view in the "`views`" array.
    var individualAnimations: ((UIView) -> ()) = {_ in }
    
    // MARK: - Inherited initializers from: UIViewPropertyAnimator
    override init(duration: TimeInterval, timingParameters parameters: UITimingCurveProvider)
    {
        fatalError("A delayer view property animator must only be initialized using ")
    }
    
    // MARK: Initializers
    
    /// Initializes an `SSDelayedViewPropertyAnimator` out of the given parameters.
    ///
    /// - Parameters:
    ///   - views: The views on which the given animations should be executed individually.
    ///   - individualDuration: The duration of the individual animations, in seconds.
    ///   - individualDelay: The delay which defines the time that should ellapse between the execution of one individual animation and another.
    ///   - individualTimingCurve: The timing curve which defines the pacing of each individual animation.
    ///   - individualAnimations: The animations which are executed on each view of the "`views`" array after the given individual delay has ellapsed.
    convenience init(views: [UIView], individualDuration: TimeInterval, individualDelay: CGFloat, individualTimingCurve: SSCubicTimingCurve, individualAnimations: @escaping ((UIView) -> ()))
    {
        self.init(views: views, individualDuration: individualDuration, individualDelay: individualDelay, individualTimingParameters: individualTimingCurve.uiCubicTimingParameters, individualAnimations: individualAnimations)
    }
    
    /// Initializes an `SSDelayedViewPropertyAnimator` out of the given parameters.
    ///
    /// - Parameters:
    ///   - views: The views on which the given animations should be executed individually.
    ///   - individualDuration: The duration of the individual animations, in seconds.
    ///   - individualDelay: The delay which defines the time that should ellapse between the execution of one individual animation and another.
    ///   - individualTimingParameters: The timing parameters which define the pacing of each individual animation.
    ///   - individualAnimations: The animations which are executed on each view of the "`views`" array after the given individual delay has ellapsed.
    init(views: [UIView], individualDuration: TimeInterval, individualDelay: CGFloat, individualTimingParameters: UITimingCurveProvider, individualAnimations: @escaping ((UIView) -> ()))
    {
        super.init(duration: TimeInterval(views.count) * individualDuration, timingParameters: UICubicTimingParameters(animationCurve: .linear))
        
        self.views = views
        self.individualDuration = individualDuration
        self.individualDelay = individualDelay
        self.individualTimingParameters = individualTimingParameters
        self.individualAnimations = individualAnimations
        
        createAnimations()
    }
    
    /// Creates the individual property aniamtors with the individual animations.
    internal func createAnimations()
    {
        for (i, view) in views.enumerated()
        {
            addAnimations({
                UIViewPropertyAnimator(duration: self.individualDuration, timingParameters: self.individualTimingParameters).addAnimations {
                    self.individualAnimations(view)
                }
            }, delayFactor: CGFloat(duration / individualDuration) * CGFloat(i))
        }
    }
}

class SSRepeatingViewPropertyAnimator: UIViewPropertyAnimator
{
    // MARK: Inherited properties from: UIViewPropertyAnimator
    override var pausesOnCompletion: Bool
    {
        get
        {
            return true
        }
        
        set {}
    }
    
    // MARK: Inherited methods from: UIViewPropertyAnimator
    override func startAnimation()
    {
        super.startAnimation()
        addObserver(self, forKeyPath: #keyPath(isRunning), options: [.old, .new], context: nil)
    }
    
    override func startAnimation(afterDelay delay: TimeInterval)
    {
        super.startAnimation(afterDelay: delay)
        addObserver(self, forKeyPath: #keyPath(isRunning), options: [.old, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if(keyPath == #keyPath(isRunning))
        {
            let oldValue: Bool = change![.oldKey] as! Bool
            let newValue: Bool = change![.newKey] as! Bool
            
            // If the animator is still active and the "isRunning" property has just changed from "true" to "false", we assume that the animator has finished and we should reverse and repeat the animations
            if(!newValue && oldValue && state == .active)
            {
                isReversed=!
                continueAnimation(withTimingParameters: timingParameters, durationFactor: 0.0)
            }
        }
    }
    
    override func stopAnimation(_ withoutFinishing: Bool)
    {
        super.stopAnimation(withoutFinishing)
    }
}
