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

            let dictionaryViewModel = DictionaryViewModel(persistenceController: persistenceController)
            let practiceViewModel = PracticeViewModel(persistenceController: persistenceController)
            let resultsViewModel = ResultsViewModel(persistenceController: persistenceController)

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
