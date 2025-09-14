//
//  Files+CoreDataProperties.swift
//  Lock-Folder-App
//
//  Created by Zohair on 24/10/2024.
//
//

import Foundation
import CoreData


extension Files {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Files> {
        return NSFetchRequest<Files>(entityName: "Files")
    }

    @NSManaged public var fileType: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var videoUrl: String?
    @NSManaged public var toFolder: Folder?

}

extension Files : Identifiable {

}
