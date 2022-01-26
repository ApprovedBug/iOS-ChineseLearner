//
//  ChineseLearnerApp.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 26/01/2022
//

import SwiftUI

@main
struct ChineseLearnerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
