//
//  LesonsManager.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 30.03.2023.
//

import Foundation

struct LessonsManager {
    func getLessons(completionHandler: @escaping (Result<LessonsModel, ErrorHandler>) -> Void) {
        guard let cacheUrl = StorageService.shared.fetchCachedUrl(for: "lessons") else { return }
        
        if let cacheData = try? Data(contentsOf: cacheUrl),
           let lessonsModel = try? JSONDecoder().decode(LessonsModel.self, from: cacheData) {
            completionHandler(.success(lessonsModel))
            return
        } else {
            downloadLessonsAndSave(to: cacheUrl, with: completionHandler)
        }
    }
    
    func downloadLessonsAndSave(to cacheUrl: URL, with completionHandler: @escaping (Result<LessonsModel, ErrorHandler>) -> Void) {
        guard let url = URL(string: AppConstants.baseUrl) else {
            completionHandler(.failure(.wrongUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error {
                completionHandler(.failure(.dataTaskError(error.localizedDescription)))
            }
            
            if let data {
                guard let lessonsModel = try? JSONDecoder().decode(LessonsModel.self, from: data) else {
                    completionHandler(.failure(.parsingError))
                    return
                }
                
                try? data.write(to: cacheUrl)
                completionHandler(.success(lessonsModel))
            } else {
                completionHandler(.failure(.wrongData))
            }
        }.resume()
    }
}
