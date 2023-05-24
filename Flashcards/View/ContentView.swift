//
//  ContentView.swift
//  Flashcards
//
//  Created by david-swift on 10.05.23.
//

import SwiftUI

/// The view of the main window.
struct ContentView: View {

    /// The app model.
    @EnvironmentObject private var appModel: AppModel
    /// The view model.
    @StateObject private var viewModel = ViewModel()

    /// The view's body.
    var body: some View {
        NavigationSplitView {
            Sidebar()
                .toolbar(id: "sidebar") {
                    FlashcardsToolbar(viewModel: viewModel).sidebar
                }
        } content: {
            Content()
                .toolbar(id: "content") {
                    FlashcardsToolbar(viewModel: viewModel).content
                }
        } detail: {
            Detail()
                .toolbar(id: "detail") {
                    FlashcardsToolbar(viewModel: viewModel)
                }
        }
        .environmentObject(viewModel)
        .focusedSceneObject(viewModel)
        .navigationTitle(viewModel.subject?.name ?? "Flashcards")
    }

}

/// Previews for the ``ContentView``.
struct ContentView_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        ContentView()
    }

}
