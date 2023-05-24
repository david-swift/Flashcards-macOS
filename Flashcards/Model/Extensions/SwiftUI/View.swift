//
//  View.swift
//  Flashcards
//
//  Created by david-swift on 14.05.23.
//

import SwiftUI

extension View {

    func imageOverlayButton() -> some View {
        let buttonPadding: CGFloat = 5
        let backgroundOpacity: CGFloat = 0.5
        return padding(buttonPadding)
            .background(
                .background.opacity(backgroundOpacity),
                in: RoundedRectangle(cornerRadius: .colibriCornerRadius)
            )
    }

    func focusModifier() -> some View {
        modifier(FocusModifier())
    }

}
