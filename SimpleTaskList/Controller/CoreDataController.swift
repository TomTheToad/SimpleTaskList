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
    
    // Default group id
    let defaultGroupId: UUID = {
        // TODO set this
        return UUID()
    }()
    
    override init() {
        super.init()
    }
    
    // Create
    // 1) Establish new Task entity,
    // 2) Associate with first group in which the name matches or set default
    // 3) Save context
    // 4) Return Task
    @discardableResult
    func newTask(name: String, info: String, groupId: UUID?) -> Task {
        let newTask =  Task(context: context)
        newTask.id = UUID()
        newTask.name = name
        newTask.info = info
        newTask.dateCreated = Date()
        
        guard let id = groupId else {
            // TODO: use / create / get default group id
            newTask.id = defaultGroupId
            saveContext()
            return newTask
        }
        
        newTask.id = id
        return newTask
    }
    
    func newTaskGroup(name: String, info: String?) -> TaskGroup {
        let newTaskGroup = TaskGroup(context: context)
        newTaskGroup.id = UUID()
        newTaskGroup.name = name
        
        guard let info = info else {
            saveContext()
            return newTaskGroup
        }
        
        newTaskGroup.info = info
        return newTaskGroup
    }
    
    // Read
    func getAllTaskGroups() -> NSFetchedResultsController<TaskGroup> {
        // TODO: set default request in core data?
        let request = NSFetchRequest<TaskGroup>(entityName: "TaskGroup")
        let sortName = NSSortDescriptor(key: #keyPath(TaskGroup.name), ascending: true)
        let sortId = NSSortDescriptor(key: #keyPath(TaskGroup.id), ascending: true)
        
        request.sortDescriptors = [sortName, sortId]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(TaskGroup.name), cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to perform petch")
        }
        return fetchedResultsController
    }
    
    func getAllTasks() -> NSFetchedResultsController<Task> {
        let request = NSFetchRequest<Task>(entityName: "Task")
        let sort = NSSortDescriptor(key: #keyPath(Task.belongsToGroup.name), ascending: true)
        request.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(TaskGroup.name), cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to perform fetch")
        }
        return fetchedResultsController
    }
    
    // Update
    
    // Delete
    
    // helpers
    func getDefaultGroupId() {
        // TODO: check for default group
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("context saved")
            } catch {
                print("Problem saving context")
            }
        }
    }
}
