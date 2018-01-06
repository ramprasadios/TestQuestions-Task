//
//  TestViewController.swift
//  MCQ_Test
//
//  Created by Ramprasad A on 05/01/18.
//  Copyright © 2018 Ramprasad A. All rights reserved.
//

import UIKit
import DLRadioButton

enum Selection: Int {
    case a = 0,b = 1,c = 2,d = 3
}

class TestViewController: UIViewController {
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    var questions: [Question] = []
    var countdownTimer: Timer!
    var totalTime = 600

    override func viewDidLoad() {
        super.viewDidLoad()
        self.startTimer()
        self.createQuestionObjects()
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
    
    @IBAction func optionSelection(_ sender: DLRadioButton) {
        print("Selected Button is: \((sender as AnyObject).tag)")
        guard let selectedChoice = Selection(rawValue: sender.tag) else { return }
        self.handleAnsweredQuestion(withSelected: selectedChoice)
    }
}

extension TestViewController: AlertDisplayale { }

//MARK:- Helper Methods:
extension TestViewController {
    
    func getQuestions() -> [[String: AnyObject]]? {
        if let dict = Bundle().parsePlist(ofName: "QuestionsData") {
            guard let questionsArray = dict["questions"] as? [[String: AnyObject]] else { return [] }
                return questionsArray
        } else {
            return nil
        }
    }
    
    func createQuestionObjects() {
        if let questionsArray = self.getQuestions() {
            for question in questionsArray {
                if let quest = question["question"] as? String, let num = question["qNum"] as? Int, let answer = question["answer"] as? String, let options = question["options"] as? [String] {
                    let question = Question(withQuestion: quest, qNum: num, mcqOptions: options, withAnswer: answer)
                    self.questions.append(question)
                }
            }
            print("Number of Questions are: \(self.questions.count)")
        }
    }
    
    func handleAnsweredQuestion(withSelected option: Selection) {
        
    }
}

//Timer Helper Methods:
extension TestViewController {
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        countDownLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
            self.showAlert(withTitle: "Oops...!", andMessage: "Time up..! your score will be recorde, Thank you!")
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
