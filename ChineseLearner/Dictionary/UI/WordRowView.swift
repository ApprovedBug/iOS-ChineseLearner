//
//  WordRowView.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 27/01/2022
//

import Foundation
import SwiftUI

struct WordRowView: View {

    private(set) var viewModel: WordRowViewModel

    init(viewModel: WordRowViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        VStack(alignment: .leading) {
            Text(viewModel.chinese)
            Text(viewModel.pinyin)
            Text(viewModel.english)
        }
    }
}
