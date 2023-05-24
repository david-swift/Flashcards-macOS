//
//  Flashcard.swift
//  Flashcards
//
//  Created by david-swift on 10.05.23.
//

import Foundation

/// A flashcard.
struct Flashcard: Identifiable, Codable, Equatable {

    /// The identifier.
    let id: UUID
    /// The front side.
    var front: Side = .init()
    /// The back sides.
    var back: [Side] = [.init()]
    /// The card state.
    var state: CardState = .repeat

    /// The initializer.
    init() {
        id = .init()
    }

    /// The card state.
    enum CardState: Codable, Equatable {

        /// Repeat the card.
        case `repeat`
        /// Repeat the card in the next subphase.
        case nextRepeat
        /// Card is answered correctly one time.
        case done(index: Int)
        /// Card is answered incorrectly in phase 2.
        case difficult

    }

}
