//
//  KeywordEntity.swift
//  german
//
//  Created by Tran Huu Tam on 11/14/14.
//  Copyright (c) 2014 BenjaminSoft. All rights reserved.
//

import Foundation
import CoreData

class KeywordEntity: NSManagedObject {
    
    @NSManaged var keyword: String
    @NSManaged var content: String
    @NSManaged var imageData: NSData
    @NSManaged var isEnglish: Bool
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, keyword: String, content: String, isEnglish: Bool) -> KeywordEntity {
        var newItem: KeywordEntity = NSEntityDescription.insertNewObjectForEntityForName("KeywordEntity", inManagedObjectContext: moc) as KeywordEntity
        newItem.keyword = keyword
        newItem.content = content
        newItem.isEnglish = isEnglish
        return newItem
    }
    
    class func skipThisEntityInBackup(moc: NSManagedObjectContext) {
        var url = appDelegate.applicationDocumentsDirectory.URLByAppendingPathComponent(databaseSqlite) as NSURL
        assert(NSFileManager.defaultManager().fileExistsAtPath(url.path!))
        var error: NSError?
        var success = url.setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey, error: &error)
        if !success {
            println("Error excluding \(url.lastPathComponent) from backup \(error)")
        }
    }
    
    class func getKeyword(moc: NSManagedObjectContext, keyword: String) -> KeywordEntity? {
        var fetchRequest = NSFetchRequest(entityName: "KeywordEntity")
        let firstPredicate = NSPredicate(format: "keyword == %@", keyword)
        if let fp = firstPredicate {
            fetchRequest.predicate = fp
        }
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [KeywordEntity] {
            if fetchResults.count > 0 {
                return fetchResults.first!
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
}
