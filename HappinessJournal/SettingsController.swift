//
//  SettingsController.swift
//  HappinessJournal
//
//  Created by Asher Dale on 12/12/16.
//  Copyright © 2016 Asher Dale. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UIScrollViewDelegate {
    
    let width = Int(UIScreen.main.bounds.width)
    let height = Int(UIScreen.main.bounds.height)
    let settingHeight = 49
    let breakHeight = 36
    
    var header: Header!
    var scrollView: UIScrollView!
    var containerView = UIView()
    var bottomView = UIView()
    
    var reminderTimeLabel = UIButton()
    var reminderSwitch: UISwitch!
    var timeButton: UIButton!
    var timePickerView = UIView()
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Header.appColor
        header = Header(title: "Settings")
        self.view.addSubview(header)
        let headerBottomBorder = UIView(frame: CGRect(x: 0.0, y: 63.5, width: Double(width), height: 0.5))
        headerBottomBorder.backgroundColor = UIColor.lightGray
        self.view.addSubview(headerBottomBorder)
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.width, height: self.height-64-49+1)
        containerView = UIView()
        scrollView.addSubview(containerView)
        self.view.addSubview(scrollView)
        
        reminderTimeLabel = createSetting(yVal: breakHeight + settingHeight, text: "Reminder time", hasArrow: false)
        reminderTimeLabel.addTarget(self, action: #selector(self.toggleTimePicker(_:)), for: .touchUpInside)
        containerView.addSubview(reminderTimeLabel)
        containerView.addSubview(createSetting(yVal: breakHeight, text: "Daily reminder", hasArrow: false))
        
        bottomView.frame = CGRect(x: 0, y: settingHeight*2 + breakHeight*2, width: self.width, height: 1000)
        containerView.addSubview(bottomView)
        
        bottomView.addSubview(createSetting(yVal: 0, text: "About", hasArrow: true))
        bottomView.addSubview(createSetting(yVal: settingHeight, text: "Instructions", hasArrow: true))
        bottomView.addSubview(createSetting(yVal: settingHeight*2, text: "Send feedback or suggestions", hasArrow: true))
        bottomView.addSubview(createSetting(yVal: settingHeight*3, text: "Contact the developer", hasArrow: true))
        bottomView.addSubview(createSetting(yVal: settingHeight*4, text: "Three Good Things on Facebook", hasArrow: true))
        bottomView.addSubview(createSetting(yVal: settingHeight*5 + breakHeight, text: "Store", hasArrow: true))
        
        reminderSwitch = UISwitch(frame: CGRect(x: self.width-65, y: breakHeight+(50-30)/2, width: 0, height: 0))
        reminderSwitch.setOn(User.sharedUser.hasReminder, animated: false)
        reminderSwitch.tintColor = Header.bg
        reminderSwitch.onTintColor = Header.appColor
        reminderSwitch.addTarget(self, action: #selector(self.switchToggled(_:)), for: .touchUpInside)
        containerView.addSubview(reminderSwitch)
        
        if !reminderSwitch.isOn {
            self.bottomView.frame.origin.y -= CGFloat(50)
            self.reminderTimeLabel.alpha = 0
        }
        
        timeButton = UIButton(frame: CGRect(x: self.width-100, y: 0, width: 100, height: 50))
        timeButton.setTitleColor(UIColor.gray, for: .normal)
        timeButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Thin", size: 20)!
        timeButton.addTarget(self, action: #selector(self.toggleTimePicker(_:)), for: .touchUpInside)
        reminderTimeLabel.addSubview(timeButton)
        
        let timePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        timePicker.frame.origin.x = (CGFloat(self.width)-timePicker.frame.width)/2
        timePickerView = UIView(frame: CGRect(x: 0, y: settingHeight*2+breakHeight+1, width: width, height: Int(timePicker.frame.height)))
        timePicker.datePickerMode = .time
        timePicker.minuteInterval = 5
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
        scrollView.frame = CGRect(x: 0, y: 64, width: self.width, height: self.height-64-49)
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    func createSetting(yVal: Int, text: String, hasArrow: Bool) -> UIButton {
        let settingButton = UIButton(frame: CGRect(x: 0, y: yVal, width: self.width, height: 50))
        settingButton.backgroundColor = UIColor.white
        settingButton.contentHorizontalAlignment = .left
        settingButton.setTitle("    " + text, for: .normal)
        settingButton.setTitleColor(UIColor.black, for: .normal)
        settingButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Thin", size: 20)!
        settingButton.layer.borderWidth = 1
        settingButton.layer.borderColor = UIColor.lightGray.cgColor
        containerView.addSubview(settingButton)
        
        if hasArrow {
            settingButton.addSubview(makeArrow())
        }
        
        return settingButton
    }
    
    // Creates an arrow icon on the far right of a settingButton
    func makeArrow() -> UIButton {
        let image = UIImage(named: "SlimForward.png")?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: self.width-50, y: 15, width: 20, height: 20)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.lightGray
        return button
    }
    
    func switchToggled(_ sender: UIButton) {
        var y = 1
        if !reminderSwitch.isOn {
            y = -1
            if !timePickerView.isHidden {
                UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                    self.bottomView.frame.origin.y -= self.timePickerView.frame.height
                    self.timePickerView.alpha = 0 },
                               completion: {
                                (value: Bool) in
                                self.timePickerView.isHidden = true
                })
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.bottomView.frame.origin.y += CGFloat(50*y)
            self.reminderTimeLabel.alpha = CGFloat(y)
        }
        User.sharedUser.hasReminder = reminderSwitch.isOn
    }
    
    func toggleTimePicker(_ sender: UIButton) {
        if timePickerView.isHidden {
            timePickerView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.bottomView.frame.origin.y += self.timePickerView.frame.height
                self.timePickerView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.bottomView.frame.origin.y -= self.timePickerView.frame.height
                self.timePickerView.alpha = 0 },
                        completion: {
                            (value: Bool) in
                            self.timePickerView.isHidden = true
            })
        }
    }
    
    func valueChanged(_ sender: UIDatePicker) {
        let dateStr = dateFormatter.string(from: sender.date)
        timeButton.setTitle(dateStr, for: .normal)
        User.sharedUser.reminderTime = dateStr
    }
}
