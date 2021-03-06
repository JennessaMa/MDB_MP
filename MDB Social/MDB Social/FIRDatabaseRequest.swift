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
    
    var listener: ListenerRegistration?
        
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
    func getEvents(vc: FeedVC)->[Event] {
        var events: [Event] = []
        if (FIRAuthProvider.shared.isSignedIn()) {
            listener = db.collection("events").order(by: "startTimeStamp", descending: true)
                    .addSnapshotListener { querySnapshot, error in
                    events = []
                        if (FIRAuthProvider.shared.isSignedIn()) {
                            guard let documents = querySnapshot?.documents else {
                                print("Error fetching documents: \(error!)")
                                print("error in getEvents")
                                return
                            }
                            for document in documents {
                                guard let event = try? document.data(as: Event.self) else {
                                    print("problem converting document into event")
                                    return
                                }
                                events.append(event)
                            }
                            vc.updateEvents(newEvents: events)
                        }
                        
                }
        
            return events
        }
        //this never gets called?
        return events
    }
}
