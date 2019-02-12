//
//  Game.swift
//  OpenQuiz
//
//  Created by vrakosky on 13/11/2017.
//  Copyright © 2017 vrakosky. All rights reserved.
//

import Foundation

class Game {

     var score = 0
     var correct: Bool?
    
     var questions = [Question]()
     var currentIndex = 0
    
    var state: State = .ongoing
    
    enum State {
        case ongoing, over
    }
    
    var currentQuestion: Question {
        return questions[currentIndex]
    }
    
    
    
    func refresh() {
        score = 0
        currentIndex = 0
        state = .over
        
        //TEST : Création d'une question pour test
        var q = Question()
        q.isCorrect = false
        q.title = "pipo"
        self.questions.append(q)
        
        
        QuestionManager.shared.get { (questions) in
            self.questions = questions
            self.state = .ongoing
            
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
        }
    }
    
    func answerCurrentQuestion(with answer: Bool) {
        if (currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer) {
            score += 1
            correct = true
        }else if !((currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer)){
            correct = false
        } else {
            correct = nil
        }
        goToNextQuestion()
    }
    
    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }
    
    private func finishGame() {
        state = .over
    }
}
