//
//  SSFLWelcomeController.swift
//  ScheduleSchool
//
//  Created by Máté on 2018. 05. 26.
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

/// The view controller for the "Welcome" scene in the first launch setup.
class SSFLWelcomeController: SSViewController
{
    // MARK: Outlets: managed views
    @IBOutlet weak var mvTitle: UILabel!
    @IBOutlet weak var mvWelcomeMessage: UILabel!
    @IBOutlet weak var mvSwipeInformer: SSFLSwipeInformerView!
    @IBOutlet weak var mvContentsBackground: SSTwoStopGradientView!
    @IBOutlet weak var mvStatusBarBackground: SSTwoStopGradientView!
    
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
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
