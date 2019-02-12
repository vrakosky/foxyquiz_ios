//
//  ViewController.swift
//  OpenQuiz
//
//  Created by vrakosky on 12/11/2017.
//  Copyright © 2017 vrakosky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!    
    @IBOutlet weak var foxView: FoxView!
    @IBOutlet weak var noWifiLogo: UIImageView!
    
    var game = Game()
    var rechability:Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Test de connection Internet
        self.rechability = Reachability.init()
        if ((self.rechability!.connection) != .none)
        {
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            NotificationCenter.default.addObserver(self, selector: #selector(questionLoaded), name: name, object: nil)
            
            noWifiLogo.isHidden = true
            startNewGame()
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
            questionView.addGestureRecognizer(panGestureRecognizer)

        }else{
            questionView.title = "Internet not Available \n Please turn on WIFI"
            newGameButton.isEnabled = false
            newGameButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            scoreButton.isEnabled = false
            scoreButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            noWifiLogo.isHidden = false
            
        }
        
        
        
    }
    
    @objc func questionLoaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        
        questionView.title = game.currentQuestion.title
    }
    
    @IBAction func didTapNewGameButton(_ sender: Any) {
        //Séparer l'action et la logique
        startNewGame()
    }
    
    private func startNewGame() {
        activityIndicator.isHidden = false //Chargement pas caché
        newGameButton.isHidden = true      //BoutonNewGame caché
        
        questionView.title = "Loading..."
        questionView.style = .standard
        foxView.style = .standard
        scoreLabel.text = "0 / 10"
        
        game.refresh()
        
        print(game.currentIndex)
        print(game.currentQuestion.title)
        //questionView.title = game.currentQuestion.title
        
    }
    
    func dragQuestionView(_ sender: UIPanGestureRecognizer){
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed:
                transformQuestionViewWith(gesture: sender)
            case .cancelled, .ended:
                answerQuestion()
            default:
                break
            }
        }
    }
    
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: questionView)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        let screenWith = UIScreen.main.bounds.width
        let translationPercent = translation.x/(screenWith/2)
        let rotationAngle = (CGFloat.pi / 6) * translationPercent
        
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let transform = translationTransform.concatenating(rotationTransform)
        questionView.transform = transform
        
        if translation.x > 0 {
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
    }
    
    private func answerQuestion(){
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standard:
            break
        }
        
        scoreLabel.text = "\(game.score) / 10"
        
        if (game.correct == true){
            foxView.style = .correct
        } else if (game.correct == false){
            foxView.style = .incorrect
        } else {
            foxView.style = .standard

        }
        
     
        let screenWith = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform
        if questionView.style == .correct {
            translationTransform = CGAffineTransform(translationX: screenWith, y: 0)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWith, y: 0)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform = translationTransform
        }) { (success) in
            if success {
                self.showQuestionView()
            }
        }
    }
    
    private func showQuestionView(){
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        questionView.style = .standard
        questionView.title = game.currentQuestion.title
        
        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "Game Over"
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.questionView.transform = .identity
        }, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let scoreController = segue.destination as! ScoreController
        scoreController.myScore = scoreLabel.text!
    }
    
    @IBAction func sendScore(_ sender: Any) {
        if scoreLabel.text != ""
        {
            performSegue(withIdentifier: "seguescore", sender: self)
        }
    }
    
}


