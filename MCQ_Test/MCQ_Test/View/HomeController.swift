//
//  ViewController.swift
//  MCQ_Test
//
//  Created by Ramprasad A on 05/01/18.
//  Copyright © 2018 Ramprasad A. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //Interface Builder - Referencing Outlets:
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var incorrectAnswerLabel: UILabel!
    @IBOutlet weak var leftAnswersLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var scoredLabel: UILabel!
    @IBOutlet weak var resultStackView: UIStackView!
    @IBOutlet weak var testAnalysisStackView: UIStackView!
    
    //Outlet Collection:
    @IBOutlet var instructions: [UILabel]!

    //MARK:- Life Cycle
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

//MARK:- UIUpdaterDelegate Methods
extension HomeViewController: UIUpdaterDelegate {
    func submitTestTapped(withTestInfo info: [String : AnyObject]) {
        guard let correctAnswers = info["correct"] as? Int,
            let leftCount = info["left"] as? Int  else { return }
        self.correctAnswerLabel.text = correctAnswers.description + " Correct"
        self.incorrectAnswerLabel.text = (10 - correctAnswers - leftCount).description + " In-Correct"
        self.leftAnswersLabel.text = leftCount.description + " Left"
        self.scoredLabel.text = correctAnswers.description
        self.setUIVisibility(isVisible: false)
        
        for instruction in self.instructions {
            instruction.isHidden = true
        }
    }
}

