//
//  SSPercentDrivenInteractiveTransition.swift
//  Schedule School
//
//  Created by Máté on 2018. 03. 25.
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

/// The custom percent-driven interaction controller of the application.
///
/// If you want to allow user interaction in your animated transitioning, make sure to implement the properties, initializers and methods of "`SSPercentDrivenInteractiveTransitionDelegate`" and bind this interaction controller to your animated transitioning in the initializer.
class SSPercentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition
{
    // MARK: Properties
    
    /// The current state of the interaction.
    ///
    /// For further information on the states, see: "`SSPercentDrivenInteractiveTransition.State`".
    var state: State = .disengaged
    
    /// The types of the animations that the interactive transition should control.
    ///
    /// You may assign multiple animation types to one interactive transition.
    ///
    /// For further information on the animation types, see: "`SSPercentDrivenInteractiveTransition.AnimationType`".
    var animationTypes: AnimationType
    {
        return delegate?.animationTypes(for: self) ?? .staticViewAnimation
    }
    
    /// The delegate of the interaction controller.
    ///
    /// The interaction controller will use the delegate's callback methods to give information about the interaction's states
    ///
    /// Most commonly, the delegate is an animated transitioning whose intializer should set the delegate of this class to itself.
    var delegate: SSPercentDrivenInteractiveTransitionDelegate?
    
    /// The context object containing information about the transition.
    internal var transitionContext: UIViewControllerContextTransitioning!
    
    // LAYER INTERACTION //
    
    /// The layer on which layer interaction is enabled, if requested in "`animationsType`".
    private var liContainerLayer: CALayer
    {
        return transitionContext.containerView.layer
    }
    
    /// The original value of the container view layer's speed.
    ///
    /// After the interaction has finished, the value held in this property is restored to the container view layer.
    private var liContainerLayerOriginalSpeed: Float?
    
    /// The point in time at which the interaction began on the layer of the transition context's container view.
    ///
    /// The value of this property is used to calculate the corresponding time offset of the container view layer each time the user moves their finger in the specified progress direction, so that the layer animations are driven by the their finger.
    private var liInteractionStart: CFTimeInterval?
    
    /// The floating-point value (ranging from 0 to 1) which represents the completion of the animations after the interaction has ended.
    private var liPostInteractionPercentComplete: CGFloat?
    
    /// The duration of the cancellation/finishing animation which plays after the interaction has ended.
    private var liPostInteractionDuration: CGFloat?
    
    // INTERACTION OF INSTANCE-BASED VIEW ANIMATIONS //
    
    /// The instance which holds all the animations which should be interactive.
    ///
    /// Its value is retrieved through the delegate's `"animationsInstance(for:)"` method which, in case instance view animations were specified to be handled, __must be implemented__ and __must return a valid animations instance__. If the method is not implemented or does not return a valid instance, the application will quit with a fatal error.
    private var vaiiAnimationInstances: [UIViewPropertyAnimator]
    {
        guard let animationInstances = delegate!.animationInstances(for: self) else
        {
            fatalError("If \"instanceViewAnimations\" were specified as an animations type to be handled by an \"SSPercentDrivenInteractiveTransition\", the interaction controller must have a delegate which implements \"animationsInstance(for:)\" and returns a valid animations instance as a result")
        }
        
        return animationInstances
    }
    
