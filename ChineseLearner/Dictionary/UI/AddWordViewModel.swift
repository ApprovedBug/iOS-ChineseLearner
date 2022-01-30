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

    private var viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
}

extension AddWordViewModel {

    func add() {

        if chinese.isEmpty || pinyin.isEmpty || english.isEmpty {
            state = .error
            return
        }

        let word = WordMO(context: viewContext)
        word.chinese = chinese
        word.pinyin = pinyin
        word.english = english.lowercased()

        state = .complete
    }

    func dismissError() {
        state = .ready
    }
}
