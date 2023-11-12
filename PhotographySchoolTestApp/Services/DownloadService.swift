//
//  Download.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 03.04.2023.
//

import Foundation

protocol DownloadDelegate: URLSessionDownloadDelegate {
    func downloadProgressUpdated(for progress: Float)
    func startDownload(with urlString: String)
    func cancelDownload()
}

final class DownloadService {
    weak var delegate: DownloadDelegate?
    var urlString: String
    var progress: Float = 0.0 {
        didSet {
            updateProgress()
        }
    }
    private var sessionTask: URLSessionDownloadTask?
    private var urlSession: URLSession {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.background.queue")
        let queue = OperationQueue()
        return URLSession(configuration: configuration, delegate: delegate, delegateQueue: queue)
    }
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    private func updateProgress() {
        delegate?.downloadProgressUpdated(for: progress)
    }
    
    func startDownload() {
        guard let url = URL(string: urlString) else { return }
        sessionTask = urlSession.downloadTask(with: url)
        sessionTask?.resume()
    }
    
    func cancelDownload() {
        sessionTask?.cancel()
    }
}
