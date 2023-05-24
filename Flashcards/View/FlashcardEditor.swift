//
//  FlashcardEditor.swift
//  Flashcards
//
//  Created by david-swift on 13.05.23.
//

import ColibriComponents
import SwiftUI

/// The editor for a flashcard.
struct FlashcardEditor: View {

    /// The app model.
    @EnvironmentObject private var appModel: AppModel
    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel
    /// Whether the flashcard is focused.
    @FocusState private var isFocused: Bool
    /// The flashcard.
    @Binding var flashcard: Flashcard
    /// Whether the toolbar is hovered.
    @State private var hover = false

    /// The width of the selection stroke line.
    let strokeLineWidth: CGFloat = 5
    /// The opacity of the black of the shadow.
    let shadowBlackOpacity: CGFloat = 0.1
    /// The radius of the shadow.
    let shadowRadius: CGFloat = 30
    /// The vertical offset of the freeform toolbar.
    let freeformToolbarOffset: CGFloat = 10
    /// The opacity of the freeform toolbar when not hovered.
    let freeformToolbarOpacity: CGFloat = 0.25

    /// Whether the flashcard is selected.
    private var isSelected: Bool {
        viewModel.selectedFlashcard == flashcard.id
    }

    /// The view's body.
    var body: some View {
        Group {
            toolbar
            sideEditors
                .padding()
                .background(.bar, in: RoundedRectangle(cornerRadius: .colibriCornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: .colibriCornerRadius)
                        .stroke(lineWidth: strokeLineWidth)
                        .foregroundColor(.accentColor)
                        .opacity(isSelected ? 1 : 0)
                        .animation(.default, value: isSelected)
                }
                .shadow(color: .black.opacity(shadowBlackOpacity), radius: shadowRadius)
                .contentShape(Rectangle())
                .onTapGesture {
                    if isSelected {
                        viewModel.selectedFlashcard = nil
                    } else {
                        viewModel.selectedFlashcard = flashcard.id
                    }
                }
                .accessibilityAddTraits(.isButton)
                .focused($isFocused)
                .onChange(of: isFocused) { newValue in
                    if newValue {
                        viewModel.selectedFlashcard = flashcard.id
                    } else if isSelected {
                        viewModel.selectedFlashcard = nil
                    }
                }
        }
    }

    /// The flashcard's toolbar.
    private var toolbar: some View {
        Color.clear
            .zIndex(1)
            .freeformToolbar(visibility: true, y: freeformToolbarOffset) {
                ToolbarAction(.init(localized: .init(
                    "Add Side",
                    comment: "FlashcardEditor (Button for adding a side)"
                )), systemSymbol: .plus) {
                    flashcard.back.append(.init())
                }
                if flashcard.back.count > 1 {
                    ToolbarAction(.init(localized: .init(
                        "Delete Last Side",
                        comment: "FlashcardEditor (Button for deleting the last side)"
                    )), systemSymbol: .minus) {
                        if flashcard.back.count > 1 {
                            _ = flashcard.back.popLast()
                        }
                    }
                }
                ToolbarAction(.init(localized: .init(
                    "Delete Flashcard",
                    comment: "FlashcardEditor (Button for deleting the flashcard)"
                )), systemSymbol: .trash) {
                    viewModel.deleteFlashcard(id: flashcard.id)
                }
            }
            .opacity(hover ? 1 : freeformToolbarOpacity)
            .animation(.default, value: hover)
            .onHover { hover = $0 }
    }

    /// The flashcard's side editors.
    private var sideEditors: some View {
        HStack {
            SideEditor(side: $flashcard.front)
            Divider()
                .padding(.horizontal)
            VStack {
                ForEach($flashcard.back) { back in
                    SideEditor(side: back)
                }
            }
        }
    }

}

/// Previews for the ``FlashcardEditor``.
struct FlashcardEditor_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        FlashcardEditor(flashcard: .constant(.init()))
    }

}
