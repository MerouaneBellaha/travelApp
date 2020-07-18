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
        (searchBar.text?.isEmpty == true ? coreDataManager?.loadItems(entity: Task.self) : coreDataManager?.loadItems(entity: Task.self, containing: searchText)) ?? []
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
