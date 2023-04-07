//
//  ErrorHandler.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 07.04.2023.
//

import Foundation

enum ErrorHandler: Error {
    case dataTaskError(String)
    case serverError
    case wrongData
    case wrongUrl
    case parsingError
    
    var description: String {
        switch self {
        case .dataTaskError(let error):
            return "Data loading error: \(error)"
        case .serverError:
            return "The server returned an error"
        case .wrongData:
            return "No data found"
        case .wrongUrl:
            return "There is the wrong URL for download"
        case .parsingError:
            return "There is the wrong parsing error"
        }
    }
}
