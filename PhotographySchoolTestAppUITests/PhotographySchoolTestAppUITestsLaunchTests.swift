//
//  PhotographySchoolTestAppUITestsLaunchTests.swift
//  PhotographySchoolTestAppUITests
//
//  Created by Anton Agafonov on 30.03.2023.
//

import XCTest

final class PhotographySchoolTestAppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testNavigateToDetailScreen() throws {
        
    }
}
