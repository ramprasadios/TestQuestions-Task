//
//  TestViewController.swift
//  MCQ_Test
//
//  Created by Ramprasad A on 05/01/18.
//  Copyright © 2018 Ramprasad A. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func stopTestTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Alert...!", message: "Would you like to Stop the test..?", preferredStyle: .alert)
        let stopAction = UIAlertAction(title: "Stop", style: .destructive) { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(stopAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
