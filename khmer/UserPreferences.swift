//  Project name: Calendar
//  File name   : UserPreferences.swift
//
//  Author      : Tran Huu Tam
//  Created date: 9/23/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Webonyx. All rights reserved.
//  --------------------------------------------------------------

import UIKit


class UserPreferences : NSObject {
   
    // MARK: Class's constructors
    override init() {
        super.init()
        var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var data: NSData? = userDefaults.objectForKey(keyPreference) as? NSData
        if (data == nil || data?.length == 0) {
            preferences = NSMutableDictionary(capacity: 10)
        }
        else {
            var dictionary: NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as NSDictionary
            preferences = NSMutableDictionary(dictionary: dictionary)
        }
    }
    
    
    // MARK: Class's properties
    var preferences: NSMutableDictionary?
    
    // MARK: Class's public methods
    func objectForKey(key: String) -> AnyObject? {
        return preferences?.objectForKey(key)
    }
    
    func setValue(value: AnyObject!, withKey key: NSString!) {
        if (value == nil || key == nil || key.length == 0) {
            return
        }
        let lockQueue = dispatch_queue_create(queueName, nil)
        if let cloneValue = self.preferences? {
            dispatch_sync(lockQueue, {
                cloneValue.setValue(value, forKey: key)
            })
        }
    }
    
    func save() {
        var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var data: NSData = NSKeyedArchiver.archivedDataWithRootObject(preferences!) as NSData
        userDefaults.setObject(data, forKey: keyPreference)
        userDefaults.synchronize()
    }
    
    func enableSwWithKey(key: NSString) -> Bool {
        var enable: NSNumber? = self.objectForKey(key) as? NSNumber
        return ((enable != nil) ? enable!.boolValue : true)
    }
    
    func setSwWithKey(key: NSString, value: Bool) {
        self.setValue(NSNumber(bool: value), withKey: key)
    }
    
    // MARK: Class's private methods
    
}