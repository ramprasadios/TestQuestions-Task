//
//  ViewController.swift
//  MCQ_Test
//
//  Created by Ramprasad A on 05/01/18.
//  Copyright © 2018 Ramprasad A. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var incorrectAnswerLabel: UILabel!
    @IBOutlet weak var leftAnswersLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var scoredLabel: UILabel!
    @IBOutlet weak var resultStackView: UIStackView!
    @IBOutlet weak var testAnalysisStackView: UIStackView!
    
    @IBOutlet var instructions: [UILabel]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUIVisibility(isVisible: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let testVc = segue.destination as? TestViewController {
            testVc.delegate = self
        }
    }
    
    func setUIVisibility(isVisible visible: Bool) {
        self.resultStackView.isHidden = visible
        self.testAnalysisStackView.isHidden = visible
        self.resultLabel.isHidden = visible
    }
}

extension ViewController: UIUpdaterDelegate {
    func submitTestTapped(withTestInfo info: [String : AnyObject]) {
        guard let correctAnswers = info["correct"] as? Int,
            let answeredCount = info["answered"] as? Int,
            let leftCount = info["left"] as? Int  else { return }
        self.correctAnswerLabel.text = correctAnswers.description + "Correct"
        self.incorrectAnswerLabel.text = (10 - correctAnswers).description + "In-Correct"
        self.leftAnswersLabel.text = leftCount.description + "Left"
        self.scoredLabel.text = answeredCount.description
        self.setUIVisibility(isVisible: false)
        
        for instruction in self.instructions {
            instruction.isHidden = true
        }
    }
}

