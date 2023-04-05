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
                             onNextTapped: {
                viewModel.showNextLesson(&selectedLesson, from: lessons)
            },
                             onDownloadTapped: {
                viewModel.showProgressVeiw = true
                viewModel.downloadButtonIsEnable = false
            })
            
            if viewModel.showProgressVeiw {
                VStack {
                    Text("Do you want to download the video?")
                    
                    ProgressView(viewModel.progressText, value: viewModel.progress)
                    
                    HStack {
                        Button {
                            viewModel.downloadVideo(from: selectedLesson.videoURL)
                        } label: {
                            Text("Start")
                        }
                        .disabled(viewModel.isDownloading)
                        
                        Spacer()

                        Button {
                            viewModel.cancelDownload()
                        } label: {
                            Text("Cancel")
                        }
                    }
                    .padding()
                }
                .padding()
                .background(
                RoundedRectangle(cornerRadius: 16)
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
