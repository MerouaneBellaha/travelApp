//
//  LanguagesTableVC.swift
//  travelApp
//
//  Created by Merouane Bellaha on 25/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

protocol LanguagesProtocol: class {
    func didUpdateLanguage(for tag: Int, with language: String)
}

class LanguagesTableVC: UITableViewController {

    // MARK: - IBOutlet properties

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noLanguageLabel: UILabel!

    // MARK: - Properties

    weak var delegate: LanguagesProtocol?
    var senderTag: Int?
    var languages: [Language] = []
    var diplayedLanguages: [Language] { setDisplayedLanguages() }
    var chosenLanguage: String = K.emptyString

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: K.background))
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
        noLanguageLabel.text = diplayedLanguages.isEmpty ? K.noMatch : .none
        return diplayedLanguages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.languageCell, for: indexPath)
        cell.textLabel?.text = diplayedLanguages[indexPath.row].name
        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.animateCellBackground()
        chosenLanguage = diplayedLanguages[indexPath.row].name
        guard let senderTag = senderTag else { return }
        delegate?.didUpdateLanguage(for: senderTag, with: chosenLanguage)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension LanguagesTableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
