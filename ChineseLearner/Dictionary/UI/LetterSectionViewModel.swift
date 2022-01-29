//
//  LetterSectionViewModel.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 29/01/2022
//

import Foundation

class LetterSectionViewModel: ObservableObject, Identifiable {

    private(set) var letter: String
    private(set) var words: [WordRowViewModel]

    init(letter: String, words: [WordRowViewModel]) {
        self.letter = letter
        self.words = words
    }
}
