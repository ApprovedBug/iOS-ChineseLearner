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
    let persistenceController = PersistenceController()

    var body: some Scene {

        appDelegate.persistenceController = persistenceController
        
        return WindowGroup {

            let dictionaryViewModel = DictionaryViewModel(viewContext: persistenceController.mainContext)
            let practiceViewModel = PracticeViewModel(viewContext: persistenceController.mainContext)
            let resultsViewModel = ResultsViewModel(viewContext: persistenceController.mainContext)

            TabView {
                DictionaryView(viewModel: dictionaryViewModel)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }

                PracticeView(viewModel: practiceViewModel)
                    .tabItem {
                        Image(systemName: "book")
                        Text("Study")
                    }

                ResultsView(viewModel: resultsViewModel)
                    .tabItem {
                        Image(systemName: "p.circle")
                        Text("Progress")
                    }
            }
        }
    }
}