    // MARK: - Inherited methods from: UIPercentDrivenInteractiveTransition
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning)
    {
        // Invoke the the callback method of the animated transitioning for when the interaction will begin
        delegate?.interactiveTransition(self, willBeginWithContext: transitionContext)
        
        super.startInteractiveTransition(transitionContext)
        
        // Indicate that the interaction has begun
        state = .engaged
        
        // Save a reference to the transition context for further use
        self.transitionContext = transitionContext
        
        // Start the interaction for the special animation types
        startInteraction()
        
        // Invoke the the callback method of the animated transitioning for when the interaction did begin
        delegate?.interactiveTransition(self, didBeginWithContext: transitionContext)
    }
    
    override func update(_ percentComplete: CGFloat)
    {
        super.update(percentComplete)
        
        // Update the interaction for the special animation types
        updateInteraction(percentComplete)
    }
    
    override func cancel()
    {
        // Invoke the the callback method of the animated transitioning for when the interactive transition is about to be cancelled
        delegate?.interactiveTransition(self, willCancelWithContext: transitionContext)
        
        super.cancel()
        
        // Indicate that the interaction is cancelling
        state = .cancelling
        
        // Cancel the interaction for the special animation types
        endInteraction()
    }
    
    override func finish()
    {
        // Invoke the the callback method of the animated transitioning for when the interactive transition is about to finish
        delegate?.interactiveTransition(self, willFinishWithContext: transitionContext)
        
        super.finish()
        
        // Indicate that the interaction is finishing
        state = .finishing
        
        // Finish the interaction for the special animation types
        endInteraction()
    }
    
    // MARK: Methods
    
    /// Starts the interaction in case the controller was specified to handle the interaction of special animation types.
    ///
    /// In case the controller was requested to handle the interaction of layer animations (`CoreAnimation`), the method starts the interaction by freezing the layer of the transitioning context's container view.
    ///
    /// In case the controller was requested to handle instance-based view animations (`UIViewPropertyAnimator`), the method starts the interaction by starting and immediately pausing the animations in the property animator.
    ///
    /// If both cases occur, the method will handle starting the interaction for both animation types.
    internal func startInteraction()
    {
        if(animationTypes.contains(.instanceViewAnimation))
        {
            for animationInstane in vaiiAnimationInstances
            {
                // Start and pause the animations in order to enable scrubbing
                animationInstane.startAnimation()
                animationInstane.pauseAnimation()
            }
        }
        else if(animationTypes.contains(.layerAnimation))
        {
            // Store the required values
            liInteractionStart = liContainerLayer.convertTime(CACurrentMediaTime(), from: nil)
            liContainerLayerOriginalSpeed = liContainerLayer.speed
            
            // "Freeze" the layer so that user interaction is properly enabled
            liContainerLayer.speed = 0.0
            liContainerLayer.beginTime = 0.0
            
            // Set the interaction's starting time as the time offset of the layer. When an object wants to retrieve the current time in the layer's timeline, the conversion would fail, because the speed, the begin time and the time offset of the layer are all 0. This would always result in a time of 0. To avoid this, we set the layer's time offset to the point of time when it was frozen, so that when an object wants to retrieve the current time, they will get the exact time when the layer was frozen, which is the point in time that they are looking for, hence time is not deleted for the layer; it is just frozen.
            liContainerLayer.timeOffset = liInteractionStart!
        }
    }
    
    /// Updates the interaction in case the controller was specified to handle the interaction of special animation types.
    ///
    /// In case the controller was requested to handle the interaction of layer animations (`CoreAnimation`), the method updates the interaction by offsetting the layer of the transitioning context's container view in time, according to `percentComplete`.
    ///
    /// In case the controller was requested to handle instance-based view animations (`UIViewPropertyAnimator`), the method updates the interaction by passing the value of `percentComplete` to the property animator's `fractionComplete`. The property animator then updates the state of the animations according to the new value of `fractionComplete` implicitly.
    ///
    /// - Parameter percentComplete: The floating-point value (ranging from 0 to 1) which represents the current completion of the animations.
    internal func updateInteraction(_ percentComplete: CGFloat)
    {
        switch animationTypes
        {
        case .instanceViewAnimation:
            for animationInstance in vaiiAnimationInstances
            {
                // Update the animations
                animationInstance.fractionComplete = percentComplete
            }
            
            break
            
        case .layerAnimation:
            // Calculate the appropriate time offset for the current completion percentage, so that the layer's animations are under the user's finger
            liContainerLayer.timeOffset = liInteractionStart! + CFTimeInterval(percentComplete * duration)
            break
            
        default:
            break
        }
    }
    
    /// Ends the interaction in case the controller was specified to handle the interaction of special animation types.
    ///
    /// In case the controller was requested to handle the interaction of layer animations (`CoreAnimation`), the method ends the interaction by creating a display link, which manually (explicitly) animates the layer of the transitioning context's container view:
    ///
    /// - Back into its starting position if subclasses requested cancellation.
    ///
    /// - To its final position if subclasses requested the finishing of the animations.
    ///
    /// In case the controller was requested to handle instance-based view animations (`UIViewPropertyAnimator`), the method ends the interaction by continuing the animations of the property animator (optionally reversed if subclasses requested cancellation).
    internal func endInteraction()
    {
        switch animationTypes
        {
        case .instanceViewAnimation:
            for animationInstance in vaiiAnimationInstances
            {
                // Reverse the animations if a subclass requested cancellation
                if(state == .cancelling)
                {
                    animationInstance.isReversed = true
                }
                
                // Continue the animations of the animations instance
                animationInstance.startAnimation()
                
                // Invoke the callback methods according to the state of the animator
                animationInstance.addCompletion { (position: UIViewAnimatingPosition) in
                    if(position == .start)
                    {
                        self.delegate?.interactiveTransition(self, didCancelWithContext: self.transitionContext)
                    }
                    else if(position == .end)
                    {
                        self.delegate?.interactiveTransition(self, didFinishWithContext: self.transitionContext)
                    }
                }
            }
            
            break
            
        case .layerAnimation:
            // Save the current completion of the animations
            liPostInteractionPercentComplete = SSCubicTimingCurve.ssEaseInOUT.parametricValue(for: percentComplete)
            liPostInteractionDuration = state == .finishing ? duration * (1 - liPostInteractionPercentComplete!) : duration * liPostInteractionPercentComplete!
            
            // Configure the display link which will simulate the cancellation/finishing animation
            let displayLink: CADisplayLink = CADisplayLink(target: self, selector: #selector(SSPercentDrivenInteractiveTransition.liUpdatePostInteractionAnimation))
            displayLink.add(to: RunLoop.main, forMode: .commonModes)
            
            break
            
        default:
            break
        }
    }
    
    @objc private func liUpdatePostInteractionAnimation(_ displayLink: CADisplayLink)
    {
        let ellapsedTime: CFTimeInterval = displayLink.duration
        let completionCurve: SSCubicTimingCurve = SSCubicTimingCurve.ssEaseInOUT
        
        // Calculate the new percentage of completion
        liPostInteractionPercentComplete! += state == .finishing ? CGFloat(ellapsedTime) / liPostInteractionDuration! : -(CGFloat(ellapsedTime) / liPostInteractionDuration!)
        
        if(state == .finishing)
        {
            if(liPostInteractionPercentComplete! >= 1.0)
            {
                displayLink.invalidate()
                
                // Get the time which is simulated to the layer
                let simulatedTime: CFTimeInterval = liContainerLayer.timeOffset
                
                // Indicate that the interaction is no longer in progress
                self.state = .disengaged
                
                // Reset the layer
                liContainerLayer.speed = liContainerLayerOriginalSpeed!
                liContainerLayer.beginTime = 0.0
                liContainerLayer.timeOffset = 0.0
                
                // Offset the layer's timeline appropriately
                liContainerLayer.beginTime = liContainerLayer.convertTime(CACurrentMediaTime(), from: nil) - simulatedTime
                
                // Invoke the the callback method of the animated transitioning for when the interactive transition was cancelled
                self.delegate?.interactiveTransition(self, didFinishWithContext: self.transitionContext)
                
                return
            }
        }
        else if(state == .cancelling)
        {
            // If the user has cancelled the interaction and the animations have just one screen update to return to their starting positions, cancel the animations by completing the transition. Having to cancel the animations one screen update before they return to their starting position is necessary to avoid a flicker, where the destination controller is visible for just a fraction of a second. The early cancellation is unsensible, because the next screen update would make the animations return to their starting positions which is done the exact same way by the completion of the transition.
            if(liPostInteractionPercentComplete! <= 0.0)
            {
                displayLink.invalidate()
                
                // Get the time which is simulated to the layer
                let simulatedTime: CFTimeInterval = liContainerLayer.timeOffset
                
                // Indicate that the interaction is no longer in progress
                self.state = .disengaged
                
                // Reset the layer
                liContainerLayer.speed = liContainerLayerOriginalSpeed!
                liContainerLayer.beginTime = 0.0
                liContainerLayer.timeOffset = 0.0
                
                // Offset the layer's timeline appropriately
                liContainerLayer.beginTime = liContainerLayer.convertTime(CACurrentMediaTime(), from: nil) - simulatedTime
                
                // Invoke the the callback method of the animated transitioning for when the interactive transition was cancelled
                self.delegate?.interactiveTransition(self, didCancelWithContext: self.transitionContext)
                
                // Remove all animations of the sublayers to prevent a blink which shows the final state(s) of the animation(s) for the fraction of a second
                liContainerLayer.onAllSublayers { (sublayer: CALayer) in
                    sublayer.removeAllAnimations()
                }
                
                return
            }
        }

        // Offset the layer in time accordingly
        liContainerLayer.timeOffset = liInteractionStart! + CFTimeInterval(duration * completionCurve.interpolate(at: liPostInteractionPercentComplete!))
    }
    
    // MARK: -
    
    /// The possible states of the application's custom percent-driven interaction controller.
    enum State
    {
        /// Means that there is no user interaction in progress.
        case disengaged
        
        /// Means that there is a user interaction in progress.
        case engaged
        
        /// Means that the user has cancelled the interaction and the animations are currently being cancelled.
        case cancelling
        
        /// Means that the user has ended the interaction and the animations are being finished.
        case finishing
    }
    
    /// The possible types of the animations which should be handled by the application's custom percent-driven interaction controller.
    struct AnimationType: OptionSet
    {
        // MARK: Properties
        
        /// The raw representation of the option set's type.
        let rawValue: Int
        
        // MARK: Options
        
        /// Use this option to indicate that there are static view animations (`UIView.animate(...)` animations) among the animations which should be handled by the interaction controller.
        static let staticViewAnimation: AnimationType = AnimationType(rawValue: 0)
        
        /// Use this option to indicate that there are instance-based view animations (`UIViewPropertyAnimator` instances) among the animations which should be handled by the interaction controller.
        static let instanceViewAnimation: AnimationType = AnimationType(rawValue: 1)
        
        /// Use this option to indicate that there are layer animations (`CoreAnimation` animations) among the animations which should be handled by the interaction controller.
        static let layerAnimation: AnimationType = AnimationType(rawValue: 2)
    }
}

