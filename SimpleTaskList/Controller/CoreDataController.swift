//
//  CoreDataController.swift
//  SimpleTaskList
//
//  Created by Victor on 10/30/18.
//  Copyright © 2018 TomTheToad. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject {
    
    // Fields
    let context: NSManagedObjectContext = {
        guard let appDelegagte = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not instantiate AppDelegate")
        }
        return appDelegagte.persistentContainer.viewContext
    }()
    
    // Test func
    func getTaskEntity() -> Task {
        return Task(context: context)
    }
}
