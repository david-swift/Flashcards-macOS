//
//  Detail.swift
//  Flashcards
//
//  Created by david-swift on 12.05.23.
//

import ColibriComponents
import SwiftUI

/// The detail view.
struct Detail: View {

    /// The app model.
    @EnvironmentObject private var appModel: AppModel
    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel

    /// The minimal width of the detail view.
    let detailMinWidth: CGFloat = 350
    /// The minimal height of the detail view.
    let detailMinHeight: CGFloat = 200
    /// The height of the space for the freeform toolbar.
    let freeformToolbarHeight: CGFloat = 100

    /// The view's body.
    var body: some View {
        ZStack {
            if let set = viewModel.set {
                let bindingSet = set.binding { newValue in
                    viewModel.set = newValue
                }
                content(bindingSet: bindingSet)
            } else {
                Text(.init("No Set Selected", comment: "Detail (No selection text)"))
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
            }
        }
        .frame(minWidth: detailMinWidth, minHeight: detailMinHeight)
        .sheet(isPresented: $viewModel.showPhase) {
            PhaseView()
        }
    }

    /// The content of a set displayed.
    /// - Parameter bindingSet: The set.
    /// - Returns: The content in a view.
    @ViewBuilder
    private func content(bindingSet: Binding<CardSet>) -> some View {
        if viewModel.play {
            StudyView(set: bindingSet)
        } else {
            ScrollViewReader { reader in
                ScrollView {
                    LazyVStack {
                        header(bindingSet: bindingSet)
                        ForEach(bindingSet.flashcards) { flashcard in
                            FlashcardEditor(flashcard: flashcard)
                                .id(flashcard.id)
                        }
                        Color.clear
                            .frame(height: freeformToolbarHeight)
                            .freeformToolbar(visibility: true) {
                                ToolbarAction(.init(localized: .init(
                                    "Add Card",
                                    comment: "Detail (Button for adding a card)"
                                )), systemSymbol: .plus) {
                                    bindingSet.wrappedValue.flashcards.append(.init())
                                }
                            }
                    }
                    .padding()
                    .textFieldStyle(.plain)
                }
                .onChange(of: viewModel.selectedFlashcard) { newValue in
                    withAnimation {
                        reader.scrollTo(newValue, anchor: .top)
                    }
                }
            }
        }
    }

    /// The header containing a title and description text field.
    /// - Parameter bindingSet: The set.
    /// - Returns: The header.
    private func header(bindingSet: Binding<CardSet>) -> some View {
        VStack {
            TextField(.init("Title", comment: "Detail (Title text field)"), text: bindingSet.name)
                .font(.title)
                .bold()
            TextField(.init(
                "Description",
                comment: "Detail (Description text field)"
            ), text: bindingSet.description)
        }
        .padding()
    }

}

/// The previews for ``Detail``.
struct Detail_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        Detail()
    }

}
