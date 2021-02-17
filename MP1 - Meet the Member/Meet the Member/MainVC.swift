//
//  MainVC.swift
//  Meet the Member
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    // Create a property for our timer, we will initialize it in viewDidLoad
    var timer: Timer?
    
    // MARK: STEP 8: UI Customization
    // Customize your imageView and buttons. Run the app to see how they look.
    
    let imageView: UIImageView = {
        let view = UIImageView()
        
        // MARK: >> Your Code Here <<
        
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
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        
        // If you don't like the default presentation style,
        // you can change it to full screen too! This way you
        // will have manually to call
        // dismiss(animated: true, completion: nil) in order
        // to go back.
        //
        //modalPresentationStyle = .fullScreen
        
        // MARK: STEP 7: Adding Subviews and Constraints
        // Add imageViews and buttons to the root view. Create constaints
        // for the layout. Then run the app with ⌘+r. You should see the image
        // for the first question as well as the four options.
        
        
        // MARK: >> Your Code Here <<
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        for i in 0...3 {
            view.addSubview(buttons[i])
        }
//        view.addSubview(buttons[0])
//        view.addSubview(buttons[1])
//        view.addSubview(buttons[2])
//        view.addSubview(buttons[3])
        
        NSLayoutConstraint.activate([
            buttons[0].topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 80),
            buttons[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            buttons[0].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120),
            buttons[0].heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            buttons[1].topAnchor.constraint(equalTo: buttons[0].bottomAnchor, constant: 20),
            buttons[1].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            buttons[1].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120),
            buttons[1].heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            buttons[2].topAnchor.constraint(equalTo: buttons[1].bottomAnchor, constant: 20),
            buttons[2].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            buttons[2].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120),
            buttons[2].heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            buttons[3].topAnchor.constraint(equalTo: buttons[2].bottomAnchor, constant: 20),
            buttons[3].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            buttons[3].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120),
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
        
        
        // MARK: STEP 12: Stats Button
        // Follow instructions at :49
        
        // MARK: >> Your Code Here <<
    }
    
    // What's the difference between viewDidLoad() and
    // viewWillAppear()? What about viewDidAppear()?
    override func viewWillAppear(_ animated: Bool) {
        // MARK: STEP 15: Resume Game
        // Restart the timer when view reappear.
        
        // MARK: >> Your Code Here <<
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
            buttons[i].setTitleColor(.blue, for: .normal)
        }
        
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
    }
    
    @objc func didTapStats(_ sender: UIButton) {
        
        let vc = StatsVC(data: "Hello")
        
        vc.dataWeNeedExample1 = "Hello"
        
        // MARK: STEP 13: StatsVC Data
        // Follow instructions in StatsVC. You also need to invalidate
        // the timer instance to pause game before going to StatsVC.
        
        // MARK: >> Your Code Here <<
        
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: STEP 16:
    // Read the spec again and run the app. Did you cover everything
    // mentioned in it? Play around it for a bit, see if you can
    // uncover any bug. Is there anything else you want to add?
}
