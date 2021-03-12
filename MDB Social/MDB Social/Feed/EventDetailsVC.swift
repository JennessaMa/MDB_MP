//
//  EventDetailsVC.swift
//  MDB Social
//
//  Created by Jennessa Ma on 3/12/21.
//

import Foundation
import UIKit
import FirebaseStorage

class EventDetailsVC: UIViewController {
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var currEvent: Event? {
        didSet {
            let gsReference: StorageReference = FIRStorage.shared.storage.reference(forURL: currEvent!.photoURL)
            gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("bad stuff happened: \(error)")
                  } else {
                    self.imageView.image = UIImage(data: data!)
                  }
            }
            
            nameEvent.text = currEvent!.name
            rsvpd.text = "RSVP'd: \(currEvent?.rsvpUsers.count ?? 0)"
            let docRef = FIRDatabaseRequest.shared.db.collection("users").document(currEvent!.creator)
            docRef.getDocument(completion: { (querySnapshot, err) in
                if let err = err {
                    print("Error getting docuemnt of event creator: \(err)")
                } else {
                    guard let user = try? querySnapshot?.data(as: User.self) else {
                        print("error in getting user of creator")
                        return
                    }
                    self.nameCreator.text = "Creator: " + user.fullname
                }
            })
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm E, d MMM y"
            date.text = "Date: " + formatter.string(from: currEvent!.startDate)
            desc.text = currEvent?.description
        }
    }
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var nameEvent: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var nameCreator: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var date: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var rsvpd: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var desc: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0 //unlimited # lines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 193/255, green: 211/255, blue: 254/255, alpha: 1)
        view.addSubview(stack)
        stack.addArrangedSubview(nameEvent)
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(nameCreator)
        stack.addArrangedSubview(date)
        stack.addArrangedSubview(desc)
        stack.addArrangedSubview(rsvpd)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -contentEdgeInset.right),
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: contentEdgeInset.top),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
}
