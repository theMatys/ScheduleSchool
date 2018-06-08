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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.mvSwipeInformer.startAnimation()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
