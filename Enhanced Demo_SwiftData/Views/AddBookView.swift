//
//  AddBookView.swift
//  Demo_SwiftData
//
//  Created by Travis Earl Montgomery on 11/12/25.
//  Enhanced with form validation and keyboard management
//

import SwiftUI
import SwiftData

struct AddBookView: View {
    @Environment(\.modelContext) var modelContext
    @State private var title = ""
    @State private var author = ""
    @State private var year = ""
    @State private var showSuccessAlert = false
    @State private var titleError: String?
    @State private var authorError: String?
    @State private var yearError: String?
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case title, author, year
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Book Title", text: $title)
                            .textFieldStyle(.roundedBorder)
                            .focused($focusedField, equals: .title)
                            .onChange(of: title) { _, _ in
                                titleError = nil
                            }
                        
                        if let error = titleError {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Author Name", text: $author)
                            .textFieldStyle(.roundedBorder)
                            .focused($focusedField, equals: .author)
                            .onChange(of: author) { _, _ in
                                authorError = nil
                            }
                        
                        if let error = authorError {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Publication Year (optional)", text: $year)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .year)
                            .onChange(of: year) { _, _ in
                                yearError = nil
                            }
                        
                        if let error = yearError {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                } header: {
                    Text("Book Information")
                } footer: {
                    Text("Enter the book's title, author, and optionally the publication year.")
                }
                
                Section {
                    Button {
                        addBook()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Add Book")
                                .bold()
                            Spacer()
                        }
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Add New Book")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
            .alert("Book Added!", isPresented: $showSuccessAlert) {
                Button("Add Another") {
                    // Form is already cleared
                }
                Button("Done") {
                    // Just dismiss alert
                }
            } message: {
                Text("'\(title)' has been added to your library.")
            }
        }
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func validateForm() -> Bool {
        var isValid = true
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedTitle.isEmpty {
            titleError = "Title is required"
            isValid = false
        } else if trimmedTitle.count < 2 {
            titleError = "Title must be at least 2 characters"
            isValid = false
        }
        
        let trimmedAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedAuthor.isEmpty {
            authorError = "Author is required"
            isValid = false
        } else if trimmedAuthor.count < 2 {
            authorError = "Author name must be at least 2 characters"
            isValid = false
        }
        
        if !year.isEmpty {
            if let yearInt = Int(year) {
                let currentYear = Calendar.current.component(.year, from: Date())
                if yearInt < 1000 || yearInt > currentYear {
                    yearError = "Year must be between 1000 and \(currentYear)"
                    isValid = false
                }
            } else {
                yearError = "Invalid year format"
                isValid = false
            }
        }
        
        return isValid
    }
    
    private func addBook() {
        guard validateForm() else { return }
        
        focusedField = nil
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
        let bookYear = Int(year) ?? 0
        
        let book = Book(title: trimmedTitle, author: trimmedAuthor, year: bookYear)
        modelContext.insert(book)
        
        do {
            try modelContext.save()
            clearForm()
            showSuccessAlert = true
        } catch {
            print("Failed to save book: \(error.localizedDescription)")
        }
    }
    
    private func clearForm() {
        title = ""
        author = ""
        year = ""
        titleError = nil
        authorError = nil
        yearError = nil
    }
}

#Preview {
    AddBookView()
        .modelContainer(for: Book.self)
}
