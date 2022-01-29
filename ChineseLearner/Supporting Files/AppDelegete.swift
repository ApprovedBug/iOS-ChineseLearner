//
//  AppDelegete.swift
//  ChineseLearner
//
//  Created by ApprovedBug on 29/01/2022
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

    func applicationWillTerminate(_ application: UIApplication) {
        PersistenceController.shared.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        PersistenceController.shared.save()
    }
}
