//
//  Roost_Remote_Watch_Watch_AppUITestsLaunchTests.swift
//  Roost Remote Watch Watch AppUITests
//
//  Created by Elliot Schrock on 10/7/23.
//  Copyright © 2023 Elliot Schrock. All rights reserved.
//

import XCTest

final class Roost_Remote_Watch_Watch_AppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
