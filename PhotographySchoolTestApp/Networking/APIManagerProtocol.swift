//
//  APIManagerProtocol.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 30.03.2023.
//

import Foundation
import Combine

protocol APIManagerProtocol {
    var baseURL: String { get }
}

extension APIManagerProtocol {
    func fetch<Output: Codable>(endpoint: APICall,
                                decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Output, Error> {
        do {
            let request = try endpoint.urlRequest(baseUrl: baseURL)
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { result in
                    let httpResponse = result.response as? HTTPURLResponse
//                    NetworkLogger.log(response: httpResponse, data: result.data)

                    if httpResponse?.statusCode == 204 {
                        throw NetworkErrorHandler.noContent
                    }

                    return try NetworkErrorHandler.checkDecodingErrors(decoder: decoder,
                                                                       model: Output.self,
                                                                       with: result.data)
                }
                .eraseToAnyPublisher()
        } catch {
            return AnyPublisher(Fail<Output, Error>(error: NetworkErrorHandler.notValidURL))
        }
    }
}
