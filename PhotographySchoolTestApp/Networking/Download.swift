//
//  Download.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 03.04.2023.
//

import Foundation

protocol DownloadDelegate: AnyObject {
    func downloadProgressUpdated(for progress: Float)
    func startDownload(with urlString: String)
    func cancelDownload()
}

final class Download {
    weak var delegate: DownloadDelegate?
    var urlString: String
    var sessionTask: URLSessionDownloadTask?
    var progress: Float = 0.0 {
        didSet {
            updateProgress()
        }
    }
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    private func updateProgress() {
        if sessionTask != nil {
            delegate?.downloadProgressUpdated(for: progress)
        }
    }
}
