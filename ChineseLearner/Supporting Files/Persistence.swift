//
//  Persistence.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 26/01/2022
//

import CoreData

open class PersistenceController {

    public static let modelName = "ChineseLearner"

    public static let model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    public init() {

    }

    public lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()

    public lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: PersistenceController.modelName,
            managedObjectModel: PersistenceController.model
        )

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    public func newDerivededContext() -> NSManagedObjectContext {
        let context = storeContainer.newBackgroundContext()
        return context
    }

    public func saveContext() {
        saveContext(mainContext)
    }

    public func saveContext(_ context: NSManagedObjectContext) {

        if !context.hasChanges {
            return
        }

        if context != mainContext {
            saveDerivedContext(context)
            return
        }

        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }

    public func saveContextAsync(_ context: NSManagedObjectContext) {

        if !context.hasChanges {
            return
        }

        if context != mainContext {
            saveDerivedContext(context)
            return
        }

        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    public func saveDerivedContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        self.saveContext(self.mainContext)
    }
}
