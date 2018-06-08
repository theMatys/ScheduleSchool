//
//  SSTimetable.swift
//  Schedule School
//
//  Created by Máté on 2017. 12. 30..
//  Copyright © 2017. theMatys. All rights reserved.
//

import Foundation

/// The timetable of the user.
class SSTimetable: NSCoding
{
    // MARK: Properties
    
    /// The days on which the user attends to school.
    ///
    /// Its value is set in "`SSFLTimetableSchooldaysController`".
    var schooldays: SSSchoolday!
    
    /// The type of the classes that the timetable holds.
    ///
    /// Its value is set in "`SSFLTimetableClassesTypeController`".
    var classesType: SSTimetable.ClassesType!
    
    // MARK: - Implemented initializers from: NSCoding
    required init?(coder aDecoder: NSCoder)
    {
        // Decode the properties from the decoder
        let dSchooldays: Any? = aDecoder.decodeObject(forKey: PropertyKey.schooldays)
        let dClassesType: Any? = aDecoder.decodeBool(forKey: PropertyKey.classesType)
        
        // Attempt to assign the decoded values to the properties
        schooldays = dSchooldays as? SSSchoolday
        classesType = dClassesType as? SSTimetable.ClassesType
    }
    
    // MARK: Initializers
    
    /// Initializes an empty `SSTimetable` object. Should only be used upon the first launch.
    init() {}
    
    // MARK: Implemented methods from: NSCoding
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(schooldays, forKey: PropertyKey.schooldays)
        aCoder.encode(classesType, forKey: PropertyKey.classesType)
    }
    
    /// The keys of the encoded properties of this class.
    private struct PropertyKey
    {
        static let schooldays: String = "SSTimetable_schooldays"
        static let classesType: String = "SSTimetable_classesType"
    }
    
    // MARK: -
    enum ClassesType: Int
    {
        /// Indicates that the user has not yet specified the type of classes they prefer.
        case unspecified
        
        /// With "`numbered`" classes, classes in a schoolday are automatically numbered.
        case numbered
        
        /// With "`custom`" classes, classes in a schoolday are given a unique letter by the user.
        case custom
    }
}

// MARK: -
// MARK: -

/// Holds all the possible schooldays of the week.
struct SSSchoolday: OptionSet
{
    // MARK: Static variables
    static let monday: SSSchoolday = SSSchoolday(rawValue: 0)
    static let tuesday: SSSchoolday = SSSchoolday(rawValue: 1)
    static let wednesday: SSSchoolday = SSSchoolday(rawValue: 2)
    static let thursday: SSSchoolday = SSSchoolday(rawValue: 3)
    static let friday: SSSchoolday = SSSchoolday(rawValue: 4)
    static let saturday: SSSchoolday = SSSchoolday(rawValue: 5)
    static let sunday: SSSchoolday = SSSchoolday(rawValue: 6)
    
    // MARK: Properties
    let rawValue: Int
}
