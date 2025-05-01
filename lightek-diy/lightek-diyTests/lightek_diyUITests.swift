//
//  lightek_diyUITests.swift
//  lightek-diy
//
//  Created by Marlon on 5/1/25.
//

import Foundation
import XCTest

class lightek_diyUITests: XCTestCase {

    var app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        setupSnapshot(app)
        app.launch()
    }

    func testExample() {
        snapshot("01LoginScreen")
        // interact with app
    }
}

