//
//  ToDoVC.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class ToDoVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noTaskLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!

    var coreDataManager: CoreDataManager?
    var searchText: String = "" { didSet { tableView.reloadData() }}
    var loadedItems: [Task] {
        (searchBar.text?.isEmpty == true ? coreDataManager?.loadItems(entity: Task.self) : coreDataManager?.loadItems(entity: Task.self, text: searchText)) ?? []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }


    @IBAction func addTaskTapped(_ sender: UIBarButtonItem) {
        setAlertTextField { [unowned self] text in
            self.coreDataManager?.createItem(entity: Task.self) { $0.taskName = text }
            self.tableView.reloadData()
        }
    }
    @IBAction func resetTapped(_ sender: UIBarButtonItem) {
        coreDataManager?.deleteItems(entity: Task.self)
        tableView.reloadData()
    }
}

extension ToDoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noTaskLabel.text = coreDataManager?.loadItems(entity: Task.self).isEmpty ?? true ? "no task" : .none
        return loadedItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        cell.textLabel?.text = loadedItems[indexPath.row].taskName
        return cell
    }
}

extension ToDoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coreDataManager?.deleteItem(item: (coreDataManager?.loadItems(entity: Task.self)[indexPath.row])!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ToDoVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
}
