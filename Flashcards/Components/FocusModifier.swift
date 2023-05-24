//
//  FocusModifier.swift
//  Flashcards
//
//  Created by david-swift on 14.05.23.
//

import SwiftUI

/// A modifier for controlling the focus.
struct FocusModifier: ViewModifier {

    /// Whether the content is focused.
    @FocusState private var isFocused: Bool
    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel

    /// Get the view with the focus observed.
    /// - Parameter content: The view.
    /// - Returns: The view with the focus observation.
    func body(content: Self.Content) -> some View {
        content
            .focused($isFocused)
            .onChange(of: isFocused) { newValue in
                if newValue {
                    viewModel.selectedFlashcard = nil
                }
            }
            .onChange(of: viewModel.selectedFlashcard) { newValue in
                if newValue != nil && isFocused {
                    isFocused = false
                }
            }
    }

}
