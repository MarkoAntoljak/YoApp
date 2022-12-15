//
//  User.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.
//

import Foundation


final class User: Equatable {
    
    static func == (lhs: User, rhs: User) -> Bool {
        
        if lhs.fullName.lowercased() == rhs.fullName.lowercased() {
            
            return true
            
        } else {
            
            return false
        }
        
    }
    
    
    let firstName: String
    
    let lastName: String
    
    let phoneNumber: String
    
    let email: String?
    
    var dateAndTimeSent: Date?
    
    var fullName: String {
        
        return "\(firstName) \(lastName)"
    }
    
    init(firstName: String, lastName: String, phoneNumber: String, email: String?, dateAndTimeSent: Date? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.dateAndTimeSent = dateAndTimeSent
    }
        
}
