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

class DictionaryViewModel: NSObject, ObservableObject, Identifiable {

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
                self.displayFilteredWords(filter: filter)
            })
            .store(in: &disposables)
    }
}

extension DictionaryViewModel {

    func fetchWords() {

        do {
            try fetchedResultsController.performFetch()

            displayFilteredWords(filter: searchText)
        } catch {
            state = .failed(error)
        }
    }

    func addTapped() {
        isShowingSheet = true
    }

    fileprivate func displayFilteredWords(filter: String) {

        guard let words = fetchedResultsController.fetchedObjects else {
            return
        }

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
        displayFilteredWords(filter: searchText)
    }
}
