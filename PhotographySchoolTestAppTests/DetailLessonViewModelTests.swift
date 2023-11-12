//
//  DetailLessonViewModelTests.swift
//  PhotographySchoolTestAppTests
//
//  Created by Anton Agafonov on 12/11/23.
//

import XCTest

final class DetailLessonViewModelTests: XCTestCase {
    
    func testDownloadProgressUpdated() {
        let viewModel = DetailLessonViewModel()
        viewModel.downloadProgressUpdated(for: 0.5)
        
        DispatchQueue.main.async {
            XCTAssertEqual(viewModel.progress, 0.5)
            XCTAssertEqual(viewModel.progressText, "50.0%")
        }
    }
    
    func testStartDownload() {
        let viewModel = DetailLessonViewModel()
        let urlString = "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
        viewModel.startDownload(with: urlString)
        
        XCTAssertTrue(viewModel.startButtonDisabled)
        if !viewModel.storageService.checkVideoWasDownloaded(from: urlString) {
            XCTAssertNotNil(viewModel.downloadService)
        } else {
            XCTAssertNil(viewModel.downloadService)
            XCTAssertFalse(viewModel.showProgressVeiw)
        }
    }
    
    func testCancelDownload() {
        let viewModel = DetailLessonViewModel()        
        viewModel.cancelDownload()
        
        XCTAssertFalse(viewModel.startButtonDisabled)
        XCTAssertFalse(viewModel.showProgressVeiw)
        XCTAssertNil(viewModel.downloadService)
        XCTAssertEqual(viewModel.progress, 0.0)
        XCTAssertEqual(viewModel.progressText, "")
    }
}
