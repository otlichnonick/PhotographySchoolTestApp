//
//  LesonsManager.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 30.03.2023.
//

import Foundation
import Combine

struct LessonsManager: APIManagerProtocol {
    var baseURL: String = Constants.baseUrl
    
    func fetchLessons() -> AnyPublisher<LessonsModel, Error> {
        return fetch(endpoint: API.fetchLessons)
    }
}

extension LessonsManager {
    enum API {
        case fetchLessons
    }
}

extension LessonsManager.API: APICall {
    var path: String {
        switch self {
        case .fetchLessons:
            return ""
        }
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    
}
