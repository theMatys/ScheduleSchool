//
//  SSFLProfileController.swift
//  ScheduleSchool
//
//  Created by Máté on 2018. 05. 26.
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

/// The view controller for the "Profile" scene in the first launch setup.
class SSFLProfileController: SSViewController, UIViewControllerTransitioningDelegate, UITextFieldDelegate
{
    // MARK: Outlets: managed views
    @IBOutlet weak var mvProfilePicture: SSImageView!
    @IBOutlet weak var mvTitle: UILabel!
    @IBOutlet weak var mvDescription: UILabel!
    @IBOutlet weak var mvFirstName: SSTextField!
    @IBOutlet weak var mvLastName: SSTextField!
    @IBOutlet weak var mvProfilePictureHint: UILabel!
    @IBOutlet weak var mvSwipeInformer: SSFLSwipeInformerView!
    @IBOutlet weak var mvContents: UIView!
    @IBOutlet weak var mvBackgroundBlur: UIVisualEffectView!
    @IBOutlet weak var mvBackgroundImage: UIImageView!
    
    // MARK: Outlets: constraints
    @IBOutlet weak var cContentsBottom: NSLayoutConstraint!
    
    // MARK: Properties

    /// The first name of the user which they entered in the "First Name" text field.
    private var firstName: String = ""
    
    /// The last name of the user which they entered in the "Last Name" text field.
    private var lastName: String = ""

    /// Indicates whether the first launch setup is allowed to continue upon the user's swipe.
    private var canForward: Bool = false
    {
        didSet
        {
            if(canForward)
            {
                if(oldValue != canForward)
                {
                    swipeInformerShowAnimationWaitingForKeyboard = true
                }
            }
            else
            {
                mvSwipeInformer.isHidden = true
            }
        }
    }
    
    /// Indicates whether the animation which shows (fades in) the swipe informer is waiting for the keyboard to hide.
    private var swipeInformerShowAnimationWaitingForKeyboard: Bool = false
    
    private var animationController: AnimatedTransitioning?
    
    // MARK: - Inherited methods from: SSViewController
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set the view controller's delegate
        transitioningDelegate = self
        
        // Subscribe to the keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(SSFLProfileController.keyboardDidHide), name: .UIKeyboardDidHide, object: nil)
        
        // Set the view controller as the delegate of the text fields
        mvFirstName.delegate = self
        mvLastName.delegate = self
        
        // Hide the swipe informer by default
        mvSwipeInformer.isHidden = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Implemented methods from: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if let welcomeController: SSFLWelcomeController = source as? SSFLWelcomeController
        {
            animationController = AnimatedTransitioning(interactionController: SSPanInteractiveTransition(gestureRecognizer: welcomeController.grForwarder, progressionDirection: .up))
            
            return animationController
        }
        
