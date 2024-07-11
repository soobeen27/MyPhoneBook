//
//  PhoneBook+CoreDataProperties.swift
//  MyPhoneBook
//
//  Created by Soo Jang on 7/11/24.
//
//

import Foundation
import CoreData


extension PhoneBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneBook> {
        return NSFetchRequest<PhoneBook>(entityName: CoreDataInfo.entityName)
    }

    @NSManaged public var name: String?
    @NSManaged public var number: String?
    @NSManaged public var profileImg: String?

}

extension PhoneBook : Identifiable {

}
