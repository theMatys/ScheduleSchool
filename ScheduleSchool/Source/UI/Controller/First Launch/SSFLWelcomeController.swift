//
//  SSFLWelcomeController.swift
//  ScheduleSchool
//
//  Created by Máté on 2018. 05. 26.
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

/// The view controller for the "Welcome" scene in the first launch setup.
class SSFLWelcomeController: SSViewController, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate
{
    // MARK: Outlets: managed views
    @IBOutlet weak var mvSwipeInformer: SSFLSwipeInformerView!
    @IBOutlet weak var mvContents: UIView!
    @IBOutlet weak var mvContentsBackground: SSTwoStopGradientView!
    @IBOutlet weak var mvStatusBarBackground: SSTwoStopGradientView!
    @IBOutlet weak var mvBackgroundImage: UIImageView!
    
    // MARK: Outlets: constraints
    @IBOutlet weak var cContentsTop: NSLayoutConstraint!
    @IBOutlet weak var cContentsBottom: NSLayoutConstraint!
    
    // MARK: Outlets: gesture recognizers
    @IBOutlet var grForwarder: UIPanGestureRecognizer!
    
    // MARK: - Inherited methods from: SSViewController
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        // Start the bounce animation of the swipe informer
        mvSwipeInformer.startBounceAnimation()
        
        // Set the forwarder gesture recognizer's delegate and add the callback method
        grForwarder.delegate = self
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Implemented methods from: UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if(gestureRecognizer == grForwarder)
        {
            performSegue(withIdentifier: .ssSegueFLWelcomeToProfile, sender: self)
            return true
        }
        
        return false
    }
}
