//
//  StorageService.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 05.04.2023.
//

import Foundation

struct StorageService {
    static let shared: StorageService = .init()
    private let manager = FileManager.default
    
    func transformUrlToLocal(from sourceUrl: URL) -> URL? {
        guard let documentUrl = manager.urls(for: .documentDirectory,
                                             in: .userDomainMask).first else { return nil }
        
        return documentUrl.appendingPathComponent(String(sourceUrl
            .lastPathComponent
            .suffix(14)))
    }
    
    func moveAndSaveVideo(at sourceUrl: URL, to destinationUrl: URL) throws {
        try manager.moveItem(at: sourceUrl, to: destinationUrl)
    }
    
    func checkStorageContains(url urlString: String) -> Bool {
        guard let videoUrl = getLocalUrlFromString(urlString) else { return false }
                
        return manager.fileExists(atPath: videoUrl.path)
    }
    
    func getLocalUrlFromString(_ urlString: String) -> URL? {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            debugPrint("there are no documentUrl")
            return nil
        }
        
        return documentUrl.appendingPathComponent(String(urlString.suffix(14)))
    }
    
    func getCacheUrl() -> URL? {
        return manager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("lessons")
    }
}
