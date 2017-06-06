//
//  SettingsController.swift
//  HappinessJournal
//
//  Created by Asher Dale on 12/12/16.
//  Copyright © 2016 Asher Dale. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsController: UIViewController, UIScrollViewDelegate {
    
    let width = 375
    let height = 667
    let settingHeight = 49
    let breakHeight = 30
    
    var header: Header!
    var scrollView: UIScrollView!
    var containerView = UIView()
    var bottomView = UIView()
    
    var reminderTimeLabel = UIButton()
    var reminderSwitch: UISwitch!
    var timeButton: UIButton!
    var timePickerView = UIView()
    var dateFormatter = DateFormatter()
    var timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the subviews, header, and background
        self.view.backgroundColor = Header.bg
        header = Header(title: "Settings")
        self.view.addSubview(header)
        let headerBottomBorder = UIView(frame: CGRect(x: 0.0, y: 63.5, width: Double(width), height: 0.5, scale: true))
        headerBottomBorder.backgroundColor = UIColor.lightGray
        self.view.addSubview(headerBottomBorder)
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.width, height: self.height-64-49+1, scale: true)
        containerView = UIView()
        scrollView.addSubview(containerView)
        self.view.addSubview(scrollView)
        
        reminderTimeLabel = createSetting(yVal: breakHeight + settingHeight, text: "Reminder time")
        reminderTimeLabel.addTarget(self, action: #selector(self.toggleTimePicker(_:)), for: .touchUpInside)
        containerView.addSubview(reminderTimeLabel)
        let dailyReminder = createSetting(yVal: breakHeight, text: "Daily reminder")
        containerView.addSubview(dailyReminder)
        
        bottomView.frame = CGRect(x: 0, y: settingHeight*2 + breakHeight*2, width: self.width, height: 1000, scale: true)
        containerView.addSubview(bottomView)
        
        bottomView.addSubview(createSetting(yVal: 0, text: "About", selector: #selector(self.showAboutController(_:))))
        bottomView.addSubview(createSetting(yVal: settingHeight, text: "Send feedback or suggestions", selector: #selector(self.sendEmail(_:))))
        bottomView.addSubview(createSetting(yVal: settingHeight*2, text: "Contact the developer", selector: #selector(self.sendEmail(_:))))
        bottomView.addSubview(createSetting(yVal: settingHeight*3 + breakHeight, text: "Love the app? Rate us in the App Store", selector: #selector(self.rateApp(_:))))
        bottomView.addSubview(createSetting(yVal: settingHeight*4 + breakHeight, text: "Three Good Things on Facebook", selector: #selector(self.toFacebook(_:))))
        bottomView.addSubview(createSetting(yVal: settingHeight*5 + breakHeight, text: "Three Good Things on Twitter", selector: #selector(self.toTwitter(_:))))
        
        //bottomView.addSubview(createSetting(yVal: settingHeight*5 + breakHeight, text: "Store", selector: #selector(self.showStoreController(_:))))
        
        reminderSwitch = UISwitch(frame: CGRect(x: self.width-65, y: (50-31)/2, width: 0, height: 0, scale: true))
        reminderSwitch.setOn(User.sharedUser.hasReminder, animated: false)
        reminderSwitch.tintColor = Header.bg
        reminderSwitch.onTintColor = User.sharedUser.color
        reminderSwitch.addTarget(self, action: #selector(self.switchToggled(_:)), for: .touchUpInside)
        dailyReminder.addSubview(reminderSwitch)
        
        if !reminderSwitch.isOn {
            self.bottomView.frame.origin.y -= reminderTimeLabel.frame.height
            self.reminderTimeLabel.alpha = 0
        }
        
        timeButton = UIButton(frame: CGRect(x: self.width-100, y: 0, width: 100, height: 50, scale: true))
        timeButton.setTitleColor(UIColor.gray, for: .normal)
        timeButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Light", size: 20, scale: 3)
        timeButton.addTarget(self, action: #selector(self.toggleTimePicker(_:)), for: .touchUpInside)
        reminderTimeLabel.addSubview(timeButton)
        
        timePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        timePicker.frame.origin.x = (UIScreen.main.bounds.width-timePicker.frame.width)/2
        timePickerView = UIView(frame: CGRect(x: 0, y: settingHeight*2+breakHeight+1, width: 0, height: 0, scale: true))
        timePickerView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: timePicker.frame.height)
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(self.valueChanged(_:)), for: .valueChanged)
        dateFormatter.dateFormat = "h:mm a"
        
        var components = DateComponents()
        let prevTime = User.sharedUser.reminderTime
        if prevTime == "" {
            timeButton.setTitle("9:00 PM", for: .normal)
            components.hour = 21
            components.minute = 0
        } else {
            timeButton.setTitle(User.sharedUser.reminderTime, for: .normal)
            var i = 2
            if prevTime.characters.count == 7 {
                i = 1
            }
            var hourNum = Int(String(prevTime.characters.prefix(i)))!
            if prevTime.hasSuffix("PM") {
                hourNum += 12
            }
            components.hour = hourNum
            components.minute = Int(String(prevTime.characters.dropFirst(i+1).dropLast(3)))
        }
        let timePickerDate = Calendar.current.date(from: components)
        timePicker.setDate(timePickerDate!, animated: false)
        
        timePickerView.backgroundColor = UIColor.white
        timePickerView.addSubview(timePicker)
        containerView.addSubview(timePickerView)
        timePickerView.isHidden = true
        timePickerView.alpha = 0
    }
    
    // Readjusts the UIScrollView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: 64, width: self.width, height: self.height-64-49, scale: true)
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    // Creates a setting button
    func createSetting(yVal: Int, text: String, selector: Selector? = nil) -> UIButton {
        let settingButton = UIButton(frame: CGRect(x: 0, y: yVal, width: self.width, height: 50, scale: true))
        settingButton.backgroundColor = UIColor.white
        settingButton.contentHorizontalAlignment = .left
        settingButton.setTitle("   " + text, for: .normal)
        settingButton.setTitleColor(UIColor.black, for: .normal)
        settingButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Light", size: 18, scale: 3)
        settingButton.layer.borderWidth = 1
        settingButton.layer.borderColor = UIColor.lightGray.cgColor
        settingButton.addTarget(self, action: #selector(self.touchDown(_:)), for: .touchDown)
        containerView.addSubview(settingButton)
        
        if selector != nil {
            settingButton.addTarget(self, action: selector!, for: .touchUpInside)
            settingButton.addSubview(makeArrow(selector: selector!))
        }
        
        return settingButton
    }
    
    // Creates an arrow icon on the far right of a settingButton
    func makeArrow(selector: Selector) -> UIButton {
        let image = UIImage(named: "SlimForward.png")?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: self.width-50, y: 15, width: 20, height: 20, scale: true)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.lightGray
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    // Called when the "Daily Reminder" switch is toggled
    func switchToggled(_ sender: UISwitch) {
        var y = 1
        if !reminderSwitch.isOn {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            y = -1
            if !timePickerView.isHidden {
                UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                    self.bottomView.frame.origin.y -= self.timePickerView.frame.height
                    self.scrollView.contentSize.height -= self.timePickerView.frame.height
                    self.timePickerView.alpha = 0 },
                               completion: {
                                (value: Bool) in
                                self.timePickerView.isHidden = true
                })
            }
        } else {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted {
                    self.setUpNotification()
                } else {
                    
                    
                    let alertController = UIAlertController(title: "Press \"OK\" to turn on notifications for this app", message: "", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .default ) { action in
                        self.reminderSwitch.setOn(false, animated: false)
                        self.switchToggled(self.reminderSwitch)
                    }
                    let okAction = UIAlertAction(title: "OK", style: .default ) { action in
                        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                        self.reminderSwitch.setOn(false, animated: false)
                        self.switchToggled(self.reminderSwitch)
                    }
                    alertController.addAction(cancel)
                    alertController.addAction(okAction)

                    
                    self.present(alertController, animated: true) {}
                }
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.bottomView.frame.origin.y += CGFloat(y)*self.reminderTimeLabel.frame.height
            self.reminderTimeLabel.alpha = CGFloat(y)
        }
        User.sharedUser.hasReminder = reminderSwitch.isOn
    }
    
    // Shows a UIDatePicker when the "Reminder Time" setting is pressed
    func toggleTimePicker(_ sender: UIButton) {
        if timePickerView.isHidden {
            timePickerView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.bottomView.frame.origin.y += self.timePickerView.frame.height
                self.scrollView.contentSize.height += self.timePickerView.frame.height
                self.timePickerView.alpha = 1
            }
        } else if self.bottomView.frame.origin.y > CGFloat(settingHeight*2 + breakHeight*2) {
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.bottomView.frame.origin.y -= self.timePickerView.frame.height
                self.scrollView.contentSize.height -= self.timePickerView.frame.height
                self.timePickerView.alpha = 0 },
                        completion: {
                            (value: Bool) in
                            self.timePickerView.isHidden = true
            })
        }
    }
    
    // Called when the UIDatePicker's time is changed
    func valueChanged(_ sender: UIDatePicker) {
        let dateStr = dateFormatter.string(from: sender.date)
        timeButton.setTitle(dateStr, for: .normal)
        User.sharedUser.reminderTime = dateStr
        setUpNotification()
    }
    
    // Opens an email to the developer
    func sendEmail(_ sender: UIButton) {
        if let emailURL: NSURL = NSURL(string: "mailto:threegoodthingscontact@gmail.com") {
            if UIApplication.shared.canOpenURL(emailURL as URL) {
                UIApplication.shared.open(emailURL as URL)
            }
        }
    }
    
    // Sends the user to the facebook page
    func toFacebook(_ sender: UIButton) {
        if UIApplication.shared.canOpenURL(URL(string: "fb://page/?id=1793191400995847")!){
            UIApplication.shared.open(URL(string: "fb://page/?id=1793191400995847")!)
        } else if let url = URL(string: "https://www.facebook.com/Three-Good-Things-A-Happiness-Journal-for-iOS-1793191400995847/?view_public_for=1793191400995847") {
            UIApplication.shared.open(url)
        }
    }
    
    // Sends the user to the twitter account
    func toTwitter(_ sender: UIButton) {
        let screenName =  "_3_good_things"
        let appURL = URL(string: "twitter://user?screen_name=\(screenName)")!
        
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else {
            UIApplication.shared.open(URL(string: "https://twitter.com/\(screenName)")!)
        }
    }
    
    // Sends the user to the app's page on the app store
    func rateApp(_ sender: UIButton) {
        let appID = 1242079576
        if let url = URL(string: "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)") {
            UIApplication.shared.open(url)
        }
    }
    
    // Presents the StoreController
    func showStoreController(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let storeCon = storyboard.instantiateViewController(withIdentifier: "StoreController") as! StoreController
        storeCon.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        storeCon.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(storeCon, animated: true, completion: nil)
    }
    
    // Presents the AboutController
    func showAboutController(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let aboutCon = storyboard.instantiateViewController(withIdentifier: "AboutController") as! AboutController
        aboutCon.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        aboutCon.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(aboutCon, animated: true, completion: nil)
    }
    
    // Creates a daily notification for the user based on the UIDatePicker's time
    func setUpNotification() {
        let content = UNMutableNotificationContent()
        content.body = NSString.localizedUserNotificationString(forKey: "What are three things that went well today?", arguments: nil)
        content.sound = UNNotificationSound.default()
        
        let dateInfo = Calendar.current.dateComponents([.hour, .minute], from: timePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: "Main", content: content, trigger: trigger)
        
        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                    print(theError.localizedDescription)
                }
            }
    }
    
    // Turns the background of the button to gray briefly when tapped
    func touchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            sender.backgroundColor = Header.bg },
                       completion: {
                        (value: Bool) in
                        UIView.animate(withDuration: 0.2) {
                            sender.backgroundColor = UIColor.white
                        }
        })
    }
}
