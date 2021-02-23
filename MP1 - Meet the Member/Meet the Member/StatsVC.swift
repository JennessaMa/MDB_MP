//
//  StatsVC.swift
//  Meet the Member
//
//  Created by Michael Lin on 1/18/21.
//

import UIKit

class StatsVC: UIViewController {
    
    // MARK: STEP 13: StatsVC Data
    // When we are navigating between VCs (e.g MainVC -> StatsVC),
    // since MainVC doesn't directly share its instance properties
    // with other VCs, we often need a mechanism of transferring data
    // between view controllers. There are many ways to achieve
    // this, and I will show you the two most common ones today. After
    // carefully reading these two patterns, pick one and implement
    // the data transferring for StatsVC.
    
    // Method 1: Implicit Unwrapped Instance Property
    //var dataWeNeedExample1: String!
    var dataWeNeedExample1: [[String]]!
    //
    // Check didTapStats in MainVC.swift on how to use it.
    //
    // Explanation: This method is fairly straightforward: you
    // declared a property, which will then be populated after
    // the VC is instantiated. As long as you remember to
    // populate it after each instantiation, the implicit forced
    // unwrap will not result in a crash.
    //
    // Pros: Easy, no boilerplate required
    //
    // Cons: Poor readability. Imagine if another developer wants to
    // use this class, unless it's been well-documented, they would
    // have no idea that this variable needs to be populated.
    
    // Method 2: Custom initializer
    var dataWeNeedExample2: String
    init(data: String) {
        dataWeNeedExample2 = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //
    // Check didTapStats in MainVC.swift on how to use it.
    //
    // Explanation: This method creates a custom initializer which
    // takes in the required data. This pattern results in a cleaner
    // initialization and is more readable. Compared with method 1
    // which first initialize the data to nil then populate, in this
    // method the data is directly initialized in the init so there's
    // no need for unwrapping of any kind.
    //
    // Pros: Clean. Null safe.
    //
    // Cons: Doesn't work with interface builder (storyboard)
    
    // MARK: >> Your Code Here <<
    
    // MARK: STEP 14: StatsVC UI
    // You know the drill. Initialize the UI components, add subviews,
    // and create contraints.
    //
    // Note: You cannot use self inside these closures because they
    // happens before the instance is fully initialized. If you want
    // to use self, do it in viewDidLoad.
    
    // MARK: >> Your Code Here <<
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("BACK", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 228/255, green: 217/255, blue: 1, alpha: 1)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let streakLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 22)
        lbl.textColor = UIColor(red: 163/255, green: 50/255, blue: 11/255, alpha: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        return lbl
    }()
    
    let resIntro: UILabel = {
        let lbl = UILabel()
        lbl.text = "Your most recent answers were: "
        lbl.font = UIFont.boldSystemFont(ofSize: 22)
        lbl.textColor = UIColor(red: 131/255, green: 197/255, blue: 190/255, alpha: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    let resLabels: [UILabel] = {
        return (0..<3).map { index in
            let lbl = UILabel()
            lbl.font = UIFont.boldSystemFont(ofSize: 18)
            lbl.textColor = UIColor(red: 131/255, green: 197/255, blue: 190/255, alpha: 1)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.textAlignment = .center
            
            return lbl
        }
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 237/255, green: 246/255, blue: 249/255, alpha: 1)
        streakLabel.text = dataWeNeedExample1[0][0]
        for i in 0...2 {
            resLabels[i].text = dataWeNeedExample1[1][i]
            view.addSubview(resLabels[i])
        }
        view.addSubview(backButton)
        view.addSubview(streakLabel)
        view.addSubview(resIntro)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor, constant: 70)
        ])
        backButton.addTarget(self, action: #selector(didTapBack(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            streakLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            streakLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            streakLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            streakLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            resIntro.topAnchor.constraint(equalTo: streakLabel.bottomAnchor, constant: 50),
            resIntro.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resIntro.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resIntro.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            resLabels[0].topAnchor.constraint(equalTo: resIntro.bottomAnchor, constant: 20),
            resLabels[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            resLabels[0].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            resLabels[1].topAnchor.constraint(equalTo: resLabels[0].bottomAnchor, constant: 20),
            resLabels[1].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            resLabels[1].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            resLabels[2].topAnchor.constraint(equalTo: resLabels[1].bottomAnchor, constant: 20),
            resLabels[2].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            resLabels[2].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
    }
    
    @objc func didTapBack(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
}
