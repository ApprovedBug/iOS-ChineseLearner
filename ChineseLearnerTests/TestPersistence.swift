//
//  TestPersistence.swift
//  ChineseLearnerTests
//
//  Created by ApprovedBug on 01/02/2022
//

import Foundation
import CoreData
import ChineseLearner

class TestPersistenceController: PersistenceController {

    override init() {
        super.init()

        let persistenceStoreDescription = NSPersistentStoreDescription()
        persistenceStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(
            name: PersistenceController.modelName,
            managedObjectModel: PersistenceController.model
        )

        container.persistentStoreDescriptions = [persistenceStoreDescription]

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        storeContainer = container
    }
}
