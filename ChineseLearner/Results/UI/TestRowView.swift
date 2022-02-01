//
//  TestRowView.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 30/01/2022
//

import Foundation
import SwiftUI

struct TestRowView: View {

    private var viewModel: TestRowViewModel

    init(viewModel: TestRowViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Section(header: Text(viewModel.title)
                    .font(.subheadline)) {

            VStack(alignment: .leading) {
                Text("Correct answers")
                    .font(.headline)
                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 0, trailing: 0))
                ForEach(viewModel.correctAnswers) { answer in
                    HStack {
                        WordRowView(viewModel: answer)
                        Image(systemName: "checkmark.square.fill")
                    }
                }
                if viewModel.incorrectAnswers.count > 0 {
                    Divider()
                    Text("Incorrect answers")
                        .font(.headline)
                        .padding(EdgeInsets(top: 4, leading: 4, bottom: 0, trailing: 0))
                    ForEach(viewModel.incorrectAnswers) { answer in
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
