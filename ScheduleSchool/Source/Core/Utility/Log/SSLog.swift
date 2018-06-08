//
//  SSLog.swift
//  ScheduleSchool
//
//  Created by Máté on 2017. 11. 05..
//  Copyright © 2017. theMatys. All rights reserved.
//

import os.log

/// Logs an information message to the default log of the OS.
///
/// - Parameters:
///   - message: The message to be logged.
///   - module: The module the function is called from.
func SSLogInfo(_ message: Any?, _ module: SSLogModule? = nil)
{
    if(module != nil)
    {
        os_log("%@%@", log: .default, type: .info, module!.rawValue as CVarArg, (message as? CVarArg) ?? "Downcast failure/nil message")
    }
    else
    {
        os_log("%@", log: .default, type: .info, (message as? CVarArg) ?? "Downcast failure/nil message")
    }
}

/// Logs a debug message to the default log of the OS.
///
/// - Parameters:
///   - message: The message to be logged.
///   - module: The module the function is called from.
func SSLogDebug(_ message: Any?, _ module: SSLogModule? = nil)
{
    if(module != nil)
    {
        os_log("%@%@%@", log: .default, type: .debug, module!.rawValue as CVarArg, "*** DEBUG *** ", (message as? CVarArg) ?? "Downcast failure/nil message")
    }
    else
    {
        os_log("%@%@", log: .default, type: .debug, "*** DEBUG *** ", (message as? CVarArg) ?? "Downcast failure/nil message")
    }
}

/// Logs a warning message to the default log of the OS.
///
/// - Parameters:
///   - message: The message to be logged.
///   - module: The module the function is called from.
func SSLogWarning(_ message: Any?, _ module: SSLogModule? = nil)
{
    if(module != nil)
    {
        os_log("%@%@%@", log: .default, type: .info, module!.rawValue as CVarArg, "*** WARNING *** ", (message as? CVarArg) ?? "Downcast failure/nil message")
    }
    else
    {
        os_log("%@%@", log: .default, type: .info, "*** WARNING *** ", (message as? CVarArg) ?? "Downcast failure/nil message")
    }
}

/// Logs an error message to the default log of the OS.
///
/// - Parameters:
///   - message: The message to be logged.
///   - module: The module the function is called from.
func SSLogError(_ message: Any?, _ module: SSLogModule? = nil)
{
    if(module != nil)
    {
        os_log("%@%@%@", log: .default, type: .error, module!.rawValue as CVarArg, "*** ERROR *** ", (message as? CVarArg) ?? "Downcast failure/nil message")
    }
    else
    {
        os_log("%@%@", log: .default, type: .error, "*** ERROR *** ", (message as? CVarArg) ?? "Downcast failure/nil message")
    }
}

/// Logs a fault message to the default log of the OS.
///
/// - Parameters:
///   - message: The message to be logged.
///   - module: The module the function is called from.
func SSLogFault(_ message: Any?, _ module: SSLogModule? = nil)
{
    if(module != nil)
    {
        os_log("%@%@%@", log: .default, type: .fault, module!.rawValue as CVarArg, "*** FAULT *** ", (message as? CVarArg) ?? "Downcast failure/nil message")
    }
    else
    {
        os_log("%@%@", log: .default, type: .fault, "*** FAULT *** ", (message as? CVarArg) ?? "Downcast failure/nil message")
    }
}

/// Gives a logged feedback on whether the function which this function was called from is called.
///
/// - Parameters:
///   - function: The function this function is called from (automatically filled).
///   - module: The module the function is called from.
func SSLogCall(_ function: String = #function, _ module: SSLogModule? = nil)
{
    SSLogDebug("Function \"" + function + "\" has been called.", module)
}

/// The possible log modules of the application.
///
/// Simple enumeration which makes the log of the application more organized.
///
/// - application: Module `application` should be used whenever a log function is called from the core segments of the application.
/// - ui: Module `ui` should be used whenever a log function is called from the UI segments of the application.
enum SSLogModule: String
{
    case application = "[APPLICATION]: "
    case ui = "[UI]: "
}
