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
    
    func getLocalUrl(from sourceUrl: URL) -> URL? {
        guard let documentUrl = manager.urls(for: .documentDirectory,
                                             in: .userDomainMask).first else { return nil }
        
        return documentUrl.appendingPathComponent(String(sourceUrl
            .lastPathComponent
            .suffix(14)))
    }
    
    func moveAndSaveVideo(at sourceUrl: URL, to destinationUrl: URL) throws {
        try manager.moveItem(at: sourceUrl, to: destinationUrl)
    }
}
