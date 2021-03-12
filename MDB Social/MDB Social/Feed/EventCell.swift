//
//  EventCell.swift
//  MDB Social
//
//  Created by Jennessa Ma on 3/4/21.
//

import UIKit
import FirebaseStorage

class EventCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = String(describing: EventCell.self)
    
    private var rsvpNames: [String] = []
    
    var event: Event? {
        didSet {
            print("BEFORE GETTING THE REFERENCE ")
            print("event url: \(event!.photoURL)")
            //set picture of event, name of member, name of event, name of people who RSVP'd
            let gsReference: StorageReference = FIRStorage.shared.storage.reference(forURL: event!.photoURL)
            gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("bad stuff happened: \(error)")
                  } else {
                    self.imageView.image = UIImage(data: data!)
                  }
            }
            
            nameEvent.text = event?.name
            
            //userIDs = [creator, rsvpd1, rsvpd2, ...]
            //var userIDs: [UserID] = [event!.creator]
            //userIDs.append(contentsOf: event!.rsvpUsers)
            
            rsvpd.text = "RSVP'd: \(event?.rsvpUsers.count ?? 0)"
            
            //lists the NAMES of the rsvp'd rather than just count
//            for uid in userIDs {
//                let docRef = FIRDatabaseRequest.shared.db.collection("users").document(uid)
//                docRef.getDocument(completion: { (querySnapshot, err) in
//                    if let err = err {
//                        print("Error getting documents: \(err)")
//                        print("Error in getting the userIDs of rsvpd")
//                    } else {
//                        guard let user = try? querySnapshot?.data(as: User.self) else {
//                            return
//                        }
//                        if (uid == self.event?.creator) {
//                            self.nameMember.text = user.fullname
//                        } else {
//                            self.rsvpNames.append(user.fullname)
//                        }
//                    }
//                })
//            }
            //rsvpd.text = "RSVP'd: " + rsvpNames.joined(separator: ", ")
            
            let docRef = FIRDatabaseRequest.shared.db.collection("users").document(event!.creator)
            docRef.getDocument(completion: { (querySnapshot, err) in
                if let err = err {
                    print("Error getting docuemnt of event creator: \(err)")
                } else {
                    guard let user = try? querySnapshot?.data(as: User.self) else {
                        print("error in getting user of creator")
                        return
                    }
                    self.nameMember.text = user.fullname
                }
            })
            
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameEvent: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameMember: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rsvpd: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 226/255, green: 234/255, blue: 252/255, alpha: 1)
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameEvent)
        contentView.addSubview(nameMember)
        contentView.addSubview(rsvpd)
        
        //source for rounded cells: https://medium.com/dev-genius/swift-how-to-create-a-rounded-collectionviewcell-with-shadow-d696bd46c43f
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 15.0
        self.contentView.layer.borderWidth = 5.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 0.6
        self.layer.cornerRadius = 15.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 90),
            imageView.heightAnchor.constraint(equalToConstant: 90),
            nameEvent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameEvent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameMember.topAnchor.constraint(equalTo: nameEvent.bottomAnchor, constant: 10),
            nameMember.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            rsvpd.topAnchor.constraint(equalTo: nameMember.bottomAnchor, constant: 10),
            rsvpd.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
