//
//  Time+CoreDataProperties.swift
//  
//
//  Created by 박형석 on 2021/03/07.
//
//

import Foundation
import CoreData


extension Time {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Time> {
        return NSFetchRequest<Time>(entityName: "Time")
    }

    @NSManaged public var time: Int64

}
