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
        HStack {
            HStack {
                Text(viewModel.english)
                    .frame(alignment: .leading)
                Spacer()
                Divider()
            }
            .frame(maxWidth: .infinity)
            HStack {
                Spacer()
                Text(viewModel.chinese)
                Spacer()
                Divider()
            }
            .frame(maxWidth: .infinity)
            HStack {
                Spacer()
                Text(viewModel.pinyin)
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(4)
    }
}
