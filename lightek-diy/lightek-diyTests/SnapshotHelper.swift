//
//  SnapshotHelper.swift
//  lightek-diy
//
//  Created by Marlon on 5/1/25.
//

import Foundation
// SnapshotHelper.swift

import Foundation
import XCTest

var app: XCUIApplication!

public func setupSnapshot(_ app: XCUIApplication) {
    Snapshot.setupSnapshot(app)
}

class Snapshot: NSObject {
    static func setupSnapshot(_ app: XCUIApplication) {
        setLanguage(app)
        setLaunchArguments(app)
    }

    private static func setLanguage(_ app: XCUIApplication) {
        let prefix = "FASTLANE_SNAPSHOT_"
        if let language = ProcessInfo().environment["\(prefix)LANGUAGE"] {
            app.launchArguments += ["-AppleLanguages", "(\(language))"]
        }

        if let locale = ProcessInfo().environment["\(prefix)LOCALE"] {
            app.launchArguments += ["-AppleLocale", "\(locale)"]
        }
    }

    private static func setLaunchArguments(_ app: XCUIApplication) {
        app.launchArguments += ["-FASTLANE_SNAPSHOT", "YES"]
    }
}

