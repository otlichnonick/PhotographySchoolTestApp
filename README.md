# Photography School — iOS Interview Project

**A SwiftUI learning-app prototype built as a technical assignment during an interview process.**

The app presents a list of photography lessons, opens individual lesson screens, and includes video playback and download functionality.

## Features

- Browse a list of lessons.
- Open lesson details and move to the next lesson.
- Play lesson videos.
- Download videos with visible progress and cancellation controls.
- Use locally stored video files when available.
- Display user-facing errors during lesson and download flows.

## Tech stack

| Area | Technologies / approach |
| --- | --- |
| Language | Swift |
| UI | SwiftUI, UIKit integration |
| Networking | URLSession |
| Downloads | URLSessionDownloadTask, background session configuration |
| Local files | FileManager |
| Media | AVKit / video player integration |
| Code generation | SwiftGen configuration |
| Code style | SwiftLint configuration |
| Testing | XCTest and UI-test targets |

## Project structure

```text
PhotographySchoolTestApp/
├── Models/
├── Screens/
│   ├── LessonsScreen/
│   └── DetailLessonScreen/
├── Services/
│   ├── DownloadService.swift
│   ├── LesonsManager.swift
│   └── StorageService.swift
├── Helpers/
└── Generated/

PhotographySchoolTestAppTests/
PhotographySchoolTestAppUITests/
```

## Engineering focus

**Video downloads and persistence:** The download service uses URLSession download tasks and a background session configuration; the storage service moves downloaded files into local app storage and resolves local video URLs.

**Separation of concerns:** Views and ViewModels are separate from lesson retrieval, downloading, and file storage.

**Testability:** The repository contains XCTest examples for the lesson-detail ViewModel and a UI-test target. Test execution and coverage have not been revalidated for this portfolio update.

## Context

**Type:** Interview take-home assignment.

The source code is kept as an example of the original assignment rather than presented as a production-ready app. No source changes were made for this README.
