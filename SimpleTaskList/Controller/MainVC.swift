//
//  MainVC.swift
//  SimpleTaskList
//
//  Created by Victor on 10/27/18.
//  Copyright © 2018 TomTheToad. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTaskButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        newTaskButton.layer.cornerRadius = 5
    }

}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "New Task"
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
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        cell.textLabel?.textColor = (cell.textLabel?.textColor == .lightGray) ? .black : .lightGray
    }
}
