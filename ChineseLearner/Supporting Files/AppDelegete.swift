//
//  AppDelegete.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 29/01/2022
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

    var persistenceController: PersistenceController?

    func applicationWillTerminate(_ application: UIApplication) {
        persistenceController?.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        persistenceController?.saveContext()
    }
}
