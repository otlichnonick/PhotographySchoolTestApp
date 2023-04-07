//
//  PhotographySchoolTestAppUITestsLaunchTests.swift
//  PhotographySchoolTestAppUITests
//
//  Created by Anton Agafonov on 30.03.2023.
//

import XCTest

final class PhotographySchoolTestAppUITestsLaunchTests: XCTestCase {

    let app = XCUIApplication()
    var downloadButton: XCUIElement { app.navigationBars.buttons[Identifiers.downloadButton] }
    var lessonRowButton: XCUIElement { app.buttons[Identifiers.lessonRow].firstMatch }
    var nextButton: XCUIElement { app.buttons[Identifiers.nextButton] }
    var backButton: XCUIElement { app.navigationBars.children(matching: .button).firstMatch }
    var startDownloadButton: XCUIElement { app.buttons[Identifiers.startButton] }
    var cancelDownloadButton: XCUIElement { app.buttons[Identifiers.cancelButton] }
    
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testNavigateToDetailScreen() throws {
        XCTAssert(lessonRowButton.exists)
        lessonRowButton.tap()
    }
    
    func testBackToLessonsScreen() throws {
        lessonRowButton.tap()
        XCTAssert(backButton.exists)
        backButton.tap()
    }
    
    func testDownloadButtonPressed() throws {
        lessonRowButton.tap()
        XCTAssert(downloadButton.exists)
        downloadButton.tap()
    }
    
    func testDownloadStarted() throws {
        lessonRowButton.tap()
        downloadButton.tap()
        XCTAssert(startDownloadButton.exists)
        startDownloadButton.tap()
    }
    
    func testDownloadCanceled() throws {
        lessonRowButton.tap()
        downloadButton.tap()
        XCTAssert(cancelDownloadButton.exists)
        cancelDownloadButton.tap()
    }
    
    func testShowNextLesson() throws {
        lessonRowButton.tap()
        XCTAssert(nextButton.exists)
        nextButton.tap()
    }
}
