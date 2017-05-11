//
//  User.swift
//  HappinessJournal
//
//  Created by Asher Dale on 2/5/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    
    var days = [String: Day]()
    var goal = 3
    var name = ""
    var proPic = UIImageView()
    var streakDates = [Date]()
    var level = 1
    var xp = 0
    var startDate = Calendar.current.startOfDay(for: Date())
    var longestStreak = 0
    var hasReminder = false
    var reminderTime = ""
    
    static var sharedUser = User(rand: 13)
    private init(rand: Int) { }
    
    // Creates a "User" object out of encoded data that was previously stored in the device
    required init(coder aDecoder: NSCoder) {
        days = aDecoder.decodeObject(forKey: "days") as! [String: Day]
        name = aDecoder.decodeObject(forKey: "name") as! String
        proPic = aDecoder.decodeObject(forKey: "proPic") as! UIImageView
        streakDates = aDecoder.decodeObject(forKey: "streakDates") as! [Date]
        xp = aDecoder.decodeInteger(forKey: "xp")
        level = aDecoder.decodeInteger(forKey: "level")
        startDate = aDecoder.decodeObject(forKey: "startDate") as! Date
        longestStreak = aDecoder.decodeInteger(forKey: "longestStreak")
        hasReminder = aDecoder.decodeBool(forKey: "hasReminder")
        reminderTime = aDecoder.decodeObject(forKey: "reminderTime") as! String
    }
    
    // Encodes and saves a "User" object in the device
    func encode(with aCoder: NSCoder) {
        aCoder.encode(days, forKey: "days")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(proPic, forKey: "proPic")
        aCoder.encode(streakDates, forKey: "streakDates")
        aCoder.encode(xp, forKey: "xp")
        aCoder.encode(level, forKey: "level")
        aCoder.encode(startDate, forKey: "startDate")
        aCoder.encode(longestStreak, forKey: "longestStreak")
        aCoder.encode(hasReminder, forKey: "hasReminder")
        aCoder.encode(reminderTime, forKey: "reminderTime")
    }
    
    // Adds xp to the user and levels the user up if applicable
    func addXP(num: Int) {
        xp += num
        if xp >= (20*level-10) {
            xp -= (20*level-10)
            level += 1
        }
    }
}
