//
//  EventCell.swift
//  MDB Social
//
//  Created by Jennessa Ma on 3/4/21.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = String(describing: EventCell.self)
    
    private var rsvpNames: [String] = []
    
    var event: Event? {
        didSet {
            //set picture of event, name of member, name of event, name of people who RSVP'd
            if let url: URL = URL(string: (event?.photoURL)!) {
                if let data = try? Data(contentsOf: url) {
                        imageView.image = UIImage(data: data)
                    }
            }
            nameEvent.text = event?.name
            
            //userIDs = [creator, rsvpd1, rsvpd2, ...]
            var userIDs: [UserID] = [event!.creator]
            userIDs.append(contentsOf: event!.rsvpUsers)
            
            for uid in userIDs {
                let docRef = FIRDatabaseRequest.shared.db.collection("users").document(uid)
                docRef.getDocument(completion: { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        guard let user = try? querySnapshot?.data(as: User.self) else {
                            return
                        }
                        if (uid == self.event?.creator) {
                            self.nameMember.text = user.fullname
                        } else {
                            self.rsvpNames.append(user.fullname)
                        }
                    }
                })
            }
            rsvpd.text = "RSVP'd: " + rsvpNames.joined(separator: ", ")
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
        label.font = UIFont.boldSystemFont(ofSize: 20)
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
        backgroundColor = .background
        contentView.backgroundColor = UIColor(red: 226/255, green: 234/255, blue: 252/255, alpha: 1)
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameEvent)
        contentView.addSubview(nameMember)
        contentView.addSubview(rsvpd)
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor //black?
        contentView.layer.shadowRadius = 2.0
        
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
