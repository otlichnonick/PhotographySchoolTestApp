//
//  LessonsViewModel.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 30.03.2023.
//

import Foundation
import Combine

final class LessonsViewModel: BasePresenter, ObservableObject {
    @Published var lessons: [Lesson] = .init()
    @Published var selectedLesson: Lesson?
    @Published var errorMessage: String = ""
    @Published var navLinkIsActive: Bool = false

    private let lessonsManager: LessonsManager = .init()
}

extension LessonsViewModel {
    func showAlert() {
        debugPrint("ERROR", errorMessage)
    }

    func getLessons() {
        let publisher = lessonsManager.fetchLessons()
        baseRequest(publisher: publisher) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.lessons = data.lessons
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlert()
            }
        }
    }
}
