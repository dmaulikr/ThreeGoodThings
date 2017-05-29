//
//  EntryController.swift
//  HappinessJournal
//
//  Created by Asher Dale on 12/12/16.
//  Copyright © 2016 Asher Dale. All rights reserved.
//

import UIKit
import UserNotifications

class EntryController: UIViewController, UIScrollViewDelegate, EntryHeaderDelegate, UITabBarControllerDelegate {
    
    var scrollView: UIScrollView!
    var containerView = UIView()
    var pageDate = Date()
    var forwardDisabled = true
    var backwardDisabled = false
    var header: EntryHeader!
    let width = 375
    let height = 667
    var entryBoxes = Array<EntryBox>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the header, background, and other views
        self.view.backgroundColor = User.sharedUser.color
        header = EntryHeader()
        header.delegate = self
        self.view.addSubview(header)
        let headerBottomBorder = UIView(frame: CGRect(x: 0.0, y: 63.5, width: Double(width), height: 0.5, scale: true))
        headerBottomBorder.backgroundColor = UIColor.lightGray
        self.view.addSubview(headerBottomBorder)
        
        self.tabBarController?.delegate = self
        
        let promptLabel = UILabel()
        promptLabel.frame = CGRect(x: width/2 - 150, y: 64, width: 300, height: 52, scale: true)
        promptLabel.text = "What went well today?"
        promptLabel.font = UIFont(name:"HelveticaNeue-Medium", size: 23)!
        promptLabel.textColor = UIColor.white
        promptLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(promptLabel)
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.width, height: User.sharedUser.goal*165+10, scale: true)
        scrollView.addSubview(containerView)
        self.view.addSubview(scrollView)
        
        showBoxes()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(EntryController.doneEditing))
        view.addGestureRecognizer(tap)
        
        // Loads previous data from the device (if applicable)
        if let savedUser = UserDefaults.standard.object(forKey: "user") as? Data {
            User.sharedUser = NSKeyedUnarchiver.unarchiveObject(with: savedUser) as! User
            header.updateStreakIcon()
            showEntries(fromDayStr: createDayString(fromDate: pageDate))
            checkStreak()
        } else {
            User.sharedUser.days.updateValue(createDay(fromDate: pageDate), forKey: createDayString(fromDate: pageDate))
        }
        
        configureBoxes()
    }
    
    // Readjusts the UIScrollView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: 116, width: self.width, height: self.height-64-52-49, scale: true)
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    // Shows the entries of the new date when the date is changed
    func dateChanged(mod: String) {
        if mod == "today" {
            pageDate = Date()
        } else if mod == "forward" && !forwardDisabled {
            pageDate = NSCalendar.current.date(byAdding: .day, value: 1, to: pageDate)!
        } else if mod == "backward" && !backwardDisabled {
            pageDate = NSCalendar.current.date(byAdding: .day, value: -1, to: pageDate)!
        }
        header.showTitle(fromDate: pageDate)
        let newDayStr = createDayString(fromDate: pageDate)
        showEntries(fromDayStr: newDayStr)
        configureHeaderButtons(forwardBool: Calendar.current.isDateInToday(pageDate), backwardBool: User.sharedUser.startDate.days(from: pageDate) == 2)
    }
    
    // Decides whether the buttons on the header are hidden or not
    func configureHeaderButtons(forwardBool: Bool, backwardBool: Bool) {
        forwardDisabled = forwardBool
        header.forwardButton.showsTouchWhenHighlighted = !forwardBool
        header.todayButton.isHidden = forwardBool
        header.todayButton.isEnabled = !forwardBool
        header.streakIcon.isHidden = !forwardBool
        if forwardBool {
            header.forwardButton.tintColor = UIColor.white
        } else {
            header.forwardButton.tintColor = User.sharedUser.color
        }
        
        backwardDisabled = backwardBool
        header.backwardButton.showsTouchWhenHighlighted = !backwardBool
        if backwardBool {
            header.backwardButton.tintColor = UIColor.white
        } else {
            header.backwardButton.tintColor = User.sharedUser.color
        }
    }
    
    // Displays the EntryBoxes
    func showBoxes() {
        for i in 0..<User.sharedUser.goal {
            entryBoxes.append(EntryBox(parentController: self, boxNum: i))
            containerView.addSubview(entryBoxes[i])
        }
    }
    
    // Stops editing an entry if another part of the screen is tapped
    func doneEditing() {
        view.endEditing(true)
    }
    
    // Creates a Day object from the specified date
    func createDay(fromDate: Date) -> Day {
        return Day(day: Calendar.current.component(.day, from: fromDate), month: Calendar.current.component(.month, from: fromDate), year: Calendar.current.component(.year, from: fromDate))
    }
    
    // Create a string from the specified date in the format of "mm/dd/yyyy"
    func createDayString(fromDate: Date) -> String {
        return "\(Calendar.current.component(.month, from: fromDate))/\(Calendar.current.component(.day, from: fromDate))/\(Calendar.current.component(.year, from: fromDate))"
    }
    
    // Saves the text from an EntryBox when it is changed
    func textChanged() {
        configureBoxes()
        let dayStr = createDayString(fromDate: pageDate)
        if !User.sharedUser.days.keys.contains(dayStr) {
            let newDay = createDay(fromDate: pageDate)
            User.sharedUser.days.updateValue(newDay, forKey: dayStr)
        }
        let wasAlreadyComplete = User.sharedUser.days[dayStr]!.isComplete
        for i in 0..<entryBoxes.count {
            User.sharedUser.days[dayStr]!.entries[i] = entryBoxes[i].textView.text
        }
        checkStreak()
        User.sharedUser.days[dayStr]!.updateIfComplete()
        
        if pageDate.days(from: Date()) == 0 && User.sharedUser.days[dayStr]!.isComplete && (User.sharedUser.streakDates.count == 0 || pageDate.days(from: User.sharedUser.streakDates[User.sharedUser.streakDates.endIndex-1]) == 1) {
            User.sharedUser.streakDates.append(pageDate)
            if User.sharedUser.streakDates.count > User.sharedUser.longestStreak {
                User.sharedUser.longestStreak = User.sharedUser.streakDates.count
            }
            header.updateStreakIcon()
            showAlertController(alertStyle: "streak")
        }
        else if User.sharedUser.days[dayStr]!.isComplete && !wasAlreadyComplete  {
            showAlertController(alertStyle: "past")
        }
    }

    // Displays the relevant entries based on the specified date
    func showEntries(fromDayStr: String) {
        for i in 0..<entryBoxes.count {
            if User.sharedUser.days.keys.contains(fromDayStr) {
                entryBoxes[i].textView.text = User.sharedUser.days[fromDayStr]!.entries[i]
            } else {
                entryBoxes[i].textView.text = ""
            }
            entryBoxes[i].resetBoxIfAppropriate()
        }
        configureBoxes()
    }
    
    // Decides which box should have the type prompt in it
    func configureBoxes() {
        var shouldContinue = false
        for entry in entryBoxes {
            if shouldContinue {
                break
            } else if entry.textView.text == "" || entry.textView.text == "Press here to begin typing..." {
                entry.resetBoxToPrompt()
                shouldContinue = true
            }
        }
    }
    
    // Saves the User singleton object onto the device
    func saveData() {
        let savedData = NSKeyedArchiver.archivedData(withRootObject: User.sharedUser)
        UserDefaults.standard.set(savedData, forKey: "user")
    }
    
    // Erases all data from this app on the device
    func resetData() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
    
    // Performs a segue to the introduction screens
    func shiftToIntro() {
        OperationQueue.main.addOperation {
            [weak self] in
            self?.performSegue(withIdentifier: "showIntro", sender: self)
        }
    }
    
    // Resets the streak if the user has not retained their streak
    func checkStreak() {
        if User.sharedUser.streakDates.count > 0 && Date().days(from: User.sharedUser.streakDates[User.sharedUser.streakDates.endIndex-1]) > 1 {
            User.sharedUser.streakDates.removeAll()
            header.updateStreakIcon()
        }
    }
    
    // Presents the AlertController above this controller as a pop-up
    func showAlertController(alertStyle: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let alertCon = storyboard.instantiateViewController(withIdentifier: "AlertController") as! AlertController
        alertCon.alertStyle = alertStyle
        alertCon.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertCon.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(alertCon, animated: true, completion: nil)
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 0.3
        }
    }
    
    // Adds experience points to the user
    func addXpToUser(num: Int) {
        let pastLevel = User.sharedUser.level
        User.sharedUser.addXP(num: num)
        if User.sharedUser.level > pastLevel {
            showAlertController(alertStyle: "level")
        }
        saveData()
    }
    
    // Updates the calendar and history tabs when the user enters those respective tabs
    func tabBarController(_: UITabBarController, didSelect: UIViewController) {
        if self.tabBarController?.selectedIndex == 0 {
            let caleCon = didSelect as! CalendarController
            caleCon.cal.updateCompleteDays()
            caleCon.header.updateStreakIcon()
        } else if self.tabBarController?.selectedIndex == 1 {
            let histCon = didSelect as! HistoryController
            histCon.fillBoxes(mod: histCon.control.selectedSegmentIndex)
            histCon.header.updateStreakIcon()
        } else if self.tabBarController?.selectedIndex == 3 {
            let profCon = didSelect as! ProfileController
            profCon.header.updateStreakIcon()
            profCon.updateUserProgress()
        } else if self.tabBarController?.selectedIndex == 4 {
            let settingsCon = didSelect as! SettingsController
            settingsCon.header.updateStreakIcon()
        } else {
            header.updateStreakIcon()
        }
    }
}

