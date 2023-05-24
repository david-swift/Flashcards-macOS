//
//  FlashcardsCommands.swift
//  Flashcards
//
//  Created by david-swift on 10.05.23.
//

import SwiftUI

/// The commands of the Flashcards app.
struct FlashcardsCommands: Commands {

    /// The view model.
    @FocusedObject private var viewModel: ViewModel?

    /// The commands body.
    var body: some Commands {
        CommandGroup(before: .newItem) {
            Group {
                Button(.init("New Flashcard", comment: "FlashcardsCommands (New flashcard button)")) {
                    viewModel?.addFlashcard()
                }
                .keyboardShortcut("n")
                .disabled(viewModel?.set == nil)
                Button(.init("New Set", comment: "FlashcardsCommands (New set button)")) {
                    viewModel?.addSet()
                }
                .keyboardShortcut("n", modifiers: [.shift, .command])
                .disabled(viewModel?.selectedSubject == .allSets || viewModel?.selectedSubject == .importantSets)
                Button(.init("New Subject", comment: "FlashcardsCommands (New subject button)")) {
                    viewModel?.addSubject()
                }
                .keyboardShortcut("n", modifiers: [.option, .command])
            }
            .disabled(noViewModel)
        }
        CommandGroup(after: .pasteboard) {
            editActions
        }
        CommandMenu(.init("Study", comment: "FlashcardsCommands (Study menu)")) {
            studyMenu
        }
        SidebarCommands()
    }

    /// Whether there is a view model.
    private var noViewModel: Bool {
        viewModel == nil
    }

    /// The actions in the `Edit` toolbar menu.
    private var editActions: some View {
        Group {
            Divider()
            Button(.init("Delete Flashcard", comment: "FlashcardsCommands (Delete flashcard button)")) {
                viewModel?.deleteFlashcard(id: viewModel?.selectedFlashcard ?? .init())
            }
            .keyboardShortcut(.delete)
            .disabled(viewModel?.selectedFlashcard == nil)
            Button(.init("Delete Set", comment: "FlashcardsCommands (Delete set button)")) {
                viewModel?.deleteSet(id: viewModel?.set?.id ?? .init())
            }
            .keyboardShortcut(.delete, modifiers: [.shift, .command])
            .disabled(viewModel?.set == nil)
            Group {
                Button(.init("Delete Subject", comment: "FlashcardsCommands (Delete subject button)")) {
                    viewModel?.deleteSubject(id: viewModel?.subject?.id ?? .init())
                }
                .keyboardShortcut(.delete, modifiers: [.option, .command])
                Divider()
                Button(.init("Edit Subject", comment: "FlashcardsCommands (Edit subject button)")) {
                    viewModel?.editSubject.toggle()
                }
                .keyboardShortcut("e")
            }
            .disabled(viewModel?.selectedSubject == .allSets || viewModel?.selectedSubject == .importantSets)
            Toggle(String(localized: .init(
                "High Priority",
                comment: "FlashcardsCommands (High priority toggle)"
            )), isOn: (viewModel?.set?.important ?? false).binding { viewModel?.set?.important = $0 })
            .keyboardShortcut(.upArrow)
            .disabled(viewModel?.set == nil)
        }
        .disabled(noViewModel)
    }

    /// The picker for selecting the side for asking.
    private var askPicker: some View {
        Picker(.init(
            "Ask With",
            comment: "FlashcardsCommands (Set front picker)"
        ), selection: (viewModel?.askFront ?? true).binding { newValue in
            viewModel?.askFront = newValue
        }) {
            Text(.init("Front", comment: "FlashcardsCommands (Ask with front)"))
                .tag(true)
            Text(.init("Back", comment: "FlashcardsCommands (Ask with back)"))
                .tag(false)
        }
    }

    /// The menu for studying.
    @ViewBuilder private var studyMenu: some View {
        Button((viewModel?.play ?? false) ? .init(
            "Stop",
            comment: "FlashcardsCommands (Button for stopping study mode)"
        ) : .init(
            "Start",
            comment: "FlashcardssCommands (Button for starting study mode)"
        )) {
            viewModel?.study()
        }
        .disabled(viewModel == nil)
        .keyboardShortcut(.return)
        Divider()
        Group {
            studyButtons
            askPicker
        }
        .disabled(viewModel?.play != true)
    }

    /// Buttons for studying.
    @ViewBuilder private var studyButtons: some View {
        Button(.init("Turn Over", comment: "FlashcardsCommand (Button for turning over card)")) {
            viewModel?.ask.toggle()
        }
        .keyboardShortcut(.return, modifiers: [])
        Button(.init("Right Answer", comment: "FlashcardsCommand (Button for marking card as known)")) {
            withAnimation {
                viewModel?.set?.right()
                viewModel?.ask = true
            }
        }
        .keyboardShortcut(.rightArrow)
        Button(.init("Wrong Answer", comment: "FlashcardsCommand (Button for marking card as not known)")) {
            withAnimation {
                viewModel?.set?.wrong()
                viewModel?.ask = true
            }
        }
        .keyboardShortcut(.leftArrow)
        Divider()
        Button(.init("Next Side", comment: "FlashcardsCommand (Button for navigating to the next side)")) {
            viewModel?.stackIndex += 1
        }
        .keyboardShortcut(.rightArrow, modifiers: [])
        Button(.init(
            "Previous Side",
            comment: "FlashcardsCommand (Button for navigating to the previous side)"
        )) {
            viewModel?.stackIndex -= 1
        }
        .keyboardShortcut(.leftArrow, modifiers: [])
        Button(.init("Toggle Help", comment: "FlashcardsCommand (Button for toggling the help popover)")) {
            viewModel?.showHelp.toggle()
        }
        .keyboardShortcut("h", modifiers: [.shift, .command])
    }

}
