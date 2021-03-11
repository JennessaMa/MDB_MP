//
//  FeedVC.swift
//  MDB Social
//
//  Created by Michael Lin on 2/25/21.
//

import UIKit

class FeedVC: UIViewController {
    
    var events: [Event]?
    
     func updateEvents(newEvents: [Event]) {
        print("in updatingEvents")
        events = newEvents
        collectionView.reloadData()
    }
        
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "MDB Socials"
        lbl.font = UIFont.boldSystemFont(ofSize: 30)
        lbl.textColor = UIColor(red: 133/255, green: 169/255, blue: 255/255, alpha: 1)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.reuseIdentifier)
        
        return collectionView
    }()
    
    private let signOutButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 85/255, green: 12/255, blue: 24/255, alpha: 1)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .medium))
        btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let createEventButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 171/255, green: 196/255, blue: 255/255, alpha: 1)
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 40, weight: .medium))
        btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        events = FIRDatabaseRequest.shared.getEvents(vc: self)
        view.addSubview(signOutButton)
        NSLayoutConstraint.activate([
            signOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signOutButton.widthAnchor.constraint(equalTo: signOutButton.heightAnchor, constant: 10)
        ])
        signOutButton.addTarget(self, action: #selector(didTapSignOut(_:)), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 170, left: 10, bottom: 90, right: 10))
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(createEventButton) // can't make button round
        NSLayoutConstraint.activate([
            createEventButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            createEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createEventButton.widthAnchor.constraint(equalToConstant: view.frame.width * (4/5)),
            createEventButton.heightAnchor.constraint(equalToConstant: 43)
        ])
        createEventButton.addTarget(self, action: #selector(didTapCreateEvent(_:)), for: .touchUpInside)
    }
    
    @objc func didTapSignOut(_ sender: UIButton) {
        FIRAuthProvider.shared.signOut {
            guard let window = UIApplication.shared
                    .windows.filter({ $0.isKeyWindow }).first else { return }
            let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController()
            window.rootViewController = vc
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
        }
    }
    
    @objc func didTapCreateEvent(_ sender: UIButton) {
        let vc = CreateEventVC()
        present(vc, animated: true, completion: nil)
    }
    
    
}

extension FeedVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events?[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.reuseIdentifier, for: indexPath) as! EventCell
        cell.event = event
        return cell
    }
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * (4/5), height: 120)
    }
}
