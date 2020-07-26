//
//  LanguagesTable.swift
//  travelApp
//
//  Created by Merouane Bellaha on 25/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class LanguagesTable: UITableViewController {

    // MARK: - IBOutlet properties

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noLanguageLabel: UILabel!

    // MARK: - Properties
    
    var senderTag: Int!
    var languages: [Language] = []
    var diplayedLanguages: [Language] { setDisplayedLanguages() }
    var chosenLanguage: String = ""
    var senderVC: UIViewController!

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        hideKeyboardWhenTappedAround()
    }

    // MARK: - Methods

    private func setDisplayedLanguages() -> [Language] {
        if searchBar.text?.isEmpty == true {
            return languages
        } else {
            guard let textToSearch = searchBar.text else { return [] }
            return languages.filter { $0.name.contains(textToSearch) }
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noLanguageLabel.text = diplayedLanguages.isEmpty ? "no language matching" : .none
        return diplayedLanguages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath)
        cell.textLabel?.text = diplayedLanguages[indexPath.row].name
        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenLanguage = diplayedLanguages[indexPath.row].name
        (senderVC as? TranslatorVC)?.languageLabels[senderTag].text = chosenLanguage
        senderVC = nil
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension LanguagesTable: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
