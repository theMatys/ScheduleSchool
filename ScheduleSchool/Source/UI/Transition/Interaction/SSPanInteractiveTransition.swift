//
//  SSPanInteractiveTransition.swift
//  ScheduleSchool
//
//  Created by Máté on 2018. 06. 17.
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

/// An interaction controller which handles user interaction with a pan gesture recognizer.
///
/// __IMPORTANT:__ The class is not responsible for starting the interactive transition when the gesture recognizer gets engaged.
///
///   - If the view controller is not embedded in a navigation controller, the gesture recognizer should be declared in the view controller and it should commit the presentation/dismissal of the view controller upon engagement. The transitioning delegate of the view controller should then return this class as the interaction controller of the transition.
///
///   - If the view controller is embedded in a navigation controller, the gesture recognizer should be declared in the navigation controller and it should commit a push/pop operation upon engagement. The delegate of the navigation controller should then return this class as the interaction controller of the transition.
class SSPanInteractiveTransition: SSPercentDrivenInteractiveTransition
{
    // MARK: Properties
    
    /// The pan gesture recognizer which handles the change of the pan, making interactivity possible.
    var gestureRecognizer: UIPanGestureRecognizer
    {
        return _gestureRecognizer
    }
    
    /// The direction in which the change of the pan is considered as progression.
    var progressionDirection: ProgressionDirection
    {
        return _progressionDirection
    }
    
    /// The last known velocity of the user's finger in the container view of the transitioning context.
    var lastVelocity: CGFloat
    {
        return _lastVelocity
    }
    
    // INTERNAL VALUES //
    
    /// The internal value of the pan gesture recognizer which handles the change of the pan.
    private var _gestureRecognizer: UIPanGestureRecognizer!
    
    /// The internal value of the direction in which the change of the pan is considered as progression.
    private var _progressionDirection: ProgressionDirection!
    
    /// The internal value of the last known velocity of the user's finger in the container view of the transitioning context.
    private var _lastVelocity: CGFloat!
    
    // MARK: - Initializers
    
    /// Initializes an `SSPanInteractiveTransition` object out of the given parameters.
    ///
    /// - Parameters:
    ///   - gestureRecognizer: The pan gesture recognizer which handles the change of the pan.
    ///   - progressionDirection: The direction in which the progression of the pan is considered.
    init(gestureRecognizer: UIPanGestureRecognizer, progressionDirection: ProgressionDirection)
    {
        super.init()
        
        // Store the given parameters
        _gestureRecognizer = gestureRecognizer
        _progressionDirection = progressionDirection
    }
    
    // MARK: Inherited methods from: SSPercentDrivenInteractiveTransition
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning)
    {
        super.startInteractiveTransition(transitionContext)
        
        // Subscribe to the gesture recognizer which handles the change of the pan
        gestureRecognizer.addTarget(self, action: #selector(SSPanInteractiveTransition.updateGestureRecognizer))
    }
    
    override func cancel()
    {
        super.cancel()
        
        // Unsubscribe from the gesture recognizer which handles the change of the pan
        gestureRecognizer.removeTarget(self, action: #selector(SSPanInteractiveTransition.updateGestureRecognizer))
    }
    
    override func finish()
    {
        super.finish()
        
        // Unsubscribe from the gesture recognizer which handles the change of the pan
        gestureRecognizer.removeTarget(self, action: #selector(SSPanInteractiveTransition.updateGestureRecognizer))
    }
    
    // MARK: Methods
    
    /// Updates the transition as requested by the gesture recognizer.
    ///
    /// - Parameter gestureRecognizer: The pan gesture recognizer which requested the handling of the pan's change.
    @objc private func updateGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer)
    {
        let translationView: UIView = transitionContext.containerView
        
        let translation: CGPoint = gestureRecognizer.translation(in: translationView)
        let velocity: CGPoint = gestureRecognizer.velocity(in: translationView)
        let nominator: CGFloat =
            progressionDirection == .left ? translation.x :
                progressionDirection == .right ? -translation.x :
                progressionDirection == .up ? -translation.y : translation.y
        
        let denominator: CGFloat = progressionDirection == .left || progressionDirection == .right ? translationView.frame.width : translationView.frame.height
        
        let processedVelocity: CGFloat =
            progressionDirection == .left ? velocity.x :
                progressionDirection == .right ? -velocity.x :
                progressionDirection == .up ? -velocity.y : velocity.y
        
        switch gestureRecognizer.state
        {
        case .began:
            gestureRecognizer.setTranslation(.zero, in: translationView)
            break
            
        case .changed:
            update(nominator / denominator <?> (0.0, 1.0))
            break
            
        case .cancelled:
            cancel()
            break
            
        case .ended:
            let percentTreshold: CGFloat = 0.5
            let velocityTreshold: CGFloat = 50.0
            
            if(percentComplete >= percentTreshold || processedVelocity > velocityTreshold)
            {
                finish()
            }
            else
            {
                cancel()
            }
            
            break
            
        default:
            break
        }
    }
    
    // MARK: -
    
    /// A direction which a pan can change in.
    enum ProgressionDirection
    {
        /// In case "`left`", the pan is considered to progress forward when it continues leftwards in relation to its starting position.
        case left
        
        /// In case "`right`", the pan is considered to progress forward when it continues rightwards in relation to its starting position.
        case right
        
        /// In case "`up`", the pan is considered to progress forward when it continues upwards in relation to its starting position.
        case up
        
        /// In case "`down`", the pan is considered to progress forward when it continues downwards in relation to its starting position.
        case down
    }
}
