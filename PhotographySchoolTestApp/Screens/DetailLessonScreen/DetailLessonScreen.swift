//
//  DetailLessonScreen.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 31.03.2023.
//

import AVKit
import SwiftUI

struct DetailLessonScreen: UIViewControllerRepresentable {
    let lesson: Lesson
    let onNextTapped: () -> Void
    let onDownloadTapped: () -> Void

    func makeUIViewController(context: Context) -> some UIViewController {
        debugPrint("lesson", lesson)
        let viewController = PlayerViewController(lesson: lesson,
                                                  onDownloadTapped: onDownloadTapped,
                                                  onNextTapped: onNextTapped)

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}
