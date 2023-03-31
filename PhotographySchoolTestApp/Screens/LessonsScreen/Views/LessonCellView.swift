//
//  LessonCellView.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 30.03.2023.
//

import SwiftUI

struct LessonCellView: View {
    let lesson: Lesson

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: lesson.thumbnail)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 4)
            } placeholder: {
                Image(systemName: Constants.imagePlaceholder)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width / 4)
            }

            Text(lesson.name)
                .font(.footnote)
                .lineLimit(3)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            Image(systemName: "chevron.right")
                .scaledToFit()
                .frame(width: 40)
                .foregroundColor(.blue)
        }
    }
}