// MARK: -
// MARK: -

/// The delegate of the applictation's custom percent-driven interaction controller.
///
/// You should only implement this protocol and specify your implementation as the delegate of an interaction controller if you want to receive callbacks about specific states of the interaction or if you want to specify special animation to be handled by the interaction controller.
///
/// For more information on the special animation types, see: "`SSPercentDrivenInteractiveTransition.AnimationsType`".
protocol SSPercentDrivenInteractiveTransitionDelegate
{
    // MARK: Methods
    
    /// Called to perform any necessary operations right before the interaction controller starts an interactive transition.
    ///
    /// - Parameters:
    ///   - interactiveTransition: The interaction controller which is informing about the start of the interaction.
    ///   - transitionContext: The context object containing information about the transition.
    func interactiveTransition(_ interactiveTransition: SSPercentDrivenInteractiveTransition, willBeginWithContext transitionContext: UIViewControllerContextTransitioning)
    
    /// Called to perform any necessary operations right after the interaction controller started an interactive transition.
    ///
    /// - Parameters:
    ///   - interactiveTransition: The interaction controller which is informing about the start of the interaction.
    ///   - transitionContext: The context object containing information about the transition.
    func interactiveTransition(_ interactiveTransition: SSPercentDrivenInteractiveTransition, didBeginWithContext transitionContext: UIViewControllerContextTransitioning)
    
