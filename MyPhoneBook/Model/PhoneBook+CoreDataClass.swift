//
//  PhoneBook+CoreDataClass.swift
//  MyPhoneBook
//
//  Created by Soo Jang on 7/11/24.
//
//

import Foundation
import CoreData

@objc(PhoneBook)
public class PhoneBook: NSManagedObject {
    public enum Key {
        static let name = "name"
        static let number = "number"
        static let profileImg = "profileImg"
    }
}
