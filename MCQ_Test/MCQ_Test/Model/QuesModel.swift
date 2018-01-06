//
//  QuesModel.swift
//  MCQ_Test
//
//  Created by Ramprasad A on 05/01/18.
//  Copyright © 2018 Ramprasad A. All rights reserved.
//

import Foundation

struct Question {
    var question: String
    var quesNum: Int
    var options: [String]
    var answer: String
    var left: Bool
    var answered: Bool
    
    init(withQuestion question: String,
         qNum num: Int,
         mcqOptions options: [String],
         withAnswer answer: String,
         isLeft left: Bool,
         hasAnswered answered: Bool) {
        self.question = question
        self.quesNum = num
        self.options = options
        self.answer = answer
        self.left = left
        self.answered = answered
    }
}
