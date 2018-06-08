//
//  SSReferenceExtensions.swift
//  Schedule School
//
//  Created by Máté on 2018. 02. 09..
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

extension TimeInterval
{
    /// The default duration of the transitions in the application.
    static var ssDurationTransition: TimeInterval
    {
        return 0.5
    }
}

// MARK: -
extension CAMediaTimingFunction
{
    /// A media timing function with subtle ease in and strong ease out.
    ///
    /// Its control points are: 0.25, 0.1, 0.125, 1.0
    static var ssEaseInOUT: CAMediaTimingFunction
    {
        return CAMediaTimingFunction(controlPoints: 0.25, 0.1, 0.125, 1.0)
    }
    
    static var ssEaseINOut: CAMediaTimingFunction
    {
        return CAMediaTimingFunction(controlPoints: 0.5, 0.3, 0.125, 1.0)
    }
}

// MARK: -
extension UIColor
{
    /// The default dark background color of the application.
    static var ssBackgroundDark: SSColor
    {
        return SSColor(red: 13, green: 13, blue: 13)
    }
    
    /// The default light background color of the application.
    static var ssBackgroundLight: SSColor
    {
        return SSColor(red: 32, green: 32, blue: 32)
    }
    
    /// The default dark text color of the application.
    static var ssTextDark: SSColor
    {
        return SSColor(red: 132, green: 132, blue: 132)
    }
    
    /// The default light text color of the application.
    static var ssTextLight: SSColor
    {
        return SSColor(red: 205, green: 205, blue: 205)
    }
}

// MARK: -
extension URL
{
    /// The URL for the application support directory of the application.
    static var ssApplicationSupport: URL
    {
        return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    }
    
    /// The URL for the user info file of the application.
    static var ssUser: URL
    {
        return ssApplicationSupport.appendingPathComponent("user")
    }
}

// MARK: -
extension Float
{
    /// The default opacity of controls in state "`normal`".
    static var ssControlStateNormalOpacity: Float
    {
        return 1.0
    }
    
    /// The default opacity of controls in state "`highlighted`".
    static var ssControlStateHighlightedOpacity: Float
    {
        return 0.5
    }
    
    /// The default opacity of controls in state "`disabled`".
    static var ssControlStateDisabledOpacity: Float
    {
        return 0.25
    }
}

// MARK: -
extension CGFloat
{
    /// The default amount which is added to/subtracted from a table view cell's background color upon highlighting it.
    static var ssTableViewCellHighlightAmount: CGFloat
    {
        return 0.05
    }
    
    /// The default opacity of controls in state "`normal`".
    static var ssControlStateNormalOpacity: CGFloat
    {
        return 1.0
    }
    
    /// The default opacity of controls in state "`highlighted`".
    static var ssControlStateHighlightedOpacity: CGFloat
    {
        return 0.5
    }
    
    /// The default opacity of controls in state "`disabled`".
    static var ssControlStateDisabledOpacity: CGFloat
    {
        return 0.25
    }
}

// MARK: -
extension String
{
    struct LocalizationKeys
    {
        /// The localization key for the title of the class type "numbered".
        static var classTypeNumberedTitle: String
        {
            return "ss_string_class_type_numbered_title"
        }
        
        /// The localization key for the description of the class type "numbered".
        static var classTypeNumberedDescription: String
        {
            return "ss_string_class_type_numbered_description"
        }
        
        /// The localization key for the recommendation text of the class type "numbered".
        static var classTypeNumberedRecommendation: String
        {
            return "ss_string_class_type_numbered_recommendation"
        }
        
        /// The localization key for the title of the class type "custom".
        static var classTypeCustomTitle: String
        {
            return "ss_string_class_type_custom_title"
        }
        
        /// The localization key for the description of the class type "custom".
        static var classTypeCustomDescription: String
        {
            return "ss_string_class_type_custom_description"
        }
        
        /// The localization key for the recommendation text of the class type "custom".
        static var classTypeCustomRecommendation: String
        {
            return "ss_string_class_type_custom_recommendation"
        }
        
        /// The localization key for the text of an `SSSwipeInfoView`, when set to direction "up".
        static var swipeInformerUp: String
        {
            return "ss_string_swipe_informer_up"
        }
        
        /// The localization key for the text of an `SSSwipeInfoView`, when set to direction "up" and when set to begin a sequence of swipes (e.g the "Welcome" scene in first launch).
        static var swipeInformerUpBegin: String
        {
            return "ss_string_swipe_informer_up_begin"
        }
        
        /// The localization key for the text of an `SSSwipeInfoView`, when set to direction "down".
        static var swipeInformerDown: String
        {
            return "ss_string_swipe_informer_down"
        }
        
        /// The localization key for the text of an `SSSwipeInfoView`, when set to direction "left".
        static var swipeInformerLeft: String
        {
            return "ss_string_swipe_informer_left"
        }
        
        /// The localization key for the text of an `SSSwipeInfoView`, when set to direction "right".
        static var swipeInformerRight: String
        {
            return "ss_string_swipe_informer_right"
        }
    }
}
