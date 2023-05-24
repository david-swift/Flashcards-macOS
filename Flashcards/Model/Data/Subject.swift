//
//  Subject.swift
//  Flashcards
//
//  Created by david-swift on 10.05.23.
//

import Foundation
import SFSafeSymbols

/// A collection of study sets.
struct Subject: Identifiable, Codable, Equatable {

    /// The subject's identifier.
    let id: UUID
    /// The subject's name.
    var name: String
    /// The subject's icon.
    var icon: SFSymbol = .book
    /// The subject's content.
    var sets: [CardSet]

    /// An initializer.
    /// - Parameter name: The subject's name.
    /// - Parameter sets: The subject's content.
    init(
        name: LocalizedStringResource = .init("New Subject", comment: "Subject (Title of new subject)"),
        sets: [CardSet] = [.init()]
    ) {
        id = .init()
        self.name = .init(localized: name)
        self.sets = sets
    }

}
