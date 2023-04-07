//
//  LessonsViewModel.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 30.03.2023.
//

import Foundation
import Combine

final class LessonsViewModel: ObservableObject {
    @Published var lessons: [Lesson] = .init()
    @Published var selectedLesson: Lesson?
    @Published var navLinkIsActive: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = .init()
    
    private let lessonsManager: LessonsManager = .init()
}

extension LessonsViewModel {
    func showSelectedLesson(_ lesson: Lesson) {
        navLinkIsActive = true
        selectedLesson = lesson
    }
    
    func getLessons() {
        lessonsManager.getLessons { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.lessons = data.lessons
            case .failure(let error):
                self.showAlert = true
                self.alertMessage = error.description
            }
        }
    }
}
