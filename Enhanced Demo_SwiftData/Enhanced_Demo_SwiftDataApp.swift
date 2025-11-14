//
//  Demo_SwiftDataApp.swift
//  Demo_SwiftData
//
//  Created by Travis Earl Montgomery on 11/12/25.
//  Enhanced version with HIG compliance
//

import SwiftUI
import SwiftData

@main
struct Demo_SwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}

#Preview("Content View") {
    ContentView()
        .modelContainer(for: Book.self)
}

