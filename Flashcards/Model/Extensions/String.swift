//
//  String.swift
//  Flashcards
//
//  Created by david-swift on 11.05.23.
//

import Foundation

extension String {

    /// The identifier of the subjects in the user defaults and on Supabase.
    static var subjectsID: String { "subjects" }
    /// The identifier of the selected subject in the user defaults.
    static var selectedSubjectID: String { "selectedSubject" }
    /// The identifier of the selected set in the user defaults.
    static var selectedSetID: String { "selectedSet" }
    /// The GitHub repository of the Flashcards app.
    static var gitHubRepo: String { "https://github.com/david-swift/Flashcards-macOS" }
    /// The URL to a new issue for a feature request.
    static var featureRequest: String {
        gitHubRepo
        + "/issues/new?assignees=&labels=enhancement&template=feature_request.yml"
    }
    /// The URL to a new issue for a bug report.
    static var bugReport: String {
        gitHubRepo
        + "/issues/new?assignees=&labels=bug&template=bug_report.yml"
    }

}
