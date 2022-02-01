//
//  TestMO.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 30/01/2022
//

import Foundation
import CoreData

extension TestMO {

    static var all: NSFetchRequest<TestMO> {
        let request = TestMO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        return request
    }
}
