//
//  Alert.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 17/08/23.
//

import UIKit

struct Alert {
    var title: String? = nil
    var message: String? = nil
    var actions: [UIAlertAction]
    
    func present(at controller: UIViewController) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        for action in actions {
            alertController.addAction(action)
        }
        controller.present(alertController, animated: true)
    }
    
    static func basicAlert(title: String?, message: String?) -> Alert {
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        return Alert(title: title, message: message, actions: [action])
    }
}
