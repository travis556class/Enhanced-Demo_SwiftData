//
//  BookRowView.swift
//  Demo_SwiftData
//
//  Created by Travis Earl Montgomery on 11/12/25.
//

import SwiftUI

struct BookRowView: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(book.title)
                .font(.headline)
            
            HStack {
                Text(book.author)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if book.year > 0 {
                    Text("•")
                        .foregroundStyle(.secondary)
                    Text(String(book.year))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        BookRowView(book: Book(title: "1984", author: "George Orwell", year: 1949))
        BookRowView(book: Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", year: 1925))
        BookRowView(book: Book(title: "Unknown Book", author: "Anonymous", year: 0))
    }
}
