//
//  FIRStorage.swift
//  MDB Social
//
//  Created by Jennessa Ma on 3/6/21.
//

import Foundation
import FirebaseStorage

class FIRStorage {
    
    static let shared = FIRStorage()
    
    //let storage = Storage.storage(url: "gs://mdb-social-sp21.appspot.com")
    let storage = Storage.storage()
    
    let metadata: StorageMetadata = {
        let newMetadata = StorageMetadata()
        newMetadata.contentType = "image/jpeg"
        return newMetadata
    }()
        
        
}
