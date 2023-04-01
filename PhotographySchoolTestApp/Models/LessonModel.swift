//
//  LessonModel.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 30.03.2023.
//

import Foundation

struct LessonsModel: Codable {
    let lessons: [Lesson]
}

struct Lesson: Codable, Identifiable {
    let id: Int
    let name, description: String
    let thumbnail: String
    let videoURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail
        case videoURL = "video_url"
    }
}

extension Lesson {
    init() {
        self.id = 0
        self.name = "name"
        self.description = "description"
        self.thumbnail = ""
        self.videoURL = ""
    }
}
