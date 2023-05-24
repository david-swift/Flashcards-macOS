//
//  FlashcardsApp.swift
//  Flashcards
//
//  Created by david-swift on 10.05.23.
//

import PigeonApp
import SettingsKit
import SwiftUI

/// The Flashcards app.
@main
struct FlashcardsApp: App {

    /// The app model.
    @StateObject private var appModel = AppModel.shared

    /// The app's body.
    var body: some Scene {
        PigeonApp(appName: "Flashcards", appIcon: .init(nsImage: .init(named: "AppIcon") ?? .init())) { _, _, _ in
            ContentView()
                .environmentObject(appModel)
        }
        .information(description: .init(localized: .init(
            "A native macOS app for studying efficiently.",
            comment: "FlashcardsApp (Description)"
        ))) {
            for link in appModel.links {
                (.init(localized: link.0), link.1)
            }
        } contributors: {
            for contributor in appModel.contributors {
                contributor
            }
        } acknowledgements: {
            ("Supabase", .string("https://github.com/supabase-community/supabase-swift"))
            ("SwiftLintPlugin", .string("https://github.com/lukepistrol/SwiftLintPlugin"))
            ("PigeonApp", .string("https://github.com/david-swift/PigeonApp-macOS"))
        }
        .supabase(data: $appModel.subjects, table: .subjectsID)
        .help(
            .init("Flashcards Help", comment: "FlashcardsApp (Help link)"),
            link: .string("https://david-swift.gitbook.io/flashcards/")
        )
        .newestVersion(gitHubUser: "david-swift", gitHubRepo: "Flashcards-macOS")
        .versions {
            for version in appModel.versions {
                version
            }
        }
        .keyboardShortcut("n", modifiers: [.shift, .option, .command])
        .commands {
            FlashcardsCommands()
        }
    }

}
