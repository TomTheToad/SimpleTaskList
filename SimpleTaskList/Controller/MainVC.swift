//
//  MainVC.swift
//  SimpleTaskList
//
//  Created by Victor on 10/27/18.
//  Copyright © 2018 TomTheToad. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {
    // Fields
    let coreData = CoreDataController()
    var fetchedRC: NSFetchedResultsController<Task>! {
        didSet {
            print("fetchedRC was set")
        }
    }
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test functions
        deleteData()
        addTestItems()
        
        // Initialize fields
        fetchedRC = coreData.getAllTasks()

        // Configure
        tableView.delegate = self
        tableView.dataSource = self
        fetchedRC.delegate = self
    }
    
    // Helper Functions
    // TODO: Delete if not used
    func updateFetchedResults() {
        do {
            try fetchedRC.performFetch()
        } catch {
            print("problem with task fetch")
        }
        tableView.reloadData()
    }

}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = fetchedRC.sections?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedRC.sections?[section] else {
            return 0
        }
        
        let count = section.numberOfObjects
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") else {
            return UITableViewCell()
        }
        
        let task = fetchedRC.object(at: indexPath)
        
        cell.textLabel?.text = task.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let rowHeight = (tableView.visibleCells.first?.frame.height) ?? tableView.sectionHeaderHeight
        return rowHeight * 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.sectionHeaderHeight)
        let view = UIView(frame: frame)
        let color = UIColor(red: 82/255, green: 174/255, blue: 1, alpha: 1)
        view.backgroundColor = color
        
        let label = UILabel()
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        guard let taskGroup = fetchedRC.sections?[section] else {
            label.text = "Title Missing"
            return view
        }
        label.text = taskGroup.name
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskTableCell else {
            return
        }
        
//        cell.textLabel?.textColor = (cell.textLabel?.textColor == .lightGray) ? .black : .lightGray
    }
}

extension MainVC: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else {
            return
        }
        
        switch type {
        case .insert:
            tableView.insertRows(at: [cellIndex], with: .automatic)
            print("new object detected")
        case .delete:
            tableView.deleteRows(at: [cellIndex], with: .automatic)
        default:
            break
        }
    }
}

extension MainVC {
    // Test Functions
    func deleteData() {
        coreData.deleteAllTasks()
    }
    
    func addTestItems() {
        // Test groups which hold tasks (aka group of tasks)
        let testGroup1 = coreData.newTaskGroup(name: "testGroup1", info: nil)
        let testGroup2 = coreData.newTaskGroup(name: "testGroup2", info: nil)
        let testGroup3 = coreData.newTaskGroup(name: "testGroup3", info: nil)
        
        // Tasks group 1
        let task1 = coreData.newTask(name: "task1", info: "do something", groupId: testGroup1.id)
        let task2 = coreData.newTask(name: "task2", info: "do another thing", groupId: testGroup1.id)
        
        // Tasks group 2
        let task3 = coreData.newTask(name: "task3", info: "do a bigger thing", groupId: testGroup2.id)
        let task4 = coreData.newTask(name: "task4", info: "do a small thing", groupId: testGroup2.id)
        let task5 = coreData.newTask(name: "task5", info: "do a smaller thing", groupId: testGroup2.id)
        
        // Task group 3
        let task6 = coreData.newTask(name: "task6", info: "do nothing", groupId: testGroup3.id)
        
        // Add tasks to group 1
        testGroup1.addToHasTasks(task1)
        testGroup1.addToHasTasks(task2)
        
        // Add tasks to group 2
        testGroup2.addToHasTasks(task3)
        testGroup2.addToHasTasks(task4)
        testGroup2.addToHasTasks(task5)
        
        // Add tasks to group 3
        testGroup3.addToHasTasks(task6)
        
        coreData.saveContext()
    }
    
    func showAllTask() {
        guard let tasks = fetchedRC.fetchedObjects else {
            print("Show all tasks failed")
            return
        }
        
        for task in tasks {
            print("task name \(String(describing: task.name))")
        }
    }
}
