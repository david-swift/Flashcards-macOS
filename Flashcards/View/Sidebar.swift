//
//  Sidebar.swift
//  Flashcards
//
//  Created by david-swift on 12.05.23.
//

import SwiftUI

/// The sidebar of the main window.
struct Sidebar: View {

    /// The app model.
    @EnvironmentObject private var appModel: AppModel
    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel

    /// The view's body.
    var body: some View {
        List(selection: $viewModel.selectedSubject) {
            Label(.init("All Sets", comment: "Sidebar (All sets in sidebar)"), systemSymbol: .rectangleStack)
                .tag(SubjectSelection.allSets)
            Label(.init(
                "Important Sets",
                comment: "Sidebar (Important sets in sidebar)"
            ), systemSymbol: .exclamationmarkCircle)
                .tag(SubjectSelection.importantSets)
            Section(.init("Subjects", comment: "Sidebar (Subjects Section)")) {
                ForEach($appModel.subjects, editActions: .move) { $subject in
                    Label(subject.name, systemSymbol: subject.icon)
                        .tag(SubjectSelection.subject(id: subject.id))
                        .popover(isPresented: { () -> Bool in
                            switch viewModel.selectedSubject {
                            case let .subject(id: selection):
                                return viewModel.editSubject && selection == subject.id
                            default:
                                return false
                            }
                        }()
                        .binding { viewModel.editSubject = $0 }) {
                            SubjectEditor(subject: $subject)
                        }
                        .contextMenu {
                            SubjectContextMenu(subject: $subject)
                        }
                }
            }
        }
        .focusModifier()
    }
}

/// Previews for the ``Sidebar``.
struct Sidebar_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        Sidebar()
    }

}
