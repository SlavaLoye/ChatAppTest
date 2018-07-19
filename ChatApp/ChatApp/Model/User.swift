//
//  User.swift
//  ChatApp
//
//  Created by Вячеслав Лойе on 24.06.2018.
//  Copyright © 2018 Вячеслав Лойе. All rights reserved.
//

import UIKit
import Firebase


class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}

//var firstName: String!
//var email: String!
//var photoURL: String!
//var uid: String!
//var ref: DatabaseReference!
//var key: String!
//var lastName: String!
//var accountType: String!
//
//init?(snapshot: DataSnapshot?) {
//
//    guard let value = snapshot?.value as? [String: AnyObject],
//        let accountType = value["Account Type"] as? String,
//        let firstName = value["First Name"] as? String,
//        let email = value["email"] as? String,
//        let uid = value["uid"] as? String,
//        let photoURL = value["photoURL"] as? String,
//        let lastName = value["Last Name"] as? String else {
//            return nil
//    }
//
//    self.key = snapshot?.key
//    self.ref = snapshot?.ref
//    self.accountType = accountType
//    self.firstName = firstName
//    self.email = email
//    self.uid = uid
//    self.photoURL = photoURL
//    self.lastName = lastName
//}
//
//func getFullName() -> String {
//    return ("\(firstName!) \(lastName!)")
//}
//
//}
