//
//  PhotographySchoolTestAppTests.swift
//  PhotographySchoolTestAppTests
//
//  Created by Anton Agafonov on 30.03.2023.
//

import XCTest
@testable import PhotographySchoolTestApp

final class PhotographySchoolTestAppTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testDownloadLessons() {
        let lessonsManager = LessonsManager()
        let cacheUrl = StorageService.shared.getCacheUrl()!
        let expectation = expectation(description: "Lessons should be loaded")
        
        lessonsManager.downloadLessonsAndSave(to: cacheUrl) { result in
            switch result {
            case .success(let lessonsModel):
                XCTAssertGreaterThan(lessonsModel.lessons.count, 0)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Loading lessons failed with error: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testDownloadAndSaveVideo() {
        let session = URLSession(configuration: .default)
        let url = URL(string: "https://embed-ssl.wistia.com/deliveries/f7105de283304e0dc6fe40e5abbf778f.jpg?image_crop_resized=1000x560")!
        let downloadTask = session.downloadTask(with: url)
        let viewModel = DetailLessonViewModel()
        let expectedFilePath = StorageService.shared.transformUrlToLocal(from: url)!
        
        downloadTask.delegate = viewModel
        downloadTask.resume()
        
        sleep(5)
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: expectedFilePath.path))
    }
    
    func testStartDownload() {
        let viewModel = DetailLessonViewModel()
        let urlString = "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
        
        viewModel.startDownload(with: urlString)
        sleep(3)
        
        XCTAssertNotNil(viewModel.activeDownload)
    }
    
    func testCancelDownload() {
        let viewModel = DetailLessonViewModel()
        let urlString = "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
        
        viewModel.startDownload(with: urlString)
        sleep(3)
        viewModel.cancelDownload()
        
        XCTAssertNil(viewModel.activeDownload)
    }
}
