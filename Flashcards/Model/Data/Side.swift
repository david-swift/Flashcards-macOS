//
//  Side.swift
//  Flashcards
//
//  Created by david-swift on 10.05.23.
//

import Foundation

/// A side contains a title, description, image and the help.
struct Side: Identifiable, Codable, Equatable {

    /// The side's identifier.
    let id: UUID
    /// The title supporting Markdown.
    var title = ""
    /// A description supporting Markdown.
    var description = ""
    /// A URL to a image.
    var imageURL = ""
    /// A help text.
    var help = ""

    /// The initializer.
    init() {
        id = .init()
    }

}
