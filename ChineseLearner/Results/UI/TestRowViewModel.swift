//
//  TestRowViewModel.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 30/01/2022
//

import Foundation

class TestRowViewModel: ObservableObject, Identifiable {

    private var test: TestMO

    init(test: TestMO) {
        self.test = test
    }

    var title: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return "\(formatter.string(from: timeStamp)) - Test score \(correctAnswersCount)/\(totalQuestionsCount)"
    }

    private var timeStamp: Date {
        test.timeStamp ?? Date()
    }

    private var correctAnswersCount: Int {
        correctAnswers.count
    }

    private var totalQuestionsCount: Int {
        test.answers?.allObjects.count ?? 0
    }

    var correctAnswers: [WordRowViewModel] {
        guard let answers = test.answers?.allObjects as? [AnswerMO] else {
            return []
        }

        return answers
            .filter { $0.isCorrect }
            .map({ WordRowViewModel.init(word: $0.word!) })
    }

    var incorrectAnswers: [WordRowViewModel] {
        guard let answers = test.answers?.allObjects as? [AnswerMO] else {
            return []
        }

        return answers
            .filter { !$0.isCorrect }
            .map({ WordRowViewModel.init(word: $0.word!) })
    }
}
