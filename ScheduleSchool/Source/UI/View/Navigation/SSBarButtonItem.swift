//
//  SSBarButtonItem.swift
//  Schedule School
//
//  Created by Máté on 2017. 11. 05.
//  Copyright © 2017. theMatys. All rights reserved.
//

import UIKit

@IBDesignable
/// The custom bar button item of the application which supports custom localization.
class SSBarButtonItem: UIBarButtonItem, SSCustomLocalizable
{
    // MARK: Implemented inspectable properties from: SSCustomLocalizable
    @IBInspectable var localizationKey: String!
    {
        didSet
        {
            if(localizationKey != nil)
            {
                self.title = localizedText()
            }
        }
    }
    
    // MARK: Inherited initializers from: UIBarButtonItem
    override init()
    {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}
