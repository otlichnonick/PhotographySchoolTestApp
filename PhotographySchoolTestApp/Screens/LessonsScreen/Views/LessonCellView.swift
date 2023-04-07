//
//  LessonCellView.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 30.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct LessonCellView: View {
    let lesson: Lesson

    var body: some View {
        HStack(spacing: AppConstants.defaultPadding) {
            WebImage(url: URL(string: lesson.thumbnail), options: [SDWebImageOptions.decodeFirstFrameOnly])
                .cancelOnDisappear(true)
                .resizable()
                .placeholder {
                    Image(systemName: AppConstants.imagePlaceholder)
                        .renderingMode(.template)
                        .foregroundColor(.gray)
                }
                .indicator(.activity)
                .transition(.fade(duration: Constants.transitionDuration))
                .aspectRatio(contentMode: .fill)
                .frame(width: Constants.imageWidth)
                .padding(.trailing, AppConstants.defaultPadding)

            Text(lesson.name)
                .font(.footnote)
                .lineLimit(Constants.lineLimit)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            Image(systemName: AppConstants.chevronRight)
                .scaledToFit()
                .frame(width: Constants.chevronWidth)
                .foregroundColor(Color(uiColor: .tintColor))
        }
    }
}

private extension LessonCellView {
    struct Constants {
        static let chevronWidth: CGFloat = 40
        static let lineLimit: Int = 3
        static let transitionDuration = 0.5
        static let imageWidth: CGFloat = UIScreen.main.bounds.width / 4
    }
}
