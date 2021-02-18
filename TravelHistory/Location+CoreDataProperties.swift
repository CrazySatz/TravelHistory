//
//  Location+CoreDataProperties.swift
//  TravelHistory
//
//  Created by user on 18/02/21.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: String?
    @NSManaged public var long: String?
    @NSManaged public var time: String?

}

extension Location : Identifiable {

}
