//
//  DictionaryViewModel.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 27/01/2022
//

import Foundation
import CoreData
import Combine
import SwiftUI

class DictionaryViewModel: NSObject, ObservableObject {

    enum State: Equatable {
        static func == (lhs: DictionaryViewModel.State, rhs: DictionaryViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.loading, .loading):
                return true
            case (.empty, .empty):
                return true
            case (.ready(let lhsResults), .ready(let rhsResults)):
                return lhsResults == rhsResults
            case (.failed(let lhsError), .failed(let rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            default:
                return false
            }
        }

        case idle
        case loading
        case empty
        case ready([LetterSectionViewModel])
        case failed(DictionaryError)
    }

    enum DictionaryError: Error {
        case noResults(String)
        case failedFetch(String)
    }

    @Published private(set) var state = State.idle
    @Published var isShowingSheet = false
    @Published var searchText: String = ""
    @Published var resultsCount: String = ""

    private(set) var persistenceController: Persisting
    private let fetchedResultsController: NSFetchedResultsController<WordMO>
    private var disposables = Set<AnyCancellable>()

    init(persistenceController: Persisting) {
        self.persistenceController = persistenceController

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: WordMO.all,
            managedObjectContext: persistenceController.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self

        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .sink(receiveValue: { filter in
                self.displayFilteredWords()
            })
            .store(in: &disposables)
    }
}

extension DictionaryViewModel {

    func fetchWords() {

        do {
            try fetchedResultsController.performFetch()

            displayFilteredWords()
        } catch {
            state = .failed(.noResults(error.localizedDescription))
        }
    }

    func addTapped() {
        isShowingSheet = true
    }

    func delete(from section: LetterSectionViewModel, at offsets: IndexSet) {

        offsets.forEach { index in

            let word = section.words[index]

            do {
                guard let wordToDelete = try persistenceController.mainContext.existingObject(with: word.id) as? WordMO else {
                    return
                }

                persistenceController.mainContext.delete(wordToDelete)
            } catch {

            }
        }
    }

    @objc
    open func displayFilteredWords() {

        guard let words = fetchedResultsController.fetchedObjects else {
            state = .failed(DictionaryError.noResults("display called before fecth"))
            return
        }

        if words.isEmpty {
            state = .empty
        } else {
            let filterdWords = searchText.isEmpty ? words : filteredWords(words: words, filter: searchText.lowercased())

            resultsCount = filterdWords.count == 1 ? "1 word" : "\(filterdWords.count) words"

            let letterSections = createLetterSections(from: filterdWords)
            state = .ready(letterSections)
        }
    }

    func createLetterSections(from words: [WordMO]) -> [LetterSectionViewModel] {
        var letterSections: [LetterSectionViewModel] = []
        for word in words {
            if letterSections.isEmpty || !letterSections.contains(where: { word.english.starts(with: $0.letter) }) {

                guard let letter = word.english.first else {
                    continue
                }

                letterSections.append(
                    LetterSectionViewModel(
                        letter: String(letter),
                        words: words.filter({ $0.english.starts(with: String(letter)) }).map(WordRowViewModel.init)
                    )
                )
            }
        }
        return letterSections
    }

    func filteredWords(words: [WordMO], filter: String) -> [WordMO] {
        words.filter { $0.english.lowercased().contains(filter) }
    }
}

extension DictionaryViewModel: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        displayFilteredWords()
    }
}
