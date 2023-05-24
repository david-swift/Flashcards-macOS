//
//  SubjectEditor.swift
//  Flashcards
//
//  Created by david-swift on 23.05.23.
//

import ColibriComponents
import PigeonApp
import SFSafeSymbols
import SwiftUI

/// An editor for a subject.
struct SubjectEditor: View {

    /// The subject.
    @Binding var subject: Subject

    /// The subject editor's width.
    let width: CGFloat = 300
    /// The subject editor's height.
    let height: CGFloat = 300

    /// The view's body.
    var body: some View {
        VStack {
            TextField(.init("Title", comment: "SubjectEditor (Title text field)"), text: $subject.name)
                .padding([.horizontal, .top])
            ScrollView {
                SelectionItemPicker(selection: subject.icon.rawValue.binding { newValue in
                    subject.icon = .init(rawValue: newValue)
                }, items: SFSymbol.allSymbols.filter { !$0.title.hasSuffix("Fill") }.sorted { $0.title < $1.title })
            }
            .frame(width: width, height: height)
        }
    }
}

/// Previews for the ``SubjectEditor``.
struct SubjectEditor_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        SubjectEditor(subject: .constant(.init()))
    }

}
