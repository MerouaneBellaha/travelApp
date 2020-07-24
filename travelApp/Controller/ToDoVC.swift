//
//  ToDoVC.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class ToDoVC: UIViewController {

    // MARK: - IBOutlet properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noTaskLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Properties

    var coreDataManager: CoreDataManager?
    private var searchText: String = "" { didSet { tableView.reloadData() }}
    private var loadedItems: [Task] {
        (searchBar.text?.isEmpty == true ? (coreDataManager?.loadItems(entity: Task.self, sortBy: K.taskName)) : coreDataManager?.loadItems(entity: Task.self, predicate: .text(searchText), sortBy: K.taskName)) ?? []
    }

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        hideKeyboardWhenTappedAround()
    }

    // MARK: - IBAction methods

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

    // MARK: - UITableViewDataSource

extension ToDoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noTaskLabel.text = coreDataManager?.loadItems(entity: Task.self).isEmpty ?? true ? K.noTask : .none
        return loadedItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.taskCell, for: indexPath)
        cell.textLabel?.text = loadedItems[indexPath.row].taskName
        return cell
    }
}

    // MARK: - UITableViewDelegate

extension ToDoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coreDataManager?.deleteItem(item: (coreDataManager?.loadItems(entity: Task.self)[indexPath.row])!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

    // MARK: - UISearchBarDelegate

extension ToDoVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
}
