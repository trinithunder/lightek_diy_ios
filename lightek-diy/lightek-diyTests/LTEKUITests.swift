//
//  LTEKUITests.swift
//  lightek-diyTests
//
//  Created by Marlon on 5/1/25.
//

import Foundation
import XCTest

class YourAppUITests: XCTestCase {
  func testScreenshots() {
    let app = XCUIApplication()
    setupSnapshot(app)
    app.launch()

    snapshot("01-Home")
    // Navigate and snapshot more screens
  }
}
