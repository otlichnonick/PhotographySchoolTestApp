//
//  LesonsManager.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 30.03.2023.
//

import Foundation

struct LessonsManager {
    func getLessons(completionHandler: @escaping (Result<LessonsModel, Error>) -> Void) {
        guard let cacheUrl = StorageService.shared.getCacheUrl() else { return }
        
        if let cacheData = try? Data(contentsOf: cacheUrl),
           let lessonsModel = try? JSONDecoder().decode(LessonsModel.self, from: cacheData) {
            completionHandler(.success(lessonsModel))
            return
        }
        
        downloadLessonsAndSave(to: cacheUrl, with: completionHandler)
    }
    
    func downloadLessonsAndSave(to cacheUrl: URL, with completionHandler: @escaping (Result<LessonsModel, Error>) -> Void) {
        guard let url = URL(string: Constants.baseUrl) else {
            debugPrint("there are no url for download")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error {
                completionHandler(.failure(error))
            }
            
            if let data {
                guard let lessonsModel = try? JSONDecoder().decode(LessonsModel.self, from: data) else {
                    debugPrint("wrong parsing")
                    return
                }
                
                try? data.write(to: cacheUrl)
                completionHandler(.success(lessonsModel))
            }
        }.resume()
    }
}

