//
//  CardSet.swift
//  Flashcards
//
//  Created by david-swift on 10.05.23.
//

import ColibriComponents
import Foundation

/// A study set.
struct CardSet: Identifiable, Codable, Equatable, Bindable {

    /// The identifier.
    let id: UUID
    /// The set's title.
    var name: String = .init(localized: .init("New Set", comment: "CardSet (Name of new set)"))
    /// The set's description.
    var description: String = .init()
    /// The content.
    var flashcards: [Flashcard] = [.init()] {
        didSet {
            if repeatCards.isEmpty {
                if repeatNextCards.isEmpty {
                    activeCount = 0
                    if let id = lastDoneCards.randomElement()?.id {
                        studyID = id
                    } else {
                        resetProgress()
                    }
                } else {
                    for flashcard in flashcards where flashcard.state == .nextRepeat {
                        flashcards[id: flashcard.id]?.state = .repeat
                    }
                    studyID = repeatCards.randomElement()?.id
                    activeCount += 1
                }
            } else {
                studyID = repeatCards.randomElement()?.id
            }
        }
    }
    /// Whether the set is especially important.
    var important = false
    /// The identifier of the active card in the study mode.
    var studyID: UUID?
    /// The counter in phase 1.
    var activeCount = 0

    /// The cards that are repeated at the moment in study mode.
    var repeatCards: [Flashcard] {
        flashcards.filter { $0.state == .repeat }
    }

    /// The cards to repeat later in study mode.
    var repeatNextCards: [Flashcard] {
        flashcards.filter { $0.state == .nextRepeat }
    }

    /// Cards that were answered incorrectly in phase 2 and not yet answered correctly.
    var difficultCards: [Flashcard] {
        flashcards.filter { $0.state == .difficult }
    }

    /// The maximum index of a stack.
    var maxIndex: Int {
        var maxIndex = 0
        for flashcard in flashcards {
            if case let .done(index: index) = flashcard.state {
                if maxIndex < index {
                    maxIndex = index
                }
            }
        }
        return maxIndex
    }

    /// The cards that moved to phase 2 in the last iteration.
    var lastDoneCards: [Flashcard] {
        flashcards.filter { card in
            switch card.state {
            case let .done(index: index):
                return index == maxIndex
            case .difficult:
                return true
            default:
                return false
            }
        }
    }

    /// The phase description of the set.
    var phase: LocalizedStringResource {
        if repeatCards.count == flashcards.count {
            return .init("Start Studying", comment: "CardSet (Study phase without having studied anything)")
        } else if repeatCards.isEmpty && repeatNextCards.isEmpty {
            return .init("Phase 2.\(maxIndex)", comment: "CardSet (Study phase 2)")
        } else {
            return .init("Phase 1.\(activeCount)", comment: "CardSet (Study phase 1)")
        }
    }

    /// The initializer.
    init() {
        id = .init()
    }

    /// The active card was answered correctly.
    mutating func right() {
        if repeatCards.isEmpty, case let .done(index: index) = flashcards[id: studyID]?.state {
            flashcards[id: studyID]?.state = .done(index: index - 1)
        } else {
            let activeCount = activeCount
            flashcards[id: studyID]?.state = .done(index: activeCount)
        }
    }

    /// The active card was answered incorrectly.
    mutating func wrong() {
        let repeatCards = repeatCards
        flashcards[id: studyID]?.state = repeatCards.isEmpty ? .difficult : .nextRepeat
    }

    /// Reset the progress.
    mutating func resetProgress() {
        for card in flashcards {
            flashcards[id: card.id]?.state = .repeat
        }
    }

}
