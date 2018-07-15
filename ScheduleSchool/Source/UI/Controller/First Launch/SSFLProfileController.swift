//
//  SSFLProfileController.swift
//  ScheduleSchool
//
//  Created by Máté on 2018. 05. 26.
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

/// The view controller for the "Profile" scene in the first launch setup.
class SSFLProfileController: SSViewController, UIViewControllerTransitioningDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    // MARK: OUTLETS
    // MARK: Managed views
    @IBOutlet weak var mvProfilePicture: SSImageView!
    @IBOutlet weak var mvDescription: UILabel!
    @IBOutlet weak var mvFirstName: SSTextField!
    @IBOutlet weak var mvLastName: SSTextField!
    @IBOutlet weak var mvCollapsedContents: UIStackView!
    @IBOutlet weak var mvProfilePictureHint: UILabel!
    @IBOutlet weak var mvProfilePictureButton: SSImageButton!
    @IBOutlet weak var mvProfileStackView: UIStackView!
    @IBOutlet weak var mvSwipeInformer: SSFLSwipeInformerView!
    @IBOutlet weak var mvContents: UIView!
    @IBOutlet weak var mvBackgroundBlur: UIVisualEffectView!
    @IBOutlet weak var mvBackgroundImage: UIImageView!
    
    // MARK: Constraints
    @IBOutlet weak var cProfilePictureWidth: NSLayoutConstraint!
    @IBOutlet weak var cProfilePictureHeight: NSLayoutConstraint!
    @IBOutlet weak var cProfileStackViewTop: NSLayoutConstraint!
    @IBOutlet weak var cContentsBottom: NSLayoutConstraint!
    
    // MARK: - PROPERTIES
    
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
    
    // MARK: User
    
    /// The profile picture picked by the user.
    private var profilePicture: UIImage?
    
    /// The first name of the user which they entered in the "First Name" text field.
    private var firstName: String = ""
    
    /// The last name of the user which they entered in the "Last Name" text field.
    private var lastName: String = ""
    
    // MARK: Rearrange animation
    
    
    /// Indicates whether the keyboard is currently shown (whether the user is editing either of the text fields).
    ///
    /// When the keyboard is shown (when the user is editing either of the text fields), the managed views of the view controller are rearranged so that the text fields can fit in the area unoccupied by the keyboard.
    ///
    /// Some of the properties of the affected views must be saved so that after the user has finished editing the text fields, the original values of those properties can be restored.
    private var keyboardShown: Bool = false
    
    /// The saved value of the profile picture image view's width.
    ///
    /// For more details on the purpose of this property, see: "`keyboardShown`".
    private var sProfilePictureWidth: CGFloat = 0.0
    
    /// The saved value of the profile picture image view's height.
    ///
    /// For more details on the purpose of this property, see: "`keyboardShown`".
    private var sProfilePictureHeight: CGFloat = 0.0
    
    /// The saved value of the profile picture image view's alpha.
    ///
    /// For more details on the purpose of this property, see: "`keyboardShown`".
    private var sProfilePictureAlpha: CGFloat = 0.0
    
    /// The saved value of the description label's text.
    ///
    /// For more details on the purpose of this property, see: "`keyboardShown`".
    private var sDescriptionText: String?
    
    /// The saved value of the profile picture hint label's alpha.
    ///
    /// For more details on the purpose of this property, see: "`keyboardShown`".
    private var sProfilePictureHintAlpha: CGFloat = 0.0
    
    /// The saved value of the "Add profile picture" button's alpha.
    ///
    /// For more details on the purpose of this property, see: "`keyboardShown`".
    private var sProfilePictureButtonAlpha: CGFloat = 0.0
    
    /// The saved value of the constant of the profile stack view's top constraint.
    ///
    /// For more details on the purpose of this property, see: "`keyboardShown`".
    private var sProfileStackViewTopConstant: CGFloat = 0.0
    
    // MARK: - OVERRIDEN/IMPLEMENTED METHODS
    
    // MARK: SSViewController
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set the view controller's delegate
        transitioningDelegate = self
        
        // Subscribe to the keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(SSFLProfileController.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SSFLProfileController.keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SSFLProfileController.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
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
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if let welcomeController: SSFLWelcomeController = source as? SSFLWelcomeController
        {
            return AnimatedTransitioning(interactionController: SSPanInteractiveTransition(gestureRecognizer: welcomeController.grForwarder, progressionDirection: .up))
        }
        
        return nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        return (animator as? AnimatedTransitioning)?.interactionController
    }
    
    // MARK: UITextFieldDelegate
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
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        guard let image: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage else
        {
            return
        }
        
        profilePicture = image
        mvProfilePicture.template = false
        mvProfilePicture.clipsToBounds = true
        mvProfilePicture.image = image
        mvProfilePicture.alpha = 1.0
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - METHODS
    
    // MARK: Keyboard notification callbacks
    
    /// Performs a set of actions right when the keyboard is about to show.
    ///
    /// - Parameter notification: The object which contains details about the notification.
    @objc private func keyboardWillShow(_ notification: NSNotification)
    {
        if(!keyboardShown)
        {
            guard let keyboardFrame: CGRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else
            {
                return
            }
            
            // Save the original values of the animated properties
            sProfilePictureWidth = cProfilePictureWidth.constant
            sProfilePictureHeight = cProfilePictureHeight.constant
            sProfilePictureAlpha = mvProfilePicture.alpha
            sProfilePictureHintAlpha = mvProfilePictureHint.alpha
            sProfilePictureButtonAlpha = mvProfilePictureButton.alpha
            sDescriptionText = mvDescription.text
            sProfileStackViewTopConstant = cProfileStackViewTop.constant
            
            // Animate the profile picture
            cProfilePictureWidth.constant = 0.0
            cProfilePictureHeight.constant = 0.0
            mvProfilePicture.alpha = 0.0
            
            // Animate the description label
            UIView.transition(with: mvDescription, duration: .ssDurationTransition, options: .transitionCrossDissolve, animations: {
                self.mvDescription.text = NSLocalizedString(String.LocalizationKeys.flProfileDescriptionShort, tableName: "ScheduleSchool", bundle: Bundle(for: type(of: self)), value: "", comment: "")
            }, completion: nil)
            
            // Animate the profile picture hint label and the profile picture button
            mvProfilePictureHint.alpha = 0.0
            mvProfilePictureButton.alpha = 0.0
            
            // Animate the profile stack view
            let originalY: CGFloat = mvProfileStackView.convert(mvProfileStackView.bounds.origin, to: ScheduleSchool.shared.window).y
            let unoccupiedSpace: CGSize = ScheduleSchool.shared.window.frame.size - keyboardFrame.size
            let newY: CGFloat = (unoccupiedSpace.height - mvCollapsedContents.frame.height) / 2
            
            cProfileStackViewTop.constant = newY - originalY
            
            // Commit the changes
            view.layoutIfNeeded()
        }
    }
    
    /// Performs a set of actions right after the keyboard has shown.
    ///
    /// - Parameter notification: The object which contains details about the notification.
    @objc private func keyboardDidShow(_ notification: NSNotification)
    {
        keyboardShown = true
    }
    
    /// Performs a set of actions right when the keyboard is about to hide.
    ///
    /// - Parameter notification: The object which contains details about the notification.
    @objc private func keyboardWillHide(_ notification: NSNotification)
    {
        if(keyboardShown)
        {
            // Animate the profile picture
            cProfilePictureWidth.constant = sProfilePictureWidth
            cProfilePictureHeight.constant = sProfilePictureHeight
            mvProfilePicture.alpha = sProfilePictureAlpha
            
            // Animate the profile picture hint label and the profile picture button
            mvProfilePictureHint.alpha = sProfilePictureHintAlpha
            mvProfilePictureButton.alpha = sProfilePictureButtonAlpha
            
            // Animate the description label
            UIView.transition(with: mvDescription, duration: .ssDurationTransition, options: .transitionCrossDissolve, animations: {
                self.mvDescription.text = self.sDescriptionText
            }, completion: nil)
            
            // Animate the profile stack view
            cProfileStackViewTop.constant = sProfileStackViewTopConstant
            
            // Commit the changes
            view.layoutIfNeeded()
        }
    }
    
    /// Performs a set of actions right after the keyboard has hidden.
    ///
    /// - Parameter notification: The object which contains details about the notification.
    @objc private func keyboardDidHide(_ notification: NSNotification)
    {
        keyboardShown = false
        
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
    
    @IBAction func button_tapped(_ sender: SSImageButton)
    {
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: -
    
    /// The animation controller which performs the animations which transition from the "Welcome" to the "Profile" scene in the first launch setup.
    class AnimatedTransitioning: NSObject, SSViewControllerAnimatedTransitioning
    {
        // MARK: OVERRIDEN/IMPLEMENTED PROPERTIES
        var interactionController: SSPercentDrivenInteractiveTransition?
        {
            return _interactionController
        }
        
        // MARK: - PROPERTIES
        
        /// The animator which the animates the transition.
        private var animator: UIViewPropertyAnimator!
        
        // MARK: Internal values
        
        /// The internal value of the interaction controller which optionally enables interaction for the transition animations.
        private var _interactionController: SSPercentDrivenInteractiveTransition!
        
        // MARK: - OVERRIDEN/IMPLEMENTED INITIALIZERS
        required init(interactionController: SSPercentDrivenInteractiveTransition?)
        {
            super.init()
            _interactionController = interactionController
            _interactionController.delegate = self
        }
        
        // MARK: - OVERRIDEN/IMPLEMENTED METHODS
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
