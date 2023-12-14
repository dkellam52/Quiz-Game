//
//  GameViewController.swift
//  QuizGame
//
//  Created by Dominique Kellam on 10/14/22.
//

import UIKit

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var gameModels = [Question]() //array of questions
    //temporary property
    var currentQuestion: Question? //question optional
    var score = 0

    @IBOutlet var label: UILabel!
    @IBOutlet var table: UITableView!
    @IBOutlet var rlabel: UILabel!
    
    override func viewDidLoad() {
        score = 0
        super.viewDidLoad()
        table.delegate = self       //set up table view
        table.dataSource = self
        setupQuestions()
        configureUI(question: gameModels.first!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func configureUI(question: Question){
        label.text = question.text
        currentQuestion = question
        table.reloadData()

        
    }
    
    private func checkAnswer(answer: Answer, question: Question)->Bool {
        //function to check user's answer to question; returns bool
        return question.answers.contains(where: { $0.text == answer.text}) && answer.correct
    }
    
    private func setupQuestions(){
        gameModels.append(Question(text: "What year was the very first model of the iPhone released?", answers: [
                    Answer(text: "2008", correct: false),
                    Answer(text: "2004", correct: false),
                    Answer(text: "2006", correct: false),
                    Answer(text: "2007", correct: true),
                ]))
                gameModels.append(Question(text: "What’s the shortcut for the “copy” function on most computers?", answers: [
                    Answer(text: "ctrl + c", correct: true),
                    Answer(text: "fn + c", correct: false),
                    Answer(text: "shift + c", correct: false),
                    Answer(text: "ctrl + shift + c", correct: false),
                ]))
                gameModels.append(Question(text: "What is Java?", answers: [
                    Answer(text: "A type of operating system", correct: false),
                    Answer(text: "A type of programming language", correct: true),
                    Answer(text: "A word processing application", correct: false),
                    Answer(text: "A microprocessor", correct: false),
                ]))
                gameModels.append(Question(text: "Who is often called the father of the computer?", answers: [
                    Answer(text: "Bill Gates", correct: false),
                    Answer(text: "Steve Jobs", correct: false),
                    Answer(text: "Elon Musk", correct: false),
                    Answer(text: "Charles Babbage", correct: true),
                ]))
                gameModels.append(Question(text: "What does “HTTP” stand for?", answers: [
                    Answer(text: "HyperText Task Program", correct: false),
                    Answer(text: "HyperText Testing Protocol", correct: false),
                    Answer(text: "HyperText Transpose Prevention", correct: false),
                    Answer(text: "HyperText Transfer Protocol", correct: true),
                ]))
                gameModels.append(Question(text: "What is the name of the man who launched eBay in 1995?", answers: [
                    Answer(text: "Thomas Anderson", correct: false),
                    Answer(text: "Mark Zuckerberg", correct: false),
                    Answer(text: "Pierre Omidyar", correct: true),
                    Answer(text: "Jack Dorsey", correct: false),
                ]))
                gameModels.append(Question(text: "Which email service is owned by Microsoft?", answers: [
                    Answer(text: "Hotmail", correct: true),
                    Answer(text: "Yahoo! Mail", correct: false),
                    Answer(text: "Gmail", correct: false),
                    Answer(text: "AOL Mail", correct: false),
                ]))
                gameModels.append(Question(text: "What was Twitter’s original name?", answers: [
                    Answer(text: "tweet tweet", correct: false),
                    Answer(text: "twttr", correct: true),
                    Answer(text: "myspace", correct: false),
                    Answer(text: "hashtag", correct: false),
                ]))
                gameModels.append(Question(text: "What was the first cryptocurrency launced in 1990?", answers: [
                    Answer(text: "Bitcoin", correct: false),
                    Answer(text: "Ethereum", correct: false),
                    Answer(text: "eCash", correct: true),
                    Answer(text: "Tether", correct: false),
                ]))
    }
    
    // Table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion?.answers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currentQuestion?.answers[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //unwrap since not an optional
        guard let question = currentQuestion else {
            return
        }
        let answer = question.answers[indexPath.row]
        if checkAnswer(answer: answer, question: question) {
            //correct
            score += 1
            rlabel.text = "Score: \(score)"
            if let index = gameModels.firstIndex(where: { $0.text == question.text}) {
                if index < (gameModels.count - 1) {    //check if last question, if last question, game over. Otherwise, go to next question
                    //next question
                    let nextQuestion = gameModels[index+1]
                    currentQuestion = nil
                    configureUI(question: nextQuestion)
                    
                }
                else {
                    //end of game show alert
                    let alert = UIAlertController(title: "Awesome", message: "End of Game. Do you want to start over?", preferredStyle: .alert)
                    let restartAction = UIAlertAction(title: "Restart", style: .default, handler: {action in self.viewDidLoad()})
                    alert.addAction(restartAction)
                    present(alert, animated: true, completion: nil)
                    score = 0
                }
            }
        }
        else {
            //wrong
            let alert = UIAlertController(title: "Wrong", message: "Incorrect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }

}
//need 2 objects: one for question and one for answer
struct Question {
    let text: String
    let answers: [Answer] //array of answers
}

struct Answer {   //answer object
    let text: String
    let correct: Bool  //true or false
}


