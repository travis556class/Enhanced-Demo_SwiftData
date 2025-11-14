//
//  Book.swift
//  Demo_SwiftData
//
//  Created by Travis Earl Montgomery on 11/12/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Book {
    var title: String
    var author: String
    var year: Int
    
    init(title: String = "", author: String = "", year: Int = 0) {
        self.title = title
        self.author = author
        self.year = year
    }
}
