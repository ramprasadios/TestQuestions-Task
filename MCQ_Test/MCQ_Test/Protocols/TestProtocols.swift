//
//  TestProtocols.swift
//  MCQ_Test
//
//  Created by Ramprasad A on 05/01/18.
//  Copyright © 2018 Ramprasad A. All rights reserved.
//

import Foundation
import UIKit

protocol AlertDisplayale {
    
    func showAlert(withTitle title: String, andMessage message: String)
}

extension AlertDisplayale where Self: UIViewController {
    func showAlert(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive) { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
