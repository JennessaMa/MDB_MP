//
//  MainVC.swift
//  Meet the Member
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    //boolean to tell if it's in pause mode (don't increment timer)
    var paused: Bool = false
    
    //count to keep track of longest streak of correct answers
    var streak: Int = 0
    
    //boolean to keep track of whether the user has answered or not
    var answered: Bool = false
    
    //array to keep track of results in the form"memberName: correct/incorrect"
    var statAnswers: [String] = []
    
    //count to keep track of the timer
    var timerCount: Int = 0
    
    //boolean to tell when it's between answering questions phase
    var resPhase: Bool = false
    
    //current score
    var score:Int = 0
    
    //user's answer (button tag)
    var userAnswer: Int = 0
    
    //correct answer in name form
    var answer:String?
    
    // Create a property for our timer, we will initialize it in viewDidLoad
    var timer: Timer?
    
    // MARK: STEP 8: UI Customization
    // Customize your imageView and buttons. Run the app to see how they look.
    
    let scoreLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "SCORE: 0"
        lbl.font = UIFont.boldSystemFont(ofSize: 27)
        lbl.textColor = .white
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        
        // MARK: >> Your Code Here <<
        view.layer.borderWidth = 8
        view.layer.borderColor = UIColor(red: 237/255, green: 246/255, blue: 249/255, alpha: 1).cgColor
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let buttons: [UIButton] = {
        // Creates 4 buttons, each representing a choice.
        // Use ..< or ... notation to create an iterable range
        // with step of 1. You can manually create these using the
        // stride() method.
        return (0..<4).map { index in
            let button = UIButton()

            // Tag the button its index
            button.tag = index
            
            // MARK: >> Your Code Here <<
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.setTitleColor(.white, for: .normal)
//            button.backgroundColor = UIColor(red: 226/255, green: 149/255, blue: 120/255, alpha: 1)
            button.layer.cornerRadius = 20
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }
        
    }()
    
    // MARK: STEP 12: Stats Button
    // Follow the examples you've learned so far, initialize a
    // stats button used for going to the stats screen, add it
    // as a subview inside the viewDidLoad and set up the
    // constraints. Finally, connect the button's with the @objc
    // function didTapStats.
    
    // MARK: >> Your Code Here <<
    let statsButton: UIButton = {
        let button = UIButton()
        button.setTitle("STATS", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 228/255, green: 217/255, blue: 1, alpha: 1)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //PAUSE button
    let pauseButton: UIButton = {
       let button = UIButton()
        button.setTitle("PAUSE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 117/255, green: 70/255, blue: 104/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        //refresh questions each time user presses start
        QuestionProvider.shared.reset()
        
        view.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 210/255, alpha: 1)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        
        // If you don't like the default presentation style,
        // you can change it to full screen too! This way you
        // will have manually to call
        // dismiss(animated: true, completion: nil) in order
        // to go back.
        //
        //modalPresentationStyle = .fullScreen
        
        // MARK: STEP 7: Adding Subviews and Constraints
        // Add imageViews and buttons to the root view. Create constraints
        // for the layout. Then run the app with ⌘+r. You should see the image
        // for the first question as well as the four options.
        
        
        // MARK: >> Your Code Here <<
        view.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90)
        ])
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, constant: 20)
        ])
        
        for i in 0...3 {
            view.addSubview(buttons[i])
        }

        NSLayoutConstraint.activate([
            buttons[0].topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 60),
            buttons[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            buttons[0].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            buttons[0].heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            buttons[1].topAnchor.constraint(equalTo: buttons[0].bottomAnchor, constant: 20),
            buttons[1].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            buttons[1].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            buttons[1].heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            buttons[2].topAnchor.constraint(equalTo: buttons[1].bottomAnchor, constant: 20),
            buttons[2].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            buttons[2].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            buttons[2].heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            buttons[3].topAnchor.constraint(equalTo: buttons[2].bottomAnchor, constant: 20),
            buttons[3].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            buttons[3].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            buttons[3].heightAnchor.constraint(equalToConstant: 40)
        ])
        
        getNextQuestion()
        
        // MARK: STEP 10: Adding Callback to the Buttons
        // Use addTarget to connect the didTapAnswer function to the four
        // buttons touchUpInside event.
        //
        // Challenge: Try not to use four separate statements. There's a
        // cleaner way to do this, see if you can figure it out.
        
        // MARK: >> Your Code Here <<
        for i in 0...3 {
            buttons[i].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        }
        
        // MARK: STEP 12: Stats Button
        // Follow instructions at :49
        
        // MARK: >> Your Code Here <<
        view.addSubview(statsButton)
        NSLayoutConstraint.activate([
            statsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            statsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            statsButton.widthAnchor.constraint(equalTo: statsButton.heightAnchor, constant: 50)
        ])
        
        statsButton.addTarget(self, action: #selector(didTapStats(_:)), for: .touchUpInside)
        
        view.addSubview(pauseButton)
        NSLayoutConstraint.activate([
            pauseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pauseButton.widthAnchor.constraint(equalTo: pauseButton.heightAnchor, constant: 80)
        ])
        
        pauseButton.addTarget(self, action: #selector(didTapPause(_:)), for: .touchUpInside)
    }
    
    // What's the difference between viewDidLoad() and
    // viewWillAppear()? What about viewDidAppear()?
    override func viewWillAppear(_ animated: Bool) {
        // MARK: STEP 15: Resume Game
        // Restart the timer when view reappear.
        
        // MARK: >> Your Code Here <<
        streak = 0
        paused = false
        pauseButton.backgroundColor = UIColor(red: 117/255, green: 70/255, blue: 104/255, alpha: 1)
        pauseButton.setTitle("PAUSE", for: .normal)
        pauseButton.setTitleColor(.white, for: .normal)
    }
    
    func getNextQuestion() {
        // MARK: STEP 5: Connecting to the Data Model
        // Read the QuestionProvider class in Utils.swift. Get an instance of
        // QuestionProvider.Question and use a *guard let* statement to conditionally
        // assign it to a constant named question. Return if the guard let
        // condition failed.
        //
        // After you are done, take a look at what's in the
        // QuestionProvider.Question type. You will need that for the
        // following steps.
        
        // MARK: >> Your Code Here <<
        guard let question = QuestionProvider.shared.getNextQuestion() else {
            return
        }
        
        // MARK: STEP 6: Data Population
        // Populate the imageView and buttons using the question object we obtained
        // above.
        
        // MARK: >> Your Code Here <<
        imageView.image = question.image
        for i in 0...3 {
            buttons[i].setTitle(question.choices[i], for: .normal)
            //moved from initializer b/c need to reset after res phase
            buttons[i].backgroundColor = UIColor(red: 226/255, green: 149/255, blue: 120/255, alpha: 1)
        }
        //set properties
        answer = question.answer
        scoreLabel.text = "SCORE: \(score)"
        answered = false
        resPhase = false
        timerCount = 0
    }
    
    // This function will be called every one second
    @objc func timerCallback() {
        // MARK: STEP 11: Timer's Logic
        // Complete the callback for the one-second timer. Add instance
        // properties and/or methods to the class if necessary. Again,
        // the instruction here is intentionally vague, so read the spec
        // and take some time to plan. you may need
        // to come back and rework this step later on.
        
        // MARK: >> Your Code Here <<
        
        if !paused { //only continue the timer if it's not paused
            if resPhase { //in between answering questions --> flash buttons green/red for 1 second
                let b = buttons[userAnswer]
                if b.title(for: .normal) == answer && answered { //guessed correct answer
                    b.backgroundColor = UIColor(red: 150/255, green: 204/255, blue: 0, alpha: 1)
                } else if b.title(for: .normal) != answer && answered { //guessed incorrect answer
                    b.backgroundColor = UIColor(red: 158/255, green: 42/255, blue: 43/255, alpha: 1)
                } else { //didn't answer at all
                    for bt in buttons {
                        if bt.title(for: .normal) == answer {
                            bt.backgroundColor = UIColor(red: 158/255, green: 42/255, blue: 43/255, alpha: 1)
                            break
                        }
                    }
                }
                resPhase = false
                timerCount += 1
            } else if timerCount == 5 && !answered { //time limit passed for the user to answer the question
                resPhase = true
            } else if timerCount >= 6 || (answered && !resPhase) { //(user didn't answer or user answered early) and resPhase over
                getNextQuestion() //will reset the timerCount
            } else {
                timerCount += 1
            }
        }
    }
    
    @objc func didTapAnswer(_ sender: UIButton) {
        // MARK: STEP 9: Buttons' Logic
        // Add logic for the 4 buttons. Take some time to plan what
        // you are gonna write. The 4 buttons should be able to share
        // the same callback. Add instance properties and/or methods
        // to the class if necessary. The instruction here is
        // intentionally vague as I'd like you to decide what you
        // have to do based on the spec. You may need to come back
        // and rework this step later on.
        //
        // Hint: You can use `sender.tag` to identify which button is tapped
        
        // MARK: >> Your Code Here <<
        if !paused { //only able to answer question if game isn't paused
            answered = true
            userAnswer = sender.tag
            resPhase = true
            var statRes = "incorrect :("
            let b = buttons[userAnswer]
            if b.title(for: .normal) == answer {
                statRes = "correct!"
                streak += 1
                score += 1
            } else {
                streak = 0
            }
            statAnswers.append("\(answer ?? ""): \(statRes)")
        }
    }
    
    @objc func didTapPause(_ sender: UIButton) {
        if paused == false { //user clicking "pause", reset score
            paused = true
            pauseButton.backgroundColor = .white
            pauseButton.setTitle("RESUME", for: .normal)
            pauseButton.setTitleColor(UIColor(red: 117/255, green: 70/255, blue: 104/255, alpha: 1), for: .normal)
            score = 0
            streak = 0
        } else if paused { //user clicking "resume"
            paused = false
            pauseButton.backgroundColor = UIColor(red: 117/255, green: 70/255, blue: 104/255, alpha: 1)
            pauseButton.setTitle("PAUSE", for: .normal)
            pauseButton.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc func didTapStats(_ sender: UIButton) {
        
        let vc = StatsVC(data: "Hello")
        
        //vc.dataWeNeedExample1 = "Hello"
        
        vc.modalPresentationStyle = .fullScreen
        
        // MARK: STEP 13: StatsVC Data
        // Follow instructions in StatsVC. You also need to invalidate
        // the timer instance to pause game before going to StatsVC.
        
        // MARK: >> Your Code Here <<
        
        let numAnswers = statAnswers.count
//        var resString:[String]?
        var resData:[String] = []
        var data: [[String]] = []
        
        data.append(["You current have a streak of \(streak)!"])
        
        if numAnswers >= 3 {
            resData = Array(statAnswers[numAnswers - 3...numAnswers - 1])
        } else {
            resData = statAnswers
        }
        while resData.count < 3 {
            resData.append("")
        }
        data.append(resData)
        
//        for res in resData {
//            resString += "\n \(res)"
//        }
        
        //let data: String = "Your current streak is \(streak)! \n \n Your 3 most recent answers are: \(resString)"
        vc.dataWeNeedExample1 = data
        
        if !paused { //what if user presses pause and then stats
            didTapPause(statsButton) //idk about this
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: STEP 16:
    // Read the spec again and run the app. Did you cover everything
    // mentioned in it? Play around it for a bit, see if you can
    // uncover any bug. Is there anything else you want to add?
}
