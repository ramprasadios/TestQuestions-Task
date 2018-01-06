//
//  TestViewController.swift
//  MCQ_Test
//
//  Created by Ramprasad A on 05/01/18.
//  Copyright © 2018 Ramprasad A. All rights reserved.
//

import UIKit
import DLRadioButton

protocol UIUpdaterDelegate: class {
    func submitTestTapped(withTestInfo info: [String: AnyObject])
}

enum Selection: Int {
    case a = 0,b = 1,c = 2,d = 3
}

class TestViewController: UIViewController {
    
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var questNumLabel: UILabel!
    @IBOutlet weak var questLabel: UILabel!
    
    @IBOutlet var multileSelections: [DLRadioButton]!
    
    var questions: [Question] = []
    var countdownTimer: Timer!
    var totalTime = 600
    var currentQuestion: Int = 0
    weak var delegate: UIUpdaterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.startTimer()
        self.createQuestionObjects()
        self.updateQuestion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func stopTestTapped(_ sender: Any) {
        self.submitTest()
    }
    
    @IBAction func optionSelection(_ sender: DLRadioButton) {
        print("Selected Button is: \((sender as AnyObject).tag)")
        guard let selectedChoice = Selection(rawValue: sender.tag) else { return }
        self.handleAnsweredQuestion(withSelected: selectedChoice)
        self.questions[currentQuestion].selectedAnswer = sender.currentTitle
    }
    
    @IBAction func previousQuestionTapped(_ sender: Any) {
        if self.currentQuestion > 0 {
            self.currentQuestion = currentQuestion - 1
        }
        self.updateQuestion()
    }
    
    @IBAction func nextQuestionTapped(_ sender: Any) {
        if self.currentQuestion < self.questions.count - 1 {
            self.currentQuestion = currentQuestion + 1
        }
        self.updateQuestion()
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        if self.currentQuestion < self.questions.count - 1 {
            self.currentQuestion = currentQuestion + 1
        }
        self.updateQuestion()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        self.submitTest()
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
                    let question = Question(withQuestion: quest, qNum: num, mcqOptions: options, withAnswer: answer, isLeft: false, hasAnswered: false)
                    self.questions.append(question)
                }
            }
            print("Number of Questions are: \(self.questions.count)")
        }
    }
    
    func updateQuestion() {
        let question = self.questions[currentQuestion]
        for (index, option) in question.options.enumerated() {
            self.multileSelections[index].setTitle(option, for: .normal)
            if let indexVal = self.questions[currentQuestion].optionSelected?.rawValue {
                self.multileSelections[indexVal].isSelected = true
            } else {
                self.multileSelections[index].isSelected = false
            }
        }
        self.questNumLabel.text = "Q" + question.quesNum.description + "."
        self.questLabel.text = question.question
    }
    
    ///Handles Choice selection
    func handleAnsweredQuestion(withSelected option: Selection) {
        self.questions[currentQuestion].answered = true
        self.questions[currentQuestion].optionSelected = option
    }
    
    func submitTest() {
        var testCompletedInfo = [String: AnyObject]()
        let answeredCount = self.questions.filter({$0.answered}).count
        let correctAnswers = self.questions.filter({
            $0.answer == $0.selectedAnswer
        })
        print("Correct Answers: \(correctAnswers.count)")
        print("Answered count: \(answeredCount)")
        print("Left Count: \(self.questions.count - answeredCount)")
        testCompletedInfo["correct"] = correctAnswers.count as AnyObject
        testCompletedInfo["answered"] = answeredCount as AnyObject
        testCompletedInfo["left"] = self.questions.count - answeredCount as AnyObject
        self.delegate?.submitTestTapped(withTestInfo: testCompletedInfo)
        self.showCustomAlert(withMessage: "Are you sure you want to End the test...?")
    }
    
    func showCustomAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "Alert...!", message: message, preferredStyle: .alert)
        let stopAction = UIAlertAction(title: "Yes", style: .destructive) { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(stopAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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