    /// Called to perform any necessary operations after the user has cancelled the interaction, but before the animations cancel.
    ///
    /// - Parameters:
    ///   - interactiveTransition: The interaction controller which is informing about the cancellation of the interaction.
    ///   - transitionContext: The context object containing information about the transition.
    func interactiveTransition(_ interactiveTransition: SSPercentDrivenInteractiveTransition, willCancelWithContext transitionContext: UIViewControllerContextTransitioning)
    
    /// Called to perform any necessary operations, after both the interaction and the animations have cancelled.
    ///
    /// This method should call the transition context's "`completeTransition(_:)`" with a `false` "`didComplete`" parameter to perform the final cancellation of the transition.
    ///
    /// - Parameters:
    ///   - interactiveTransition: The interaction controller which is informing about the cancellation of the interaction.
    ///   - transitionContext: The context object containing information about the transition.
    func interactiveTransition(_ interactiveTransition: SSPercentDrivenInteractiveTransition, didCancelWithContext transitionContext: UIViewControllerContextTransitioning)
    
    /// Called to perform any necessary operations after the user has ended the interaction, but before the animations finish.
    ///
    /// - Parameters:
    ///   - interactiveTransition: The interaction controller which is informing about the end of the interaction.
    ///   - transitionContext: The context object containing information about the transition.
    func interactiveTransition(_ interactiveTransition: SSPercentDrivenInteractiveTransition, willFinishWithContext transitionContext: UIViewControllerContextTransitioning)
    
