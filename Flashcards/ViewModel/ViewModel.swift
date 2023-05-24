//
//  ViewModel.swift
//  Flashcards
//
//  Created by david-swift on 10.05.23.
//

import ColibriComponents
import Foundation
import SwiftUI

/// A model used for one window.
@MainActor
class ViewModel: ObservableObject {

    /// The selected subject.
    @Published var selectedSubject: SubjectSelection = .allSets {
        didSet {
            if let data = try? JSONEncoder().encode(selectedSubject) {
                UserDefaults.standard.set(data, forKey: .selectedSubjectID)
            }
        }
    }
    /// The selected set's id.
    @Published var selectedSet: UUID? {
        didSet {
            if let data = try? JSONEncoder().encode(selectedSet) {
                UserDefaults.standard.set(data, forKey: .selectedSetID)
            }
        }
    }
    /// The selected flashcard's id.
    @Published var selectedFlashcard: UUID?
    /// Whether the study mode is active.
    @Published var play = false
    /// Whether the front side is for asking.
    @Published var askFront = true
    /// Whether the flashcard's ask side is currently visible.
    @Published var ask = true
    /// A navigation through the sides.
    @Published var stackIndex = 0 {
        didSet {
            if stackIndex < 0 {
                stackIndex = 0
            }
        }
    }
    /// Whether the help overlay is visible.
    @Published var showHelp = false
    /// Whether the phase sheet is visible.
    @Published var showPhase = false
    /// Whether the edit subject overlay is visible.
    @Published var editSubject = false

    /// Whether the front side of the flashcard is displayed.
    var showFront: Bool {
        (askFront && ask) || (!askFront && !ask)
    }

    /// The currently selected subject.
    var subject: Subject? {
        get {
            if case let .subject(id: subject) = selectedSubject {
                return AppModel.shared.subjects[id: subject]
            } else if case .allSets = selectedSubject {
                return .init(name: .init("All Sets", comment: "ViewModel (All sets)"), sets: {
                    var sets: [CardSet] = []
                    for subject in AppModel.shared.subjects {
                        sets += subject.sets
                    }
                    return sets
                }())
            } else if case .importantSets = selectedSubject {
                return .init(name: .init("Important Sets", comment: "ViewModel (Important sets)"), sets: {
                    var sets: [CardSet] = []
                    for subject in AppModel.shared.subjects {
                        sets += subject.sets.filter { $0.important }
                    }
                    return sets
                }())
            }
            return nil
        }
        set {
            if case let .subject(id: subject) = selectedSubject {
                AppModel.shared.subjects[id: subject] = newValue
            } else if case .allSets = selectedSubject {
                changesLoop: for set in newValue?.sets ?? [] {
                    for (index, subject) in AppModel.shared.subjects.enumerated()
                    where subject.sets[id: set.id] != nil {
                        AppModel.shared.subjects[safe: index]?.sets[id: set.id] = set
                        continue changesLoop
                    }
                }
                for index in AppModel.shared.subjects.indices {
                    if let sets = AppModel.shared.subjects[safe: index]?.sets.filter({ cardSet in
                        newValue?.sets.contains { $0.id == cardSet.id } ?? true }) {
                        AppModel.shared.subjects[safe: index]?.sets = sets
                    }
                }
            } else if case .importantSets = selectedSubject {
                changesLoop: for set in newValue?.sets ?? [] {
                    for (index, subject) in AppModel.shared.subjects.enumerated()
                    where subject.sets[id: set.id] != nil {
                        AppModel.shared.subjects[safe: index]?.sets[id: set.id] = set
                        continue changesLoop
                    }
                }
                for index in AppModel.shared.subjects.indices {
                    if let sets = AppModel.shared.subjects[safe: index]?.sets.filter({ cardSet in
                        cardSet.important == false || (newValue?.sets.contains { $0.id == cardSet.id } ?? true)
                    }) {
                        AppModel.shared.subjects[safe: index]?.sets = sets
                    }
                }
            }
        }
    }

    /// The currently selected set.
    var set: CardSet? {
        get {
            subject?.sets[id: selectedSet]
        }
        set {
            subject?.sets[id: selectedSet] = newValue
        }
    }

    /// The initializer.
    init() {
        if let data = UserDefaults.standard.value(forKey: .selectedSubjectID) as? Data,
           let selection = try? JSONDecoder().decode(SubjectSelection.self, from: data) {
            selectedSubject = selection
        }
        if let data = UserDefaults.standard.value(forKey: .selectedSetID) as? Data,
           let selection = try? JSONDecoder().decode(UUID?.self, from: data) {
            selectedSet = selection
        }
    }

    /// Add a subject.
    func addSubject() {
        AppModel.shared.subjects.append(.init())
    }

    /// Add a set.
    func addSet() {
        subject?.sets.append(.init())
    }

    /// Add a flashcard.
    func addFlashcard() {
        withAnimation {
            let newFlashcard = Flashcard()
            set?.flashcards.append(newFlashcard)
            selectedFlashcard = newFlashcard.id
        }
    }

    /// Change to study mode.
    func study() {
        play.toggle()
    }

    /// Delete a flashcard.
    /// - Parameter id: The flashcard's identifier.
    func deleteFlashcard(id: UUID) {
        withAnimation {
            if let flashcards = set?.flashcards.filter({ $0.id != id }) {
                set?.flashcards = flashcards
            }
        }
    }

    /// Delete a subject.
    /// - Parameter id: The subject's identifier.
    func deleteSubject(id: UUID) {
        withAnimation {
            AppModel.shared.subjects = AppModel.shared.subjects.filter { $0.id != id }
        }
    }

    /// Delete a set.
    /// - Parameter id: The set's identifier.
    func deleteSet(id: UUID) {
        withAnimation {
            if let sets = subject?.sets.filter({ $0.id != id }) {
                subject?.sets = sets
            }
        }
    }

}
