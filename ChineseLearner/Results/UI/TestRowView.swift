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
        VStack {
            Text(viewModel.title)

            List(viewModel.correctAnswers) { answer in
                WordRowView(viewModel: answer)
            }
        }
    }
}
