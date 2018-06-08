//
//  SSDynamicLocalizable.swift
//  Schedule School
//
//  Created by Máté on 2017. 11. 05.
//  Copyright © 2017. theMatys. All rights reserved.
//

import Foundation

/// Should be implemented by classes which require/have the functionality to use a localized string from the application's dynamic strings (`Localizable.strings` file).
protocol SSCustomLocalizable
{
    /// The custom localization key which must be implemented by the implementing class (and made an IBInspectable if the implementer is a view).
    ///
    /// The implementing class should use `localizedText()` to retrieve a localized text for the value of this variable (which represents the key in the strings file.)
    var localizationKey: String! { get set }
}

extension SSCustomLocalizable where Self: AnyObject
{
    /// Localizes an `SSCustomLocalizable`.
    ///
    /// - Returns: The localized text for the localizable it is called from.
    func localizedText() -> String
    {
        return NSLocalizedString(localizationKey, tableName: nil, bundle: Bundle(for: type(of: self)), value: localizationKey, comment: "")
    }
}
