//
//  SSViewControllerAnimatedTransitioning.swift
//  Schedule School
//
//  Created by Máté on 2018. 03. 25.
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

/// The custom animated transitioning protocol of the application with built-in interaction support.
///
/// When implementing this protocol, you should always save a reference to the given interaction controller in the initializer, if there is one, and bind it to your implementation.
protocol SSViewControllerAnimatedTransitioning: UIViewControllerAnimatedTransitioning, SSPercentDrivenInteractiveTransitionDelegate where Self: NSObject
{    
    // MARK: Properties
    
    /// The interaction controller which optionally enables interaction for the transition animations.
    ///
    /// The interaction controller may only be set once the class is initialized. A reference should be saved to the specified interaction controller and retruned in this property.
    var interactionController: SSPercentDrivenInteractiveTransition? { get }
    
    // MARK: - Intializers
    
    /// Initializes an animated transitioning with the given interaction controller.
    ///
    /// Implementing classes should save a reference to the given interaction controller and return it in the "`interactionController`" property. They should also bind this animated transitioning to the interaction controller, if there is one, using "`SSPercentDrivenInteractiveTransition.bind(to:)`".
    ///
    /// - Parameter interactionControlller: The interaction controller which should be used to make the transition animations interactive.
    init(interactionController: SSPercentDrivenInteractiveTransition?)
}

// MARK: -
// MARK: -
extension SSViewControllerAnimatedTransitioning
{
    // MARK: Properties
    
    /// Indicates whether the animated transitioning is interactive.
    var isInteractive: Bool
    {
        return interactionController?.state == .engaged
    }
}
