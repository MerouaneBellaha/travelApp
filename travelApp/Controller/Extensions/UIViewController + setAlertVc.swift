//
//  UIViewController + setAlertVc.swift
//  travelApp
//
//  Created by Merouane Bellaha on 15/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

extension UIViewController {
    func setAlertVc(with message: String) {
        let alertVC = UIAlertController(title: "Oups!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true)
    }
    /// set an alert with a textField and an Add button, callback contains the the textField text to save
    func setAlertTextField(callBack: @escaping ((String) -> ())) {
        let alert = UIAlertController(title: nil, message: "Add new task", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Task"
        }
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            guard let task = alert.textFields?.first?.text,
                !task.isEmpty else { return }
            callBack(task)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }

    func setActivityAlert(withTitle title: String?, message: String?, activityIndicatorColor: UIColor = UIColor.black, presentedActivityController: @escaping ((_ success: UIAlertController) -> Void)) {

        let alertController = UIAlertController(title: title, message: (message ?? "") + ("\n\n\n"), preferredStyle: .alert)

        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = activityIndicatorColor
        activityIndicator.startAnimating()
        alertController.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -8.0).isActive = true
        alertController.view.layoutIfNeeded()
        present(alertController, animated: true) { presentedActivityController(alertController) }
    }
}