// Extension of CGRect that resizes all views based on screen size
extension CGRect {
    init(x: Int, y: Int, width: Int, height: Int, scale: Bool) {
        let multW = Double(UIScreen.main.bounds.width)/375
        let multH = Double(UIScreen.main.bounds.height)/667
        self.init(x: Double(x)*multW, y: Double(y)*multH, width: Double(width)*multW, height: Double(height)*multH)
    }
    init(x: Double, y: Double, width: Double, height: Double, scale: Bool) {
        let multW = Double(UIScreen.main.bounds.width)/375
        let multH = Double(UIScreen.main.bounds.height)/667
        self.init(x: x*multW, y: y*multH, width: width*multW, height: height*multH)
    }
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, scale: Bool) {
        let multW = Double(UIScreen.main.bounds.width)/375
        let multH = Double(UIScreen.main.bounds.height)/667
        self.init(x: Double(x)*multW, y: Double(y)*multH, width: Double(width)*multW, height: Double(height)*multH)
    }
}

// Extension of CGSizes that resizes based on screen size
extension CGSize {
    init(width: Int, height: Int, scale: Bool) {
        self.init(width: Double(width)*Double(UIScreen.main.bounds.width)/375, height: Double(height)*Double(UIScreen.main.bounds.height)/667)
    }
}

// Scales font based on screen size
extension UIFont {
    convenience init(name: String, size: CGFloat, scale: CGFloat) {
        var i = CGFloat(0)
        if Int(UIScreen.main.bounds.width) == 320 {
            i = scale
        }
        self.init(name: name, size: size-i)!
    }
}
