//
//  BasePresenter.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 30.03.2023.
//

import Foundation
import Combine

class BasePresenter {
    private var bag: Set<AnyCancellable> = .init()

    func baseRequest<T: Codable>(publisher: AnyPublisher<T, Error>, handler: @escaping (Result<T, Error>) -> Void) {
        publisher
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .mapError { error -> Error in
                handler(.failure(error))
                return error
            }
            .sink { _ in } receiveValue: { response in
                handler(.success(response))
            }
            .store(in: &bag)
    }
}
