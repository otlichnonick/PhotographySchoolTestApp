//
//  NetworkErrorHandler.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 30.03.2023.
//

import Foundation

enum NetworkErrorHandler: Error, LocalizedError {
    case notValidURL
    case notValidBody
    case noContent

    public var errorDescription: String {
        switch self {
        case .notValidURL:
            return "URL is incorrect"
        case .notValidBody:
            return  "Body of request is incorrect"
        case .noContent:
            return "There are no content"
        }
    }

    static func checkDecodingErrors<Output: Codable>(decoder: JSONDecoder,
                                                     model: Output.Type,
                                                     with data: Data) throws -> Output {
        do {
            return try decoder.decode(model.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            debugPrint("\(Output.self) could not find key \(key) in JSON: \(context.debugDescription)")
            throw DecodingError.keyNotFound(key, context)
        } catch DecodingError.valueNotFound(let type, let context) {
            debugPrint("\(Output.self) could not find type \(type) in JSON: \(context.debugDescription)")
            throw DecodingError.valueNotFound(type, context)
        } catch DecodingError.typeMismatch(let type, let context) {
            debugPrint("\(Output.self)  type mismatch for type \(type) in JSON: \(context.debugDescription)")
            throw DecodingError.typeMismatch(type, context)
        } catch DecodingError.dataCorrupted(let context) {
            debugPrint("\(Output.self) data found to be corrupted in JSON: \(context.debugDescription)")
            throw DecodingError.dataCorrupted(context)
        }
    }
}
