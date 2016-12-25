//
//  DataService.swift
//  DeliveryFromLocals
//
//  Created by Abdo Assem on 12/24/16.
//  Copyright © 2016 Abdo Assem. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class DataService {
    static let dataService = DataService()
    fileprivate let _ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    
    
 
    // fileprivate let _GEOFIRE_URL = Firebase(url: "\(BASE_URL)/geo")
    
    var BASE_REF: FIRDatabaseReference{
        return _ref
    }
    
    
    var USER_REF: FIRDatabaseReference{
        return BASE_REF.child("users")
    }
    
    var ORG_REF: FIRDatabaseReference{
        return BASE_REF.child("orgs")
    }
    

}
