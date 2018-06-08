//
//  SSViewController.swift
//  ScheduleSchool
//
//  Created by Máté on 2017. 11. 05.
//  Copyright © 2017. Máté. All rights reserved.
//

import UIKit

/// The custom default view controller of the application.
class SSViewController: UIViewController
{
    // MARK: Inspectables
    
    /// Indicates whether the content of the view controller is light.
    ///
    /// If set to `true`, the dark status bar will be shown
    /// If set to `false`, the light status bar will be shown
    @IBInspectable var isLight: Bool = false
    {
        didSet
        {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK: Inherited properties from: UIViewController
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return isLight ? .default : .lightContent
    }
    
    // MARK: - Inherited methods from: UIViewController
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
