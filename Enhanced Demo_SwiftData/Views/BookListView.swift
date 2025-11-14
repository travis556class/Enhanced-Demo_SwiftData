//
//  BookListView.swift
//  Demo_SwiftData
//
//  Created by Travis Earl Montgomery on 11/12/25.
//  Enhanced with search, sort, and empty states
//

import SwiftUI
import SwiftData

struct BookListView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Book.title) var books: [Book]
    @State private var searchText = ""
    @State private var sortOrder: SortOrder = .title
    
    enum SortOrder: String, CaseIterable {
        case title = "Title"
        case author = "Author"
        case year = "Year"
    }
    
    var sortedAndFilteredBooks: [Book] {
        var filtered = books
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { book in
                book.title.localizedCaseInsensitiveContains(searchText) ||
                book.author.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply sort
        switch sortOrder {
        case .title:
            return filtered.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .author:
            return filtered.sorted { $0.author.localizedCaseInsensitiveCompare($1.author) == .orderedAscending }
        case .year:
            return filtered.sorted { $0.year > $1.year }
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if books.isEmpty {
                    emptyStateView
                } else if sortedAndFilteredBooks.isEmpty {
                    noResultsView
                } else {
                    bookList
                }
            }
            .navigationTitle("My Library")
            .searchable(text: $searchText, prompt: "Search books")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort By", selection: $sortOrder) {
                            ForEach(SortOrder.allCases, id: \.self) { order in
                                Text(order.rawValue).tag(order)
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
        }
    }
    
    private var bookList: some View {
        List {
            ForEach(sortedAndFilteredBooks) { book in
                NavigationLink {
                    BookDetailView(book: book)
                } label: {
                    BookRowView(book: book)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        deleteBook(book)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView(
            "No Books Yet",
            systemImage: "books.vertical",
            description: Text("Add your first book using the + tab below")
        )
    }
    
    private var noResultsView: some View {
        ContentUnavailableView.search(text: searchText)
    }
    
    private func deleteBook(_ book: Book) {
        withAnimation {
            modelContext.delete(book)
            try? modelContext.save()
        }
    }
}

#Preview("Empty Library") {
    BookListView()
        .modelContainer(for: Book.self, inMemory: true)
}

#Preview("Library with Books") {
    let container = try! ModelContainer(for: Book.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext
    
    let books = [
        Book(title: "1984", author: "George Orwell", year: 1949),
        Book(title: "To Kill a Mockingbird", author: "Harper Lee", year: 1960),
        Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", year: 1925)
    ]
    
    books.forEach { context.insert($0) }
    
    return BookListView()
        .modelContainer(container)
}
