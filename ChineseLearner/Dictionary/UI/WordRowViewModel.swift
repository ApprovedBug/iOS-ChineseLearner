//
//  WordRowViewModel.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 27/01/2022
//

import Foundation

class WordRowViewModel: ObservableObject, Identifiable {

    private let word: WordMO

    init(word: WordMO) {
        self.word = word
    }

    var chinese: String {
        word.chinese
    }

    var pinyin: String {
        word.pinyin
    }

    var english: String {
        word.english
    }
}

