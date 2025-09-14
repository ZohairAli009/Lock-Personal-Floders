//
//  Folder+CoreDataProperties.swift
//  Lock-Folder-App
//
//  Created by Zohair on 24/10/2024.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var folderName: String?
    @NSManaged public var items: String?
    @NSManaged public var dateCreated: String?
    @NSManaged public var password: String?
    @NSManaged public var toFiles: NSOrderedSet?

}

// MARK: Generated accessors for toFiles
extension Folder {

    @objc(insertObject:inToFilesAtIndex:)
    @NSManaged public func insertIntoToFiles(_ value: Files, at idx: Int)

    @objc(removeObjectFromToFilesAtIndex:)
    @NSManaged public func removeFromToFiles(at idx: Int)

    @objc(insertToFiles:atIndexes:)
    @NSManaged public func insertIntoToFiles(_ values: [Files], at indexes: NSIndexSet)

    @objc(removeToFilesAtIndexes:)
    @NSManaged public func removeFromToFiles(at indexes: NSIndexSet)

    @objc(replaceObjectInToFilesAtIndex:withObject:)
    @NSManaged public func replaceToFiles(at idx: Int, with value: Files)

    @objc(replaceToFilesAtIndexes:withToFiles:)
    @NSManaged public func replaceToFiles(at indexes: NSIndexSet, with values: [Files])

    @objc(addToFilesObject:)
    @NSManaged public func addToToFiles(_ value: Files)

    @objc(removeToFilesObject:)
    @NSManaged public func removeFromToFiles(_ value: Files)

    @objc(addToFiles:)
    @NSManaged public func addToToFiles(_ values: NSOrderedSet)

    @objc(removeToFiles:)
    @NSManaged public func removeFromToFiles(_ values: NSOrderedSet)

}

extension Folder : Identifiable {

}
