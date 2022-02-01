//
//  WordRowViewModel.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 27/01/2022
//

import Foundation
import CoreData

class WordRowViewModel: ObservableObject, Identifiable {

    private let word: WordMO

    init(word: WordMO) {
        self.word = word
    }

    var id: NSManagedObjectID {
        return word.objectID
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

extension WordRowViewModel: Equatable {
    static func == (lhs: WordRowViewModel, rhs: WordRowViewModel) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.chinese == rhs.chinese &&
            lhs.pinyin == rhs.pinyin &&
            lhs.english == rhs.english
    }
}

