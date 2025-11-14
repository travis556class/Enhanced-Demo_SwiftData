//
//  ContentView.swift
//  Demo_SwiftData
//
//  Created by Travis Earl Montgomery on 11/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            BookListView()
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }
            
            AddBookView()
                .tabItem {
                    Label("Add Book", systemImage: "plus.circle")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Book.self)
}
