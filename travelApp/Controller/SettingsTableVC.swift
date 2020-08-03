//
//  SettingsTableVC.swift
//  travelApp
//
//  Created by Merouane Bellaha on 28/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

protocol SettingProtocol: class {
    func didUpdateLanguage(with language: String)
    func didUpdateCurrency(with currency: String)
}

final class SettingsTableVC: UITableViewController {

    // MARK: - IBOutlet properties

    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Properties

    weak var delegate: SettingProtocol?
    var senderIndexPathRow: Int?
    var content: [String] = []
    var displayedContent: [String] { setDisplayedContent() }

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: K.background))
        hideKeyboardWhenTappedAround()
    }

    // MARK: - Methods

    private func setDisplayedContent() -> [String] {
        if searchBar.text?.isEmpty == true {
            return content
        } else {
            let searchedText = senderIndexPathRow == 0 ? searchBar.text?.uppercased() : searchBar.text?.capitalized
            guard let textToSearch = searchedText else { return [] }
            return content.filter { $0.contains(textToSearch) }
        }
    }

    // MARK: - tableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedContent.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.contentCell, for: indexPath)
        cell.textLabel?.text = displayedContent[indexPath.row]
        return cell
    }

    // MARK: - tableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.animateCellBackground()
        let chosenContent = displayedContent[indexPath.row]
        if senderIndexPathRow == 0 {
            delegate?.didUpdateCurrency(with: chosenContent)
        } else {
            delegate?.didUpdateLanguage(with: chosenContent)
        }
        self.dismiss(animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SettingsTableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
