//
//  BookDetailView.swift
//  Demo_SwiftData
//
//  Created by Travis Earl Montgomery on 11/12/25.
//  Enhanced with edit mode and delete confirmation
//

import SwiftUI
import SwiftData

struct BookDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State var book: Book
    @State private var isEditing = false
    @State private var showDeleteConfirmation = false
    
    // Edit state
    @State private var editTitle = ""
    @State private var editAuthor = ""
    @State private var editYear = ""
    
    var body: some View {
        List {
            Section {
                if isEditing {
                    editingView
                } else {
                    displayView
                }
            }
        }
        .navigationTitle("Book Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if isEditing {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(!isValidForm)
                } else {
                    Button("Edit") {
                        startEditing()
                    }
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                if isEditing {
                    Button("Cancel") {
                        cancelEditing()
                    }
                } else {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .confirmationDialog(
            "Delete Book?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                deleteBook()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    private var displayView: some View {
        Group {
            LabeledContent("Title") {
                Text(book.title)
                    .multilineTextAlignment(.trailing)
            }
            
            LabeledContent("Author") {
                Text(book.author)
                    .multilineTextAlignment(.trailing)
            }
            
            LabeledContent("Year") {
                Text(book.year > 0 ? String(book.year) : "Not specified")
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    
    private var editingView: some View {
        Group {
            VStack(alignment: .leading, spacing: 4) {
                Text("Title")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                TextField("Book Title", text: $editTitle)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Author")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                TextField("Author Name", text: $editAuthor)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Publication Year")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                TextField("YYYY", text: $editYear)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
            }
        }
    }
    
    private var isValidForm: Bool {
        !editTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !editAuthor.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func startEditing() {
        editTitle = book.title
        editAuthor = book.author
        editYear = book.year > 0 ? String(book.year) : ""
        isEditing = true
    }
    
    private func cancelEditing() {
        isEditing = false
    }
    
    private func saveChanges() {
        book.title = editTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        book.author = editAuthor.trimmingCharacters(in: .whitespacesAndNewlines)
        book.year = Int(editYear) ?? 0
        
        try? modelContext.save()
        isEditing = false
    }
    
    private func deleteBook() {
        modelContext.delete(book)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    NavigationStack {
        BookDetailView(book: Book(title: "1984", author: "George Orwell", year: 1949))
    }
    .modelContainer(for: Book.self, inMemory: true)
}
