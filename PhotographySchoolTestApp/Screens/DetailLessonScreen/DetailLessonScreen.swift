//
//  DetailLessonScreen.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 03.04.2023.
//

import SwiftUI

struct DetailLessonScreen: View {
    let lessons: [Lesson]
    @Binding var selectedLesson: Lesson
    @StateObject private var viewModel: DetailLessonViewModel = .init()
    var body: some View {
        ZStack {
            DetailLessonView(lesson: $selectedLesson,
                             isEnable: $viewModel.downloadButtonIsEnable,
                             onNextTapped: { viewModel.showNextLesson(&selectedLesson, from: lessons) },
                             onDownloadTapped: { viewModel.askForDownload() })
            
            if viewModel.showProgressVeiw {
                VStack {
                    Text(Constants.progressViewTitle)
                    
                    ProgressView(viewModel.progressText, value: viewModel.progress)
                    
                    HStack {
                        Button {
                            viewModel.startDownload(with: selectedLesson.videoURL)
                        } label: {
                            Text(Constants.startButtonTitle)
                        }
                        .disabled(viewModel.startButtonDisabled)
                        .accessibilityIdentifier(Identifiers.startButton)
                        
                        Spacer()

                        Button {
                            viewModel.cancelDownload()
                        } label: {
                            Text(Constants.cancelButtonTitle)
                        }
                        .accessibilityIdentifier(Identifiers.cancelButton)
                    }
                    .padding()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: Constants.progressViewTitleCornerRadius)
                    .foregroundColor(.gray))
                .padding()
            }
        }
        .onAppear {
            viewModel.prepareVideoUrlFor(selectedLesson: &selectedLesson)
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert, actions: {}, message: {
            Text(viewModel.alertMessage)
        })
    }
}

private extension DetailLessonScreen {
    struct Constants {
        static let progressViewTitle = "Do you want to download the video?"
        static let startButtonTitle = "Start"
        static let cancelButtonTitle = "Cancel"
        static let progressViewTitleCornerRadius: CGFloat = 16
    }
}
