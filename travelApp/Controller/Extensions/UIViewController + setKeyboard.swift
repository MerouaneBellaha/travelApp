//
//  UIViewController + setKeyboard.swift
//  travelApp
//
//  Created by Merouane Bellaha on 19/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

extension UIViewController {
    private func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    private func setUpToolbar(textFields: [UITextField]) {
        let bar = UIToolbar()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        textFields.forEach { $0.inputAccessoryView = bar }
    }

    func setUpKeyboard(textFields: [UITextField]) {
        hideKeyboardWhenTappedAround()
        setUpToolbar(textFields: textFields)
    }
}
