//
//  SubjectContextMenu.swift
//  Flashcards
//
//  Created by david-swift on 23.05.23.
//

import SwiftUI

/// The context menu in the subject list.
struct SubjectContextMenu: View {

    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel
    /// The subject.
    @Binding var subject: Subject

    /// The view's body.
    var body: some View {
        Button(.init("Edit", comment: "SubjectContextMenu (Edit a subject)")) {
            viewModel.selectedSubject = .subject(id: subject.id)
            viewModel.editSubject = true
        }
        Button(.init("Delete", comment: "SubjectContextMenu (Delete a subject)")) {
            viewModel.deleteSubject(id: subject.id)
        }
    }
}

/// Previews for the ``SubjectContextMenu``.
struct SubjectContextMenu_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        SubjectContextMenu(subject: .constant(.init()))
    }

}
