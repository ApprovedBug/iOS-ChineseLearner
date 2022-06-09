//
//  AddWordViewModel.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 27/01/2022
//

import Foundation
import CoreData

class AddWordViewModel: ObservableObject {

    enum State {
        case ready
        case error
        case complete
    }

    @Published var state: State = .ready
    @Published var chinese: String = ""
    @Published var pinyin: String = ""
    @Published var english: String = ""

    private var persistenceController: Persisting

    init(persistenceController: Persisting) {
        self.persistenceController = persistenceController
    }
}

extension AddWordViewModel {

    func add() {

        if chinese.isEmpty || pinyin.isEmpty || english.isEmpty {
            state = .error
            return
        }

        let word = WordMO(context: persistenceController.mainContext)
        word.chinese = chinese
        word.pinyin = pinyin
        word.english = english
        
        persistenceController.saveContext()

        state = .complete
    }

    func dismissError() {
        state = .ready
    }
}
