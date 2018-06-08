//
//  AppDelegate.swift
//  ScheduleSchool
//
//  Created by Máté on 2017. 11. 05.
//  Copyright © 2017. Máté. All rights reserved.
//

import UIKit

/// The main class of the application.
class ScheduleSchool
{
    // MARK: Static variables
    
    /// The (shared) singleton instance of the main class.
    static let shared: ScheduleSchool = ScheduleSchool()
    
    // MARK: Properties
    
    /// The window of the application.
    var window: UIWindow
    {
        get
        {
            return sWindow
        }
    }
    
    /// The data about the user of the application.
    var user: SSUser
    {
        get
        {
            return sUser
        }
    }
    
    /// The stored value of `window`.
    private var sWindow: UIWindow!
    
    /// The stored value of `user`.
    fileprivate var sUser: SSUser!
    
    // MARK: Initializers
    
    /// The private singleton initializer.
    private init() {}
    
    // MARK: Functions
    
    /// Prepares the application for the start.
    ///
    /// - Parameter window: The window of the application. (If nil, the application will quit.)
    fileprivate func start(window: UIWindow?)
    {
        if(window == nil)
        {
            // Quit if the window is not valid
            fatalError("The application has failed to display a window")
        }
        
        // Prepare the application for launch
        // - Prepare the window
        sWindow = window
        
        // - Prepare the user data (determine first launch)
        if let lUser: SSUser = NSKeyedUnarchiver.unarchiveObject(withFile: URL.ssUser.path) as? SSUser
        {
            // Restore the user and prepare the application for a regular launch
            sUser = lUser
        }
        else
        {
            // Prepare the application for the first launch
            sUser = SSUser()
        }
    }
}

// MARK: -

@UIApplicationMain
/// The delegate of the application.
internal class SSApplicationDelegate: UIResponder, UIApplicationDelegate
{
    // MARK: Properties
    
    /// The window of the application.
    internal var window: UIWindow?
    
    /// The main class instance of the application.
    private let scheduleSchool: ScheduleSchool = ScheduleSchool.shared

    // MARK: - Implemented methods from: UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // Prepare the application for start.
        scheduleSchool.start(window: window)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
