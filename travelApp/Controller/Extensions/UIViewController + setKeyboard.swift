//
//  UIViewController + setKeyboard.swift
//  travelApp
//
//  Created by Merouane Bellaha on 19/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    func setUpToolbar(for textFields: [UITextField]) {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        textFields.forEach { $0.inputAccessoryView = bar }
    }

    //    func setUpKeyboard(textFields: [UITextField]? = []) {
    //        hideKeyboardWhenTappedAround()
    //        guard let textFields = textFields else { return }
    //        setUpToolbar(for: textFields)
    //    }
}
