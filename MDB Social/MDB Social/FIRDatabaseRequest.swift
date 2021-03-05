//
//  FIRDatabaseRequest.swift
//  MDB Social
//
//  Created by Michael Lin on 2/25/21.
//

import Foundation
import FirebaseFirestore

class FIRDatabaseRequest {
    
    static let shared = FIRDatabaseRequest()
    
    let db = Firestore.firestore()
    
    func setUser(_ user: User, completion: (()->Void)?) {
        guard let uid = user.uid else { return }
        do {
            try db.collection("users").document(uid).setData(from: user)
            completion?()
        }
        catch { }
    }
    
    func setEvent(_ event: Event, completion: (()->Void)?) {
        guard let id = event.id else { return }
        
        do {
            try db.collection("events").document(id).setData(from: event)
            completion?()
        } catch { }
    }
    
    /* TODO: Events getter */
    func getEvents()->[Event] {
        var events: [Event] = []
        
        //follows "get data once" section
//        db.collection("events").order(by: "startTimeStamp", descending: true).getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    guard let event = try? document.data(as: Event.self) else {
//                        //do nothing if failed to get event
//                        return
//                    }
//                    events.append(event)
//                }
//            }
//        }
        
        //follows "Listen for realtime updates" section
        db.collection("events").order(by: "startTimeStamp", descending: true)
                .addSnapshotListener{ querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                for document in documents {
                    guard let event = try? document.data(as: Event.self) else {
                        //do nothing if failed to get event
                        return
                    }
                    events.append(event)
                }
            }
        
        //sort events to display most recent ones first
        //events.sort(by: { event1, event2 in return event1.startDate > event2.startDate })
        
        return events
    }
}
