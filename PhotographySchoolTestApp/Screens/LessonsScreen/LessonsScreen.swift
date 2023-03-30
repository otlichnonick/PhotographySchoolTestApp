//
//  LessonsScreen.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 30.03.2023.
//

import SwiftUI

struct LessonsScreen: View {
    @StateObject var viewModel: LessonsViewModel = .init()
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
            .padding()
            .background(Color.gray
                .ignoresSafeArea())
            .onAppear {
                viewModel.getLessons()
            }
        }
    }
}

struct LessonsScreen_Previews: PreviewProvider {
    static var previews: some View {
        LessonsScreen()
    }
}