        return nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        return (animator as? AnimatedTransitioning)?.interactionController
    }
    
    // MARK: Implemented methods from: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if(textField == mvFirstName)
        {
            let _: Bool = mvLastName.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        // Store the first/last name of the user
        if(textField == mvFirstName)
        {
            firstName = textField.text!
        }
        else
        {
            lastName = textField.text!
        }
    }
    
    // MARK: Methods
    
    /// Performs a set of actions right after the keyboard has hidden.
    ///
    /// - Parameter notification: The object which contains details about the notification.
    @objc private func keyboardDidHide(_ notification: NSNotification)
    {
        if(swipeInformerShowAnimationWaitingForKeyboard)
        {
            // Save the swipe informer's alpha and prepare for the animations
            let swipeInformerAlpha: CGFloat = mvSwipeInformer.alpha
            mvSwipeInformer.alpha = 0.0
            mvSwipeInformer.isHidden = false
            
            // Show the swipe informer with a fade in animation
            UIViewPropertyAnimator(duration: 0.1, curve: UIViewAnimationCurve.linear, animations: {
                self.mvSwipeInformer.startBounceAnimation()
                self.mvSwipeInformer.alpha = swipeInformerAlpha
            }).startAnimation()
            
            // Reset the indicator property
            swipeInformerShowAnimationWaitingForKeyboard = false
        }
    }
    
    // MARK: Actions
    @IBAction func textField_editingChanged(_ sender: SSTextField)
    {
        canForward = mvFirstName.text != nil && mvFirstName.text!.split(separator: " ").count >= 1 && mvLastName.text != nil && mvLastName.text!.split(separator: " ").count >= 1
    }
    
    // MARK: -
    
    /// The animation controller which performs the animations which transition from the "Welcome" to the "Profile" scene in the first launch setup.
    class AnimatedTransitioning: NSObject, SSViewControllerAnimatedTransitioning
    {
        // MARK: Implemented properties from: SSViewControllerAnimatedTransitioning
        var interactionController: SSPercentDrivenInteractiveTransition?
        {
            return _interactionController
        }
        
        // MARK: Properties
        
        /// The animator which the animates the transition.
        private var animator: UIViewPropertyAnimator!
        
        // INTERNAL VALUES //
        
        /// The internal value of the interaction controller which optionally enables interaction for the transition animations.
        private var _interactionController: SSPercentDrivenInteractiveTransition!
        
        // MARK: - Implemented initializers from: SSViewControllerAnimatedTransitioning
        required init(interactionController: SSPercentDrivenInteractiveTransition?)
        {
            super.init()
            _interactionController = interactionController
            _interactionController.delegate = self
        }
        
        // MARK: - Implemented methods from: SSViewControllerAnimatedTransitioning
        func animationTypes(for interactiveTransition: SSPercentDrivenInteractiveTransition) -> SSPercentDrivenInteractiveTransition.AnimationType
        {
            return .instanceViewAnimation
        }
        
        func animationInstances(for interactiveTransition: SSPercentDrivenInteractiveTransition) -> [UIViewPropertyAnimator]?
        {
            return [animator]
        }
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
        {
            return .ssDurationTransition
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
        {
            // Define the participating objects
            guard
                // Source view controller
                let s: SSFLWelcomeController = transitionContext.viewController(forKey: .from) as? SSFLWelcomeController,
                
                // Destination view controller
                let d: SSFLProfileController = transitionContext.viewController(forKey: .to) as? SSFLProfileController else
            {
                fatalError("The source view controller in an \"SSFLWelcomeController.AnimatedTransitioning\" must be an instance of \"SSFLWelcomeController\" and the destination controller must be an instance of \"SSFLProfileController\"")
            }
            
            // Define the animator
            animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext) / 2, curve: .ssEaseInOUT)
            
            // Prepare the destination view for the animations
            transitionContext.containerView.insertSubview(d.view, belowSubview: s.view)
            
            // Prepare the source for the animations
            let sViewBackgroundColor: UIColor? = s.view.backgroundColor
            s.view.backgroundColor = UIColor.clear
            
            s.mvBackgroundImage.isHidden = true
            
            // Prepare the destination for the animations
            let dBackgroundBlurEffect: UIVisualEffect? = d.mvBackgroundBlur.effect
            d.mvBackgroundBlur.effect = nil
            
            let dContentsAlpha: CGFloat = d.mvContents.alpha
            d.mvContents.alpha = 0.0
            
            d.cContentsBottom.constant = -UIScreen.main.bounds.height
            d.view.layoutIfNeeded()
            
            // Animate the transition
            animator.addAnimations {
                // Animate the source
                s.mvStatusBarBackground.alpha = 0.0
                s.mvContentsBackground.alpha = 0.0
                s.mvContents.alpha = 0.0
                
                s.cContentsTop.constant = -UIScreen.main.bounds.height
                s.cContentsBottom.constant = UIScreen.main.bounds.height
                s.mvContents.superview?.layoutIfNeeded()
                
                // Animate the destination
                d.mvBackgroundBlur.effect = dBackgroundBlurEffect
                d.mvContents.alpha = dContentsAlpha
                
                d.cContentsBottom.constant = 0.0
                d.mvContents?.superview?.layoutIfNeeded()
            }
            
            
            // Define the transition completion
            animator.addCompletion { _ in
                if(transitionContext.transitionWasCancelled)
                {
                    // Restore the source
                    s.view.backgroundColor = sViewBackgroundColor
                    s.mvBackgroundImage.isHidden = false
                    s.cContentsTop.constant = 0.0
                    s.cContentsBottom.constant = 0.0
                    s.mvSwipeInformer.stopBounceAnimation(withoutFinishing: true)
                }
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
            animator.startAnimation()
        }
    }
}
