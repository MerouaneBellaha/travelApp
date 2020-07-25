//
//  LanguagesTable.swift
//  travelApp
//
//  Created by Merouane Bellaha on 25/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class LanguagesTable: UITableViewController {

    var senderTag: Int!
    var languages: [Language] = [] /* { didSet { tableView.reloadData() }} */
    var chosenLanguage: String = ""
    var senderVC: UIViewController!

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath)
        cell.textLabel?.text = languages[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenLanguage = languages[indexPath.row].name
        (senderVC as? TranslatorVC)?.languageLabels[senderTag].text = chosenLanguage
        senderVC = nil
        navigationController?.popViewController(animated: true)
    }


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let translatorVC = segue.destination as? TranslatorVC
//        translatorVC?.languageLabels[senderTag].text = chosenLanguage
//    }
}
