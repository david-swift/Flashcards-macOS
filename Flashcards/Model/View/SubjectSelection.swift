//
//  SubjectSelection.swift
//  Flashcards
//
//  Created by david-swift on 13.05.23.
//

import Foundation

/// The selected item in the subject list.
enum SubjectSelection: Hashable, Codable {

    /// All sets are displayed.
    case allSets
    /// Important sets are displayed.
    case importantSets
    /// A subject's content is displayed.
    case subject(id: UUID)

}
