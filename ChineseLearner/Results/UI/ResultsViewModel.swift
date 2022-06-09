//
//  ResultsViewModel.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 30/01/2022
//

import Foundation
import CoreData

class ResultsViewModel: NSObject, ObservableObject {

    enum State {
        case loading
        case ready([TestRowViewModel])
        case empty
    }

    @Published var state: State = .loading

    private(set) var persistenceController: Persisting
    private var fetchedResultsController: NSFetchedResultsController<TestMO>

    init(persistenceController: Persisting) {
        self.persistenceController = persistenceController
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: TestMO.all,
            managedObjectContext: persistenceController.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
    }
}

extension ResultsViewModel {

    func fetchResults() {

        do {
            try fetchedResultsController.performFetch()

            displayResults()
        } catch {

        }
    }

    private func displayResults() {
        guard let results = fetchedResultsController.fetchedObjects else {
            return
        }

        if results.count > 0 {
            state = .ready(results.map(TestRowViewModel.init))
        } else {
            state = .empty
        }
    }

    func takeTest() {
        
    }
}

extension ResultsViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        displayResults()
    }
}
