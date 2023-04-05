//
//  DetailLessonView.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 31.03.2023.
//

import AVKit
import SwiftUI

struct DetailLessonView: UIViewControllerRepresentable {
    @Binding var lesson: Lesson
    @Binding var isEnable: Bool
    let onNextTapped: () -> Void
    let onDownloadTapped: () -> Void

    func makeUIViewController(context: Context) -> PlayerViewController {
        let viewController = PlayerViewController(lesson: lesson,
                                                  onDownloadTapped: onDownloadTapped,
                                                  onNextTapped: onNextTapped)

        return viewController
    }

    func updateUIViewController(_ uiViewController: PlayerViewController, context: Context) {
        uiViewController.updateView(with: lesson)
        uiViewController.buttonIsEnable(isEnable)
    }
}
