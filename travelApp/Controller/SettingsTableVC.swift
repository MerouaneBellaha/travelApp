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

class SettingsTableVC: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    weak var delegate: SettingProtocol?
    var senderIndexPathRow: Int?
    var content: [String] = []
    var displayedContent: [String] { setDisplayedContent() }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        hideKeyboardWhenTappedAround()
    }

//    private func setContent() -> [String] {
//        if searchBar.text?.isEmpty == true {
//            return content
//        } else {
//            guard let textToSearch = searchBar.text else { return [] }
//            return content.filter { $0.contains(textToSearch) }
//        }
//    }

    private func setDisplayedContent() -> [String] {
        if searchBar.text?.isEmpty == true {
            return content
        } else {
            guard let textToSearch = searchBar.text else { return [] }
            return content.filter { $0.contains(textToSearch) }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedContent.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
        cell.textLabel?.text = displayedContent[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenContent = content[indexPath.row]
        if senderIndexPathRow == 0 {
            delegate?.didUpdateCurrency(with: chosenContent)
        } else {
            delegate?.didUpdateLanguage(with: chosenContent)
        }
        self.dismiss(animated: true)
    }
}

extension SettingsTableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
