//
//  ChineseLearnerApp.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 26/01/2022
//

import SwiftUI

@main
struct ChineseLearnerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {

            let viewModel = DictionaryViewModel(viewContext: persistenceController.container.viewContext)

            DictionaryView(viewModel: viewModel)
        }
    }
}
