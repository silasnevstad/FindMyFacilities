//
//  find_my_facilitiesUITests.swift
//  find-my-facilitiesUITests
//
//  Created by Silas Nevstad on 11/29/24.
//

import XCTest

final class find_my_facilitiesUITests: XCTestCase {

    override func setUpWithError() throws {
        // Setup code before each test method is called.
        continueAfterFailure = false // Stop immediately if a failure occurs.
        
        // Ensure app launches in the correct state.
        let app = XCUIApplication()
        app.launchArguments = ["-UITests"] // Example argument for testing purposes
        app.launch()
    }

    override func tearDownWithError() throws {
        // Teardown code after each test method is called.
    }

    @MainActor
    func testExample() throws {
        // Launch the app and verify basic functionality.
        let app = XCUIApplication()
        XCTAssert(app.state == .runningForeground, "App did not launch successfully.")
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        } else {
            XCTFail("Unsupported platform: Test requires at least iOS 13.0")
        }
    }
}
