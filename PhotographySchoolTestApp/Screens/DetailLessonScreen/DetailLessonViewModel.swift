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
    @Published var startButtonDisabled: Bool = false
    @Published var downloadButtonIsEnable: Bool = true

    private(set) var storageService = StorageService.shared
    private(set) var downloadService: DownloadService?
    
    func prepareVideoUrlFor(selectedLesson: inout Lesson) {
        if storageService.checkVideoWasDownloaded(from: selectedLesson.videoURL) {
            if let videoUrl = storageService.getLocalVideoUrl(from: selectedLesson.videoURL) {
                selectedLesson.videoURL = videoUrl.path
            }
        }
    }
    
    func askForDownload() {
        showProgressVeiw = true
        downloadButtonIsEnable = false
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
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let sourceUrl = downloadTask.originalRequest?.url else { return }

        do {
            try storageService.saveVideo(from: location, to: sourceUrl)
            DispatchQueue.main.async {
                self.startButtonDisabled = false
                self.showProgressVeiw = false
            }
        } catch let error {
            debugPrint("ERROR WITH SAVING", error.localizedDescription)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        guard let downloadService else { return }
        DispatchQueue.main.async {
            downloadService.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
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
        startButtonDisabled = true
        if !storageService.checkVideoWasDownloaded(from: urlString) {
            downloadService = DownloadService(urlString: urlString)
            downloadService?.delegate = self
            downloadService?.startDownload()
        } else {
            showProgressVeiw = false
            alertTitle = "Attention"
            alertMessage = "This video has download already"
            showAlert = true
        }
    }
    
    func cancelDownload() {
        startButtonDisabled = false
        showProgressVeiw = false
        downloadButtonIsEnable = true
        downloadService?.cancelDownload()
        downloadService = nil
        progress = 0.0
        progressText = ""
    }
}
