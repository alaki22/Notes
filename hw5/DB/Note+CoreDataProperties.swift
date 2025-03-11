//
//  Note+CoreDataProperties.swift
//  hw5
//
//  Created by Ani Lakirbaia on 06.02.25.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var color: String?

}

extension Note : Identifiable {

}
