//
//  SSProfile.swift
//  Schedule School
//
//  Created by Máté on 2017. 12. 30..
//  Copyright © 2017. theMatys. All rights reserved.
//

import UIKit

/// The personal profile of the user.
class SSProfile: NSCoding
{
    // MARK: Properties
    
    /// The profile picture of the user.
    var profilePicture: UIImage?
    
    /// The first name of the user.
    var firstName: String
    
    /// The last name of the user.
    var lastName: String
    
    // MARK: - Implemented initializers from: NSCoding
    required init?(coder aDecoder: NSCoder)
    {
        // Decode the properties from the decoder
        let dProfilePicture: Any? = aDecoder.decodeObject(forKey: PropertyKey.profilePicture)
        let dFirstName: Any? = aDecoder.decodeObject(forKey: PropertyKey.firstName)
        let dLastName: Any? = aDecoder.decodeObject(forKey: PropertyKey.lastName)
        
        // Attempt to assign the decoded values to the properties
        profilePicture = dProfilePicture as? UIImage
        firstName = dFirstName as! String
        lastName = dLastName as! String
    }
    
    // MARK: Initializers
    
    /// Initializes an `SSProfile` object out of the given parameters.
    ///
    /// - Parameters:
    ///   - profilePicture: The profile picture of the user.
    ///   - firstName: The first name of the user.
    ///   - lastName: The last name of the user.
    init(profilePicture: UIImage?, firstName: String, lastName: String)
    {
        self.profilePicture = profilePicture
        self.firstName = firstName
        self.lastName = lastName
    }
    
    // MARK: Implemented methods from: NSCoding
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(profilePicture, forKey: PropertyKey.profilePicture)
        aCoder.encode(firstName, forKey: PropertyKey.firstName)
        aCoder.encode(lastName, forKey: PropertyKey.lastName)
    }
    
    /// The keys of the encoded properties of this class.
    private struct PropertyKey
    {
        static let profilePicture: String = "SSProfile_profilePicture"
        static let firstName: String = "SSProfile_firstName"
        static let lastName: String = "SSProfile_lastName"
    }
}
