//
//  AchievementsView.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 30/01/2022
//

import Foundation
import SwiftUI

struct ResultsView: View {

    @ObservedObject var viewModel: ResultsViewModel

    init(viewModel: ResultsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        NavigationView {
            VStack {

                switch viewModel.state {
                case .loading:
                    ProgressView()
                        .onAppear(perform: viewModel.fetchResults)
                case .ready(let tests):
                    resultsView(tests: tests)
                case .empty:
                    emptyView
                }
            }
            .navigationBarTitle("Results")
            .listStyle(.insetGrouped)
        }
    }
}

extension ResultsView {

    private var emptyView: some View {
        VStack(alignment: .leading) {
            Text("Welcome to your progress tracker\n\nThis section contains a record of all your test results, so you can track your language learning progress.")
                .padding(.bottom, 32)
            Button(action: viewModel.takeTest) {
                HStack {
                    Spacer()
                    Text("Take a test")
                    Spacer()
                }
            }
            .buttonStyle(LightGreyButtonStyle())
            Spacer()
        }
        .padding()
    }

    private func resultsView(tests: [TestRowViewModel]) -> some View {
        List(tests) { test in
            TestRowView(viewModel: test)
        }
    }
}
