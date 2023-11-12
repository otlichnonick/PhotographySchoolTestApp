//
//  StorageService.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 05.04.2023.
//

import Foundation

protocol StorageServiceProtocol {
    func saveVideo(from url: URL, to destinationUrl: URL) throws
    func checkVideoWasDownloaded(from urlString: String) -> Bool
    func transformUrlToLocal(from sourceUrl: URL) -> URL?
    func getLocalVideoUrl(from urlString: String) -> URL?
    func fetchCachedUrl(for pathComponent: String) -> URL?
}

struct StorageService: StorageServiceProtocol {
    static let shared: StorageService = .init()
    private let manager = FileManager.default
    
    func saveVideo(from url: URL, to destinationUrl: URL) throws {
        guard let videoUrl = transformUrlToLocal(from: destinationUrl) else { return }
        
        try manager.moveItem(at: url, to: videoUrl)
    }
    
    func transformUrlToLocal(from sourceUrl: URL) -> URL? {
        guard let documentUrl = manager.urls(for: .documentDirectory,
                                             in: .userDomainMask).first else { return nil }
        
        return documentUrl.appendingPathComponent(String(sourceUrl
            .lastPathComponent
            .suffix(14)))
    }
    
    func checkVideoWasDownloaded(from urlString: String) -> Bool {
        guard let videoUrl = getLocalVideoUrl(from: urlString) else { return false }
        return FileManager.default.fileExists(atPath: videoUrl.path)
    }
    
    func getLocalVideoUrl(from urlString: String) -> URL? {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            debugPrint("there are no documentUrl")
            return nil
        }
        
        return documentUrl.appendingPathComponent(String(urlString.suffix(14)))
    }
    
    func fetchCachedUrl(for pathComponent: String) -> URL? {
        return manager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(pathComponent)
    }
}
