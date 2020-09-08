//
//  ToDoVC.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

final class ToDoVC: UIViewController {

    // MARK: - IBOutlet properties

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noTaskLabel: UILabel!


    // MARK: - Properties

    var coreDataManager: CoreDataManager?
    private var taskList: [Task] { setTaskList() }

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    // MARK: - IBAction methods

    @IBAction private func addTaskTapped(_ sender: UIBarButtonItem) {
        setAlertTextField { [unowned self] text in
            self.coreDataManager?.createItem(entity: Task.self) { $0.taskName = text }
            self.tableView.reloadData()
        }
    }

    @IBAction private func resetTapped(_ sender: UIBarButtonItem) {
        // Add an Alert controller to confirm clear all tasks
        coreDataManager?.deleteItems(entity: Task.self)
        tableView.reloadData()
    }

    private func setTaskList() -> [Task] {
        if searchBar.text?.isEmpty == true {
            return coreDataManager?.loadItems(entity: Task.self, sortBy: K.taskName) ?? []
        } else {
            return coreDataManager?.loadItems(entity: Task.self, predicate: .text(searchBar.text!), sortBy: K.taskName) ?? []
        }
    }
}

// MARK: - UITableViewDataSource

extension ToDoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noTaskLabel.text = taskList.isEmpty ? K.noTask : .none
        return taskList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.taskCell, for: indexPath)
        cell.textLabel?.text = taskList[indexPath.row].taskName
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ToDoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let itemToDelete = coreDataManager?.loadItems(entity: Task.self)[indexPath.row] else { return }
            coreDataManager?.deleteItem(item: itemToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UISearchBarDelegate

extension ToDoVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
