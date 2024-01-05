//
//  FlashcardsToolbar.swift
//  Flashcards
//
//  Created by david-swift on 10.05.23.
//

import SwiftUI

/// The toolbar of the main window of the Flashcards app.
struct FlashcardsToolbar: CustomizableToolbarContent {

    /// The view model.
    @ObservedObject var viewModel: ViewModel

    /// The toolbar of the detail view.
    var body: some CustomizableToolbarContent {
        ToolbarItem(id: "play") {
            Button {
                viewModel.study()
            } label: {
                Label(.init(
                    "Study Set",
                    comment: "FlashcardsToolbar (Button for studying a set)"
                ), systemSymbol: viewModel.play ? .pause : .play)
            }
        }
        ToolbarItem(id: "status") {
            Button(((viewModel.play ? viewModel.set?.phase : .init(
                "Edit Mode",
                comment: "FlashcardsToolbar (Edit mode)"
            )) ?? .init(
                "No Selection",
                comment: "FlashcardsToolbar (No selection)"
            )).localized) {
                viewModel.showPhase.toggle()
            }
        }
        ToolbarItem(id: "add-card") {
            Button {
                viewModel.addFlashcard()
            } label: {
                Label(.init(
                    "Add Flashcard",
                    comment: "FlashcardsToolbar (Button for adding a flashcard)"
                ), systemSymbol: .plus)
            }
        }
        ToolbarItem(id: "delete-flashcard") {
            Button {
                viewModel.deleteFlashcard(id: viewModel.selectedFlashcard ?? .init())
            } label: {
                Label(.init(
                    "Delete Flashcard",
                    comment: "FlashcardsToolbar (Delete flashcard button)"
                ), systemSymbol: .trash)
            }
            .disabled(viewModel.selectedFlashcard == nil)
        }
        .defaultCustomization(.hidden)
        ToolbarItem(id: "ask-front") {
            Toggle(isOn: $viewModel.askFront) {
                Label(.init(
                    "Ask With Front",
                    comment: "FlashcardsToolbar (Whether to ask with the front side)"
                ), systemSymbol: .rectangleStack)
            }
            .disabled(!viewModel.play)
        }
        .defaultCustomization(.hidden)
    }

    /// The toolbar of the content view.
    @ToolbarContentBuilder var content: some CustomizableToolbarContent {
        ToolbarItem(id: "add-set") {
            Button {
                viewModel.addSet()
            } label: {
                Label(.init(
                    "Add Set",
                    comment: "FlashcardsToolbar (Button for adding a set)"
                ), systemSymbol: .squareAndPencil)
            }
            .disabled(viewModel.selectedSubject == .allSets || viewModel.selectedSubject == .importantSets)
        }
        ToolbarItem(id: "high-priority") {
            Toggle(isOn: (viewModel.set?.important ?? false).binding { viewModel.set?.important = $0 }) {
                Label(.init(
                    "High Priority",
                    comment: "FlashcardsToolbar (High priority toggle)"
                ), systemSymbol: .exclamationmark)
            }
            .disabled(viewModel.set == nil)
        }
        .defaultCustomization(.hidden)
        ToolbarItem(id: "delete-set") {
            Button {
                viewModel.deleteSet(id: viewModel.set?.id ?? .init())
            } label: {
                Label(.init("Delete Set", comment: "FlashcardsToolbar (Delete set button)"), systemSymbol: .trash)
            }
            .disabled(viewModel.set == nil)
        }
        .defaultCustomization(.hidden)
    }

    /// The toolbar of the sidebar view.
    @ToolbarContentBuilder var sidebar: some CustomizableToolbarContent {
        ToolbarItem(id: "add-subject") {
            Button {
                viewModel.addSubject()
            } label: {
                Label(.init(
                    "Add Subject",
                    comment: "FlashcardsToolbar (Button for adding a subject)"
                ), systemSymbol: .plus)
            }
        }
        ToolbarItem(id: "edit-subject") {
            Button {
                viewModel.editSubject.toggle()
            } label: {
                Label(.init(
                    "Edit Subject",
                    comment: "FlashcardsToolbar (Button for editing a subject)"
                ), systemSymbol: .pencil)
            }
            .disabled(viewModel.selectedSubject == .allSets || viewModel.selectedSubject == .importantSets)
        }
        .defaultCustomization(.hidden)
        ToolbarItem(id: "delete-subject") {
            Button {
                viewModel.deleteSubject(id: viewModel.subject?.id ?? .init())
            } label: {
                Label(.init(
                    "Delete Subject",
                    comment: "FlashcardsToolbar (Button for delete a subject)"
                ), systemSymbol: .trash)
            }
            .disabled(viewModel.subject?.id == nil)
        }
        .defaultCustomization(.hidden)
    }

}
