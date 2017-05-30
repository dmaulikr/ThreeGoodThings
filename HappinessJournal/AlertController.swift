//
//  StreakAlert.swift
//  HappinessJournal
//
//  Created by Asher Dale on 5/1/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit
import UserNotifications
import StoreKit

class AlertController: UIViewController {
    
    let width = 375
    let height = 667
    var container = UIView()
    var alertStyle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the subviews
        self.view.backgroundColor = UIColor.clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        self.view.addGestureRecognizer(tap)
        
        container = UIView(frame: CGRect(x: self.width/2-150, y: self.height/2-150, width: 300, height: 300, scale: true))
        container.backgroundColor = UIColor.white
        container.layer.cornerRadius = 10
        self.view.addSubview(container)
        
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: 0, y: container.frame.height-50, width: container.frame.width, height: 50)
        closeButton.setTitle("OK", for: .normal)
        closeButton.setTitleColor(User.sharedUser.color, for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        closeButton.addTarget(self, action: #selector(self.close(_:)), for:.touchUpInside)
        container.addSubview(closeButton)
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: container.frame.height-50, width: container.frame.width, height: 1.5))
        bottomLine.backgroundColor = Header.bg
        container.addSubview(bottomLine)
        
        if alertStyle == "streak" {
            setUpStreak()
        } else if alertStyle == "past" {
            setUpPast()
        } else if alertStyle == "level" {
            setUpLevel()
        }
    }
    
    // Dismisses the AlertController
    func close(_ sender: UIButton) {
        let tabBarCon = self.presentingViewController as! UITabBarController
        let entryCon = tabBarCon.viewControllers![2] as! EntryController
        self.dismiss(animated: true, completion: nil)
        let pastLevel = User.sharedUser.level
        
        if alertStyle == "streak" {
            entryCon.addXpToUser(num: 10 + User.sharedUser.streakDates.count)
        } else if alertStyle == "past" {
            entryCon.addXpToUser(num: 5)
        } else if User.sharedUser.level == 5 || User.sharedUser.level == 10 || (User.sharedUser.level > 19 && User.sharedUser.level % 10 == 0) {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                let alertController = UIAlertController(title: "Rate Three Good Things!", message: "If you love the app, could you please take a quick second to rate us in the App Store? It would mean a lot :)", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .default ) { action in }
                let okAction = UIAlertAction(title: "Rate", style: .default ) { action in
                    let appID = 1242079576
                    if let url = URL(string: "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)") {
                        UIApplication.shared.open(url)
                    }
                }
                alertController.addAction(cancel)
                alertController.addAction(okAction)
                entryCon.present(alertController, animated: true) {}
            }
        } else {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted && User.sharedUser.level == 2 {
                    let setCon = tabBarCon.viewControllers![4] as! SettingsController
                    DispatchQueue.main.async(execute: {
                        tabBarCon.selectedIndex = 4
                        tabBarCon.selectedIndex = 2
                        setCon.reminderSwitch.setOn(true, animated: false)
                        setCon.switchToggled(setCon.reminderSwitch)
                    })
                }
            }
        }
        
        if User.sharedUser.level == pastLevel {
            UIView.animate(withDuration: 0.3) {
                entryCon.view.alpha = 1
            }
        }
    }
    
    // Sets up streak pop-up screen
    func setUpStreak() {
        container.addSubview(makeLabel(text: "Your streak has grown to a", rect: CGRect(x: 0, y: 0, width: 300, height: 50, scale: true), font: UIFont(name:"HelveticaNeue-Light", size: 20, scale: 3)))
        container.addSubview(makeLabel(text: "\(User.sharedUser.streakDates.count)", rect: CGRect(x: 0, y: 50, width: 300, height: 75, scale: true), font: UIFont(name:"HelveticaNeue-Bold", size: 78, scale: 20)))
        container.addSubview(makeLabel(text: "day streak!", rect: CGRect(x: 0, y: 125, width: 300, height: 50, scale: true), font: UIFont(name:"HelveticaNeue-Light", size: 20, scale: 3)))
        container.addSubview(makeLabel(text: "Met daily goal: +\(10*User.sharedUser.xpMultiplier) XP", rect: CGRect(x: 0, y: 175, width: 300, height: 25, scale: true), font: UIFont(name:"HelveticaNeue-Light", size: 20, scale: 3)))
        container.addSubview(makeLabel(text: "\(User.sharedUser.streakDates.count) day streak: +\(User.sharedUser.streakDates.count*User.sharedUser.xpMultiplier) XP", rect: CGRect(x: 0, y: 205, width: 300, height: 25, scale: true), font: UIFont(name:"HelveticaNeue-Light", size: 20, scale: 3)))
    }
    
    // Sets up the pop-up screen for filling in a past day
    func setUpPast() {
        container.addSubview(makeLabel(text: "You've earned", rect: CGRect(x: 0, y: 0, width: 300, height: 50, scale: true), font: UIFont(name:"HelveticaNeue-Light", size: 20, scale: 3)))
        container.addSubview(makeLabel(text: "+\(5*User.sharedUser.xpMultiplier) XP", rect: CGRect(x: 0, y: 75, width: 300, height: 75, scale: true), font: UIFont(name:"HelveticaNeue-Bold", size: 78, scale: 20)))
        container.addSubview(makeLabel(text: "for filling out a previous day.", rect: CGRect(x: 0, y: 175, width: 300, height: 50, scale: true), font: UIFont(name:"HelveticaNeue-Light", size: 20, scale: 3)))
    }
    
    // Sets up the pop-up screen for leveling up
    func setUpLevel() {
        container.addSubview(makeLabel(text: "By becoming happier and", rect: CGRect(x: 0, y: 40, width: 300, height: 25, scale: true), font: UIFont(name:"HelveticaNeue-Light", size: 20, scale: 3)))
        container.addSubview(makeLabel(text: "more positive, you've grown to", rect: CGRect(x: 0, y: 70, width: 300, height: 25, scale: true), font: UIFont(name:"HelveticaNeue-Light", size: 20, scale: 3)))
        container.addSubview(makeLabel(text: "Level \(User.sharedUser.level)!", rect: CGRect(x: 0, y: 105, width: 300, height: 75, scale: true), font: UIFont(name:"HelveticaNeue-Bold", size: 52, scale: 10)))
    }
    
    // Creates a label based on the pre-determined text, frame, and font to be used
    func makeLabel(text: String, rect: CGRect, font: UIFont) -> UILabel {
        let label = UILabel()
        label.frame = rect
        label.text = text
        label.font = font
        label.textColor = User.sharedUser.color
        label.textAlignment = NSTextAlignment.center
        return label
    }
}
