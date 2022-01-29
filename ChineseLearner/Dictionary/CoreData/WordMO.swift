//
//  WordMO.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 27/01/2022
//

import CoreData

@objc(WordMO)
final class WordMO: NSManagedObject {
    @NSManaged var chinese: String
    @NSManaged var pinyin: String
    @NSManaged var english: String
}

extension WordMO {
    static var all: NSFetchRequest<WordMO> {
        let request = WordMO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "english", ascending: true)]
        return request as! NSFetchRequest<WordMO>
    }
}