    /// Called to perform any necessary operations after the both the interaction and the animations have finished.
    ///
    /// This method should call the transition context's "`completeTransition(_:)`" with a `true` "`didComplete`" parameter to fully finish the operation.
    ///
    /// - Parameters:
    ///   - interactiveTransition: The interaction controller which is informing about the end of the interaction.
    ///   - transitionContext: The context object containing information about the transition.
    func interactiveTransition(_ interactiveTransition: SSPercentDrivenInteractiveTransition, didFinishWithContext transitionContext: UIViewControllerContextTransitioning)
    
    /// Called to retrieve the type(s) of the animations which the interaction controller should handle.
    ///
    /// By default, `staticViewAnimation` is the specified type to handle.
    ///
    /// - Parameter interactiveTransition: The interaction controller retrieving the type(s) of the animations.
    /// - Returns: The type(s) of the animations.
    func animationTypes(for interactiveTransition: SSPercentDrivenInteractiveTransition) -> SSPercentDrivenInteractiveTransition.AnimationType
    
    /// Called to retrieve the property animator(s) which contain(s) the animations which the interaction controller should handle.
    ///
    /// You do not have to implement this method unless you specified `instanceViewAnimations` in `animationTypes` of your interaction controller.
    ///
    /// If you have specified `instanceViewAnimations` in `animationTypes` of your interaction controller, implementing this function is compulsory.
    ///
    /// - Parameter interactiveTransition: The interaction controller retrieving the instance(s) of the animations.
    /// - Returns: The instance(s) which hold(s) all the animations which the interaction controller should make interactive.
    func animationInstances(for interactiveTransition: SSPercentDrivenInteractiveTransition) -> [UIViewPropertyAnimator]?
}

extension SSPercentDrivenInteractiveTransitionDelegate
{
    func interactiveTransition(_ interactiveTransition: SSPercentDrivenInteractiveTransition, willBeginWithContext transitionContext: UIViewControllerContextTransitioning) {}

    func interactiveTransition(_ interactiveTransition: SSPercentDrivenInteractiveTransition, didBeginWithContext transitionContext: UIViewControllerContextTransitioning) {}

    func interactiveTransition(_ interactiveTransition: SSPercentDrivenInteractiveTransition, willCancelWithContext transitionContext: UIViewControllerContextTransitioning) {}
    
    func interactiveTransition(_ interactiveTransition: SSPercentDrivenInteractiveTransition, didCancelWithContext transitionContext: UIViewControllerContextTransitioning) {}
    
    func interactiveTransition(_ interactiveTransition: SSPercentDrivenInteractiveTransition, willFinishWithContext transitionContext: UIViewControllerContextTransitioning) {}

    func interactiveTransition(_ interactiveTransition: SSPercentDrivenInteractiveTransition, didFinishWithContext transitionContext: UIViewControllerContextTransitioning) {}

    func animationTypes(for interactiveTransition: SSPercentDrivenInteractiveTransition) -> SSPercentDrivenInteractiveTransition.AnimationType
    {
        return .staticViewAnimation
    }

    func animationInstances(for interactiveTransition: SSPercentDrivenInteractiveTransition) -> [UIViewPropertyAnimator]?
    {
        return nil
    }
}
