//
//  AppModel.swift
//  Flashcards
//
//  Created by david-swift on 10.05.23.
//

import ColibriComponents
import Foundation
import PigeonApp
import Supabase

/// The app model.
@MainActor
class AppModel: ObservableObject {

    /// A shared instance of the app model.
    static var shared = AppModel()
    /// A list of all of the contributors.
    @Published var contributors: [(String, URL)] = []
    /// The flashcards.
    @Published var subjects: [Subject] = [] {
        didSet {
            if oldValue != subjects {
                UndoProvider.registerUndo(withTarget: self) { $0.subjects = oldValue }
            }
            if let data = try? JSONEncoder().encode(subjects) {
                UserDefaults.standard.set(data, forKey: .subjectsID)
            }
        }
    }

    /// Important links.
    let links: [(LocalizedStringResource, URL)] = [
        (
            .init("GitHub", comment: "AppModel (Label of the link to the GitHub repository)"),
            .string(.gitHubRepo)
        ),
        (
            .init("Bug Report", comment: "AppModel (Label of the link to the bug report issue"),
            .string(.bugReport)
        ),
        (
            .init("Feature Request", comment: "AppModel (Label of the link to the feature request issue"),
            .string(.featureRequest)
        )
    ]

    // swiftlint:disable no_magic_numbers
    /// The app's versions.
    @ArrayBuilder<Version> var versions: [Version] {
        Version("0.1.0", date: .init(timeIntervalSince1970: 1_684_955_336)) {
            Version.Feature(.init(
                "Initial Release",
                comment: "AppModel (Feature in version 0.1.0)"
            ), description: .init(
                "The first release of the Flashcards app.",
                comment: "AppModel (Description of feature in version 0.1.0)"
            ), icon: .partyPopper)
        }
    }
    // swiftlint:enable no_magic_numbers

    /// The initializer.
    init() {
        getContributors()
        getSubjects()
    }

    /// Get the contributors from the Contributors.md file.
    private func getContributors() {
        let regex = /- \[(?<name>.+?)]\((?<link>.+?)\)/
        do {
            if let path = Bundle.main.path(forResource: "Contributors", ofType: "md") {
                let lines: [String] = try String(contentsOfFile: path).components(separatedBy: "\n")
                for line in lines where line.hasPrefix("- ") {
                    if let result = try? regex.wholeMatch(in: line), let url = URL(string: .init(result.output.link)) {
                        contributors.append((.init(result.output.name), url))
                    }
                }
            }
        } catch { }
    }

    /// Get the subjects from the disk.
    private func getSubjects() {
        if let data = UserDefaults.standard.data(forKey: .subjectsID),
           let subjects = try? JSONDecoder().decode([Subject].self, from: data) {
            self.subjects = subjects
        }
    }

}
