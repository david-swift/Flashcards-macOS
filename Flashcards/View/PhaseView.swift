//
//  PhaseView.swift
//  Flashcards
//
//  Created by david-swift on 23.05.23.
//

import SwiftUI

/// A view that shows information about the current study state.
struct PhaseView: View {

    /// The app model.
    @EnvironmentObject private var appModel: AppModel
    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel

    /// The view's body.
    var body: some View {
        VStack {
            Text(viewModel.set?.phase ?? .init("No Selection", comment: "PhaseView (No selection phase)"))
                .font(.title)
            if let set = viewModel.set {
                GroupBox {
                    Form {
                        let phase1 = set.repeatCards.count + set.repeatNextCards.count
                        Text(.init("**Phase 1:** \(phase1) Flashcards", comment: "PhaseView (Phase 1)"))
                        Text(.init(
                            "**Phase 2:** \(set.flashcards.count - phase1) Flashcards",
                            comment: "PhaseView (Phase 2)"
                        ))
                        Text(.init(
                            "**Difficult:** \(set.difficultCards.count) Flashcards",
                            comment: "PhaseView (Difficult cards)"
                        ))
                    }
                }
                Button(.init("Reset Progress", comment: "PhaseView (Reset progress button)")) {
                    viewModel.set?.resetProgress()
                }
            }
        }
        .padding()
    }
}

/// Previews for the ``PhaseView``.
struct PhaseView_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        PhaseView()
    }

}
