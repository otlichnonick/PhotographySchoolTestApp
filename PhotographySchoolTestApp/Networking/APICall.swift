//
//  APICall.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 30.03.2023.
//

import Foundation

protocol APICall {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
}

extension APICall {
    func urlRequest(baseUrl: String) throws -> URLRequest {
        guard let url = URL(string: baseUrl + path) else {
            throw NetworkErrorHandler.notValidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = nil
        NetworkLogger.log(request: request)
        return request
    }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PATCH
    case PUT
    case DELETE
}

typealias HTTPHeaders = [String: String]
