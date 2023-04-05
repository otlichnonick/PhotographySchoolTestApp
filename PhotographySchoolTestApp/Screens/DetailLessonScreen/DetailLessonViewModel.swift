//
//  DetailLessonViewModel.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 03.04.2023.
//

import Foundation

class DetailLessonViewModel: NSObject, ObservableObject {
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = .init()
    @Published var alertTitle: String = .init()
    @Published var progress: Float = .zero
    @Published var progressText: String = .init()
    @Published var showProgressVeiw: Bool = false
    @Published var isDownloading: Bool = false
    @Published var downloadButtonIsEnable: Bool = true
    var activeDownload: Download?
    var urlSession: URLSession {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.background")
        let queue = OperationQueue()
        return URLSession(configuration: configuration, delegate: self, delegateQueue: queue)
    }
    
    func downloadVideo(from urlString: String) {
        isDownloading = true
        if !checkVideoDownloaded(from: urlString) {
            startDownload(with: urlString)
        } else {
            showProgressVeiw = false
            alertTitle = "Attention"
            alertMessage = "This video has download already"
            showAlert = true
        }
    }
    
    func prepareVideoUrlFor(selectedLesson: inout Lesson) {
        if checkVideoDownloaded(from: selectedLesson.videoURL) {
            if let videoUrl = getLocalVideoUrl(from: selectedLesson.videoURL) {
                selectedLesson.videoURL = videoUrl.path
            }
        }
    }
    
    private func checkVideoDownloaded(from urlString: String) -> Bool {
        guard let videoUrl = getLocalVideoUrl(from: urlString) else { return false }
        return FileManager.default.fileExists(atPath: videoUrl.path)
    }
    
    private func getLocalVideoUrl(from urlString: String) -> URL? {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            debugPrint("there are no documentUrl")
            return nil
        }
        return documentUrl.appendingPathComponent(String(urlString.suffix(14)))
    }
    
    func showNextLesson(_ selectedLesson: inout Lesson, from lessons: [Lesson]) {
        guard let index = lessons.firstIndex(where: { $0.id == selectedLesson.id }) else {
            showAlert = true
            alertMessage = "Something wromg, try again"
            return
        }
        guard let nextLesson = lessons[safe: (index + 1)] else {
            showAlert = true
            alertMessage = "Where are no next lesson. This is the last one"
            return
        }
        selectedLesson = nextLesson
    }
}

extension DetailLessonViewModel: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        debugPrint("Task has been resumed")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let sourceUrl = downloadTask.originalRequest?.url else { return }
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let videoUrl = documentUrl.appendingPathComponent(String(sourceUrl.lastPathComponent.suffix(14)))
        do {
            try FileManager.default.moveItem(at: location, to: videoUrl)
            
            DispatchQueue.main.async {
                self.isDownloading = false
                self.showProgressVeiw = false
            }
        } catch let error {
            debugPrint("ERROR WITH SAVING", error.localizedDescription)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        guard let activeDownload else { return }
        DispatchQueue.main.async {
            activeDownload.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        }
    }
}

extension DetailLessonViewModel: DownloadDelegate {
    func downloadProgressUpdated(for progress: Float) {
        DispatchQueue.main.async {
            self.progress = progress
            self.progressText = String(format: "%.1f%%", progress * 100)
        }
    }
    
    func startDownload(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        self.activeDownload = Download(urlString: urlString)
        guard let activeDownload else { return }
        activeDownload.delegate = self
        activeDownload.sessionTask = urlSession.downloadTask(with: url)
        activeDownload.sessionTask?.resume()
    }
    
    func cancelDownload() {
        isDownloading = false
        showProgressVeiw = false
        downloadButtonIsEnable = true
        guard let download = activeDownload else { return }
        download.sessionTask?.cancel()
        activeDownload = nil
        progress = 0.0
        progressText = ""
    }
}
