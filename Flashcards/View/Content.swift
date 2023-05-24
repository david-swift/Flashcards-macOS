//
//  Content.swift
//  Flashcards
//
//  Created by david-swift on 12.05.23.
//

import SwiftUI

/// The list with the sets.
struct Content: View {

    /// The app model.
    @EnvironmentObject private var appModel: AppModel
    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel

    /// The view's body.
    var body: some View {
        List(selection: $viewModel.selectedSet) {
            ForEach((viewModel.subject?.sets ?? []).binding { newValue in
                viewModel.subject?.sets = newValue
            }, editActions: .all) { $set in
                VStack(alignment: .leading) {
                    title(set: set)
                    if !set.description.isEmpty {
                        Text(LocalizedStringResource(stringLiteral: set.description))
                            .font(.caption)
                    }
                }
                .swipeActions(edge: .leading) {
                    Button(.init(
                        "Important",
                        comment: "Content (Title of swipe action for marking set as important)"
                    )) {
                        set.important.toggle()
                    }
                }
                .contextMenu {
                    SetContextMenu(set: $set)
                }
            }
        }
        .focusModifier()
    }

    /// Get the top line of the list item.
    /// - Parameter set: The card set information.
    /// - Returns: The view displaying the information.
    private func title(set: CardSet) -> some View {
        HStack {
            Text(set.important ? "! " : "")
                .foregroundColor(.red)
            +
            Text(set.name)
                .bold()
            Spacer()
            Text(.init(
                "\(set.flashcards.count) Flashcards",
                comment: "Content (Text showing quantity of cards)"
            ))
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }

}

/// Previews for the content view.
struct Content_Previews: PreviewProvider {

    /// The previews.
    static var previews: some View {
        Content()
    }

}
