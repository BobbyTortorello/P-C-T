//
//  MyPets+CoreDataProperties.swift
//  P-C-T
//
//  Created by Bobby Tortorello on 9/3/20.
//  Copyright © 2020 App Industries Inc. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


extension MyPets {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyPets> {
        return NSFetchRequest<MyPets>(entityName: "MyPets")
    }

    @NSManaged public var petName: String?
    @NSManaged public var petType: String?
    @NSManaged public var petBreed: String?
    @NSManaged public var petImage: UIImage?

}
