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
        case summary
    }

    @Published private(set) var state: State = .ready
    @Published var chineseAnswer: String = ""
    @Published var pinyinAnswer: String = ""
    @Published private var currentWordIndex: Int = 0

    private var viewContext: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<WordMO>
    private var randomisedWords: [WordMO] = []
    private var disposables = Set<AnyCancellable>()

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: WordMO.all,
            managedObjectContext: viewContext,
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
                }
                
                self.displayWord(index: value)
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

            randomisedWords = words.shuffled()

            state = .practiceReady(randomisedWords[currentWordIndex].english)
        } catch {
            // error
        }
    }

    func checkAnswer() {
        let word = randomisedWords[currentWordIndex]

        if chineseAnswer == word.chinese && pinyinAnswer == word.pinyin {
            state = .practiceCorrect(word.english)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.currentWordIndex += 1
            }
        } else {
            state = .practiceIncorrect(word.english)
        }
    }

    func skip() {
        currentWordIndex += 1
    }

    func endPractice() {
        state = .summary
    }

    func closeSummary() {
        state = .ready
    }

    private func displayWord(index: Int) {
        if index < randomisedWords.count {
            chineseAnswer = ""
            pinyinAnswer = ""
            state = .practiceReady(randomisedWords[index].english)
        } else {
            currentWordIndex = 0

            guard let words = fetchedResultsController.fetchedObjects else {
                return
            }

            randomisedWords = words.shuffled()

            endPractice()
        }
    }
}
