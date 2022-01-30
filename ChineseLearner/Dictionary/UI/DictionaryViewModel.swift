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

    enum State {
        case idle
        case loading
        case empty
        case loaded([LetterSectionViewModel])
        case failed(Error)
    }

    @Published private(set) var state = State.idle
    @Published var isShowingSheet = false
    @Published var searchText: String = ""
    @Published var wordCount: Int = 0

    private(set) var viewContext: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<WordMO>
    private var disposables = Set<AnyCancellable>()

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: WordMO.all,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self

        $searchText
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
            state = .failed(error)
        }
    }

    func addTapped() {
        isShowingSheet = true
    }

    func delete(from section: LetterSectionViewModel, at offsets: IndexSet) {

        offsets.forEach { index in

            let word = section.words[index]

            do {
                guard let wordToDelete = try viewContext.existingObject(with: word.id) as? WordMO else {
                    return
                }

                viewContext.delete(wordToDelete)
            } catch {

            }
        }
    }

    private func displayFilteredWords() {

        guard let words = fetchedResultsController.fetchedObjects else {
            return
        }

        wordCount = words.count

        let filterdWords = searchText.isEmpty ? words : words.filter { $0.english.starts(with: searchText) }

        if words.isEmpty {
            state = .empty
        } else {
            var letterSections: [LetterSectionViewModel] = []
            for word in filterdWords {

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
            state = .loaded(letterSections)
        }
    }
}

extension DictionaryViewModel: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        displayFilteredWords()
    }
}
