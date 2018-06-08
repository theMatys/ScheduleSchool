//
//  SSNavigationBar.swift
//  Schedule School
//
//  Created by Máté on 2017. 11. 05.
//  Copyright © 2017. theMatys. All rights reserved.
//

import UIKit

@IBDesignable
/// The custom navigation bar of the application.
class SSNavigationBar: UINavigationBar
{
    // MARK: Inspectable properties
    
    /// The Interface Builder compatible copy of `style`.
    ///
    /// Whenever its value is set, it is clamped and used to create an `SSNavigationBarStyle` instance.
    @IBInspectable var _style: Int = 1
    {
        didSet
        {
            style = SSNavigationBarStyle(rawValue: (_style <?> (1, SSNavigationBarStyle.count)) - 1)!
        }
    }
    
    // MARK: Properties
    
    /// The style of the navigation bar.
    ///
    /// For further information on the styles, see `SSNavigationBarStyle`.
    private var style: SSNavigationBarStyle = .system
    {
        didSet
        {
            updateStyle()
        }
    }
    
    // MARK: Methods
    
    /// Updates style-based appearance of the navigation bar.
    private func updateStyle()
    {
        switch style
        {
        case .system:
            break
        case .firstLaunch:
            // Remove background of the navigation bar
            barTintColor = UIColor.clear
            setBackgroundImage(UIImage(), for: .default)
            shadowImage = UIImage()
            
            break
        }
    }
}

// MARK: -

/// The possible styles of `SSNavigationBar`.
///
/// - style: Style `system` does not make any changes to the navigation bar.
/// - firstLaunch: Style `firstLaunch` removes the background and shadow image of the navigation bar.
enum SSNavigationBarStyle: Int
{
    case system
    case firstLaunch
    
    /// The total number of cases in this enumeration.
    static var count: Int
    {
        return firstLaunch.hashValue + 1
    }
}
