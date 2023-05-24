//
//  SetContextMenu.swift
//  Flashcards
//
//  Created by david-swift on 23.05.23.
//

import SwiftUI

/// The context menu for a set.
struct SetContextMenu: View {

    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel
    /// The set.
    @Binding var set: CardSet

    /// The view's body.
    var body: some View {
        Toggle(String(localized: .init(
            "High Priority",
            comment: "SetContextMenu (High priority toggle)"
        )), isOn: $set.important)
        Button(.init("Delete", comment: "SetContextMenu (Delete button)")) {
            viewModel.deleteSet(id: set.id)
        }
    }
}

/// Previews for the ``SetContextMenu``.
struct SetContextMenu_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        SetContextMenu(set: .constant(.init()))
    }

}
