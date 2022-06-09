//
//  PracticeViewModel.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 30/01/2022
//

import Foundation
import SwiftUI
import CoreData
import Combine

class PracticeViewModel: NSObject, ObservableObject {

    enum State {
        case ready
        case practiceReady(String)
        case practiceCorrect(String)
        case practiceIncorrect(String)
        case summary(Int, Int)
    }

    @Published private(set) var state: State = .ready
    @Published var chineseAnswer: String = ""
    @Published var pinyinAnswer: String = ""
    @Published private var currentWordIndex: Int = 0

    private var persistenceController: Persisting
    private let fetchedResultsController: NSFetchedResultsController<WordMO>
    private var randomisedWords: [WordMO] = []
    private var disposables = Set<AnyCancellable>()
    private var correctAnswerIndexes: [Int] = []
    private var skippedQuestionIndexes: [Int] = []

    init(persistenceController: Persisting) {
        self.persistenceController = persistenceController

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: WordMO.all,
            managedObjectContext: persistenceController.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)

        super.init()
        $currentWordIndex
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in

                guard let self = self else { return }

                if value == 0 {
                    return
                } else if value < self.randomisedWords.count {
                    self.displayWord(index: value)
                } else {
                    self.endPractice()
                }

            })
            .store(in: &disposables)
    }
}

extension PracticeViewModel {

    func beginPractice() {

        do {
            try fetchedResultsController.performFetch()

            guard let words = fetchedResultsController.fetchedObjects else {
                return
            }

            if words.isEmpty {
                // TODO: prompt user to adds words to their dictionary
            } else {
                randomisedWords = words.shuffled()

                state = .practiceReady(randomisedWords[currentWordIndex].english)
            }
        } catch {
            // error
        }
    }

    func checkAnswer() {
        let word = randomisedWords[currentWordIndex]

        if chineseAnswer == word.chinese && pinyinAnswer == word.pinyin {
            state = .practiceCorrect(word.english)
            correctAnswerIndexes.append(currentWordIndex)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.currentWordIndex += 1
            }
        } else {
            state = .practiceIncorrect(word.english)
        }
    }

    func skip() {
        skippedQuestionIndexes.append(currentWordIndex)
        currentWordIndex += 1
    }

    func endPractice() {

        currentWordIndex = 0

        if skippedQuestionIndexes.isEmpty && correctAnswerIndexes.isEmpty {
            state = .ready
        } else {
            saveTestResult()

            state = .summary(correctAnswerIndexes.count, skippedQuestionIndexes.count)
        }

        guard let words = fetchedResultsController.fetchedObjects else {
            return
        }

        randomisedWords = words.shuffled()
    }

    func closeSummary() {
        state = .ready

        skippedQuestionIndexes.removeAll()
        correctAnswerIndexes.removeAll()
    }

    private func displayWord(index: Int) {
        chineseAnswer = ""
        pinyinAnswer = ""
        state = .practiceReady(randomisedWords[index].english)
    }

    private func saveTestResult() {
        var answers: [AnswerMO] = []

        for index in correctAnswerIndexes {
            let answer = AnswerMO(context: persistenceController.mainContext)
            answer.word = randomisedWords[index]
            answer.isCorrect = true
            answers.append(answer)
        }

        for index in skippedQuestionIndexes {
            let answer = AnswerMO(context: persistenceController.mainContext)
            answer.word = randomisedWords[index]
            answer.isCorrect = false
            answers.append(answer)
        }

        let test = TestMO(context: persistenceController.mainContext)
        test.addToAnswers(NSSet(array: answers))
        test.timeStamp = Date()
    }
}
