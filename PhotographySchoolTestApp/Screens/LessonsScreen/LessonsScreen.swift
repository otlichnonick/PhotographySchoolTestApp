//
//  LessonsScreen.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 30.03.2023.
//

import SwiftUI

struct LessonsScreen: View {
    @StateObject var viewModel: LessonsViewModel = .init()

    init() {
        let coloredNavAppearance = UINavigationBarAppearance()
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = Asset.customBlack.color
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        UITableView.appearance().backgroundColor = Asset.customBlack.color
    }

    var body: some View {
        NavigationView {
            if #available(iOS 16.0, *) {
                lessonList
                    .scrollContentBackground(.hidden)
            } else {
                lessonList
            }
        }
    }

    var lessonList: some View {
        List {
            ForEach(viewModel.lessons) { lesson in
                Button {
                    viewModel.navLinkIsActive = true
                    viewModel.selectedLesson = lesson
                } label: {
                    LessonCellView(lesson: lesson)
                }
                .listRowBackground(Color(uiColor: Asset.customBlack.color))
            }
        }
        .listStyle(.grouped)
        .background(Color(uiColor: Asset.customBlack.color)
            .ignoresSafeArea())
        .navigationTitle("Lessons")
        .onAppear {
            viewModel.getLessons()
        }
        .background(
            NavigationLink(destination: DetailLessonScreen(lesson: viewModel.selectedLesson ?? Lesson(),
                                                           onNextTapped: {
                                                               print("NEXT TAPPED")
                                                           },
                                                           onDownloadTapped: {
                                                               print("DOWNLOAD TAPPED")
                                                           })
                .ignoresSafeArea()
                .navigationBarTitleDisplayMode(.inline),
                           isActive: $viewModel.navLinkIsActive,
                           label: {
                EmptyView()
            })
        )
    }
}

struct LessonsScreen_Previews: PreviewProvider {
    static var previews: some View {
        LessonsScreen()
    }
}
