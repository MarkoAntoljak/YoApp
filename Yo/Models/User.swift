//
//  User.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.
//

import Foundation


final class User: Equatable, Codable {
    
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
    
    let fullName: String
    
    init(firstName: String, lastName: String, phoneNumber: String, email: String?, fullname: String, dateAndTimeSent: Date? = nil) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullname
        self.phoneNumber = phoneNumber
        self.email = email
        self.dateAndTimeSent = dateAndTimeSent
    }
        
}
