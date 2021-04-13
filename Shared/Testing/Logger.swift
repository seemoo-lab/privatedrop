//
//  Logger.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 07.10.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import Foundation
import os

struct Log {
    #if DEBUG
        public static var logFile = "Log file \(Date().description)\n"
        public static var logLevel = 5
    #else
        public static let logLevel = 5
    #endif

    public static func log(log: OSLog, type: OSLogType, message: StaticString, _ a: [CVarArg]) {
        switch a.count {
        case 5: os_log(message, log: log, type: type, a[0], a[1], a[2], a[3], a[4])
        case 4: os_log(message, log: log, type: type, a[0], a[1], a[2], a[3])
        case 3: os_log(message, log: log, type: type, a[0], a[1], a[2])
        case 2: os_log(message, log: log, type: type, a[0], a[1])
        case 1: os_log(message, log: log, type: type, a[0])
        case 0: os_log(message, log: log, type: type)
        default: os_log(message, log: log, type: type, a)
        }

    }
    /// Log level 5 - Request content
    public static func requestContent(system: LogSystem, message: StaticString, _ args: CVarArg...) {
        guard logLevel >= 5 else { return }
        log(log: system.osLog, type: .info, message: message, args)
        attachToLogFile(type: .info, message: message, args)
    }

    /// Log level 4 - General infos
    public static func info(system: LogSystem, message: StaticString, _ args: CVarArg...) {
        guard logLevel >= 4 else { return }
        log(log: system.osLog, type: .info, message: message, args)
        attachToLogFile(type: .info, message: message, args)
    }

    // Log level 3 - Other important messages
    public static func `default`(system: LogSystem, message: StaticString, _ args: CVarArg...) {
        guard logLevel >= 3 else { return }
        log(log: system.osLog, type: .default, message: message, args)
        attachToLogFile(type: .default, message: message, args)
    }

    // Log level 2 - Debug messages
    public static func debug(system: LogSystem, message: StaticString, _ args: CVarArg...) {
        guard logLevel >= 2 else { return }
        log(log: system.osLog, type: .debug, message: message, args)
        attachToLogFile(type: .debug, message: message, args)
    }

    // Log level 1
    public static func error(system: LogSystem, message: StaticString, _ args: CVarArg...) {
        guard logLevel >= 1 else { return }
        log(log: system.osLog, type: .error, message: message, args)
        attachToLogFile(type: .error, message: message, args)
    }

    static func typeEmoji(for type: OSLogType) -> String {
        var typeEmoji = "ℹ️"
        switch type {
        case .debug:
            typeEmoji = "🐞"
        case .default:
            typeEmoji = "✏️"
        case .error:
            typeEmoji = "⚠️"
        case .fault:
            typeEmoji = "❌"
        case .info:
            typeEmoji = "ℹ️"
        default:
            break
        }
        return typeEmoji
    }

    static func attachToLogFile(type: OSLogType, message: StaticString, _ a: [CVarArg]) {
        #if DEBUG
            DispatchQueue.main.async {
                var logMessage = message.description

                switch a.count {
                case 5:
                    logMessage = String(format: message.description, a[0], a[1], a[2], a[3], a[4])
                case 4: logMessage = String(format: message.description, a[0], a[1], a[2], a[3])
                case 3: logMessage = String(format: message.description, a[0], a[1], a[2])
                case 2: logMessage = String(format: message.description, a[0], a[1])
                case 1: logMessage = String(format: message.description, a[0])
                default: break
                }

                let typeEmoji = self.typeEmoji(for: type)

                // Buffer of 10KB size
                if logFile.count > 10240 {
                    // Clear log file
                    self.logFile.removeAll()
                    self.logFile = "Log file \(Date().description)\n"
                }
                // Attach message
                self.logFile.append("\(typeEmoji) ")
                self.logFile.append("\(Date()) - ")
                self.logFile.append(logMessage)
                self.logFile.append("\n\n\n")
            }

        #endif
    }

    public struct LogSystem {
        let osLog: OSLog

        init(_ osLog: OSLog) {
            self.osLog = osLog
        }

        static let test = LogSystem(OSLog(subsystem: "OpenDrop-Test", category: "Test"))
    }
}
