//
//  SSFLProfileController.swift
//  ScheduleSchool
//
//  Created by Máté on 2018. 05. 26.
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

/// The view controller for the "Profile" scene in the first launch setup.
class SSFLProfileController: SSViewController, UIGestureRecognizerDelegate, UITextFieldDelegate
{
    // MARK: Outlets: managed views
    @IBOutlet weak var mvProfilePicture: SSImageView!
    @IBOutlet weak var mvTitle: UILabel!
    @IBOutlet weak var mvDescription: UILabel!
    @IBOutlet weak var mvFirstName: SSTextField!
    @IBOutlet weak var mvLastName: SSTextField!
    @IBOutlet weak var mvProfilePictureHint: UILabel!
    @IBOutlet weak var mvSwipeInformer: SSFLSwipeInformerView!
    
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
    
    // MARK: - Inherited methods from: SSViewController
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
}
