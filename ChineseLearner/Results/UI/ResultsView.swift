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
                    Text("Go do your first test to see your results here!")
                }
            }
            .navigationBarTitle("Results")
        }
    }
}

extension ResultsView {

    private func resultsView(tests: [TestRowViewModel]) -> some View {
        List(tests) { test in
            Section(header: Text(test.title)
                        .font(.subheadline)) {

                VStack(alignment: .leading) {
                    Text("Correct answers")
                        .font(.headline)
                        .padding(EdgeInsets(top: 4, leading: 4, bottom: 0, trailing: 0))
                    ForEach(test.correctAnswers) { answer in
                        HStack {
                            WordRowView(viewModel: answer)
                            Image(systemName: "checkmark.square.fill")
                        }
                    }
                    if test.incorrectAnswers.count > 0 {
                        Divider()
                        Text("Incorrect answers")
                            .font(.headline)
                        ForEach(test.incorrectAnswers) { answer in
                            HStack {
                                WordRowView(viewModel: answer)
                                Image(systemName: "multiply.square.fill")
                            }
                        }
                    }
                }
            }
        }
    }
}
