//
//  SSUser.swift
//  Schedule School
//
//  Created by Máté on 2017. 12. 30..
//  Copyright © 2017. theMatys. All rights reserved.
//

import Foundation

/// The class which holds all the data about the user of the application.
class SSUser: NSCoding
{
    // MARK: Properties
    
    /// The personal profile of the user.
    var profile: SSProfile!
    
    /// The timetable of the user.
    var timetable: SSTimetable!
    
    // MARK: - Implemented initializers from: NSCoding
    required init?(coder aDecoder: NSCoder)
    {
        // Decode the properties from the decoder
        let dProfile: Any? = aDecoder.decodeObject(forKey: PropertyKey.profile)
        let dTimetable: Any? = aDecoder.decodeObject(forKey: PropertyKey.timetable)

        // Attempt to assign the decoded values to the properties
        profile = dProfile as? SSProfile
        timetable = dTimetable as? SSTimetable
    }
    
    // MARK: Initializers
    
    /// Initializes an empty `SSUser` object. Should only be used upon the first launch.
    init() {}
    
    // MARK: Implemented methods from: NSCoding
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(profile, forKey: PropertyKey.profile)
        aCoder.encode(timetable, forKey: PropertyKey.timetable)
    }
    
    /// The keys of the encoded properties of this class.
    private struct PropertyKey
    {
        static let profile: String = "SSUser_profile"
        static let timetable: String = "SSUser_timetable"
    }
}
