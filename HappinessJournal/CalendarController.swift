//
//  CalendarController.swift
//  HappinessJournal
//
//  Created by Asher Dale on 12/12/16.
//  Copyright © 2016 Asher Dale. All rights reserved.
//

import UIKit

class CalendarController: UIViewController, CalDayDelegate {
    
    let width = Int(UIScreen.main.bounds.width)
    var header: Header!
    var pageDate = Date()
    let dateFormatter = DateFormatter()
    var monthLabel = UILabel()
    var forwardButton = UIButton()
    var forwardDisabled = true
    var monthCounter = 0
    var cal: CalMonth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the header, background, and other views
        self.view.backgroundColor = Header.appColor
        header = Header(title: "Calendar")
        self.view.addSubview(header)
        let headerBottomBorder = UIView(frame: CGRect(x: 0.0, y: 63.5, width: Double(width), height: 0.5))
        headerBottomBorder.backgroundColor = UIColor.lightGray
        self.view.addSubview(headerBottomBorder)
                
        if Calendar.current.component(.day, from: pageDate) != 1 {
            pageDate = Calendar.current.date(byAdding: .month, value: -1, to: pageDate)!
            pageDate = Calendar.current.date(bySetting: .day, value: 1, of: pageDate)!
        }
        cal = CalMonth(parentController: self)
        self.view.addSubview(cal)
        createMonthElements()
    }

    // Creates the labels and buttons that accompany the calendar
    func createMonthElements() {
        dateFormatter.dateFormat = "MMMM yyyy"
        monthLabel = makeLabel(text: dateFormatter.string(from: pageDate), rect: CGRect(x: width/2 - 90, y: 64, width: 180, height: 52), font: UIFont(name:"HelveticaNeue-Bold", size: 23)!)
        self.view.addSubview(monthLabel)
        
        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        for i in 0...6 {
            let dayLabel = makeLabel(text: days[i], rect: CGRect(x: 15 + i*Int(cal.frame.width)/7, y: Int(cal.frame.minY)-Int(cal.frame.width)/7, width: Int(cal.frame.width)/7, height: Int(cal.frame.width)/7), font: UIFont(name:"HelveticaNeue-Thin", size: 17)!)
            self.view.addSubview(dayLabel)
        }
        
        let _ = makeButton(fileName: "Backward.png", buttonX: width/2-120, selector: #selector(self.monthBackward(sender:)), showTouch: true)
        forwardButton = makeButton(fileName: "Forward.png", buttonX: width/2+90, selector: #selector(self.monthForward(sender:)), showTouch: false)
        forwardButton.tintColor = Header.appColor
    }
    
    // Creates a label based on the pre-determined text, frame, and font to be used
    func makeLabel(text: String, rect: CGRect, font: UIFont) -> UILabel {
        let label = UILabel()
        label.frame = rect
        label.text = text
        label.font = font
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    // Loads and places a button icon on a specified part of the screen
    func makeButton(fileName: String, buttonX: Int, selector: Selector, showTouch: Bool) -> UIButton {
        let image = UIImage(named: fileName)?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: buttonX, y: 75, width: 30, height: 30)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.showsTouchWhenHighlighted = showTouch
        self.view.addSubview(button)
        return button
    }
    
    // Called when the user presses the forward month arrow
    func monthForward(sender: UIButton!) {
        if !forwardDisabled {
            monthChange(val: 1)
        }
    }
    
    // Called when the user presses the backward month arrow
    func monthBackward(sender: UIButton!) {
        monthChange(val: -1)
    }
    
    // Updates the calendar when the month is changed
    func monthChange(val: Int) {
        pageDate = NSCalendar.current.date(byAdding: .month, value: val, to: pageDate)!
        monthLabel.text = dateFormatter.string(from: pageDate)
        cal.fillMonth(param: "monthChange")
        monthCounter += val
        if monthCounter >= 0 {
            forwardDisabled = true
            forwardButton.tintColor = Header.appColor
            forwardButton.showsTouchWhenHighlighted = false
        } else {
            forwardDisabled = false
            forwardButton.tintColor = UIColor.white
            forwardButton.showsTouchWhenHighlighted = true
        }
    }
    
    // Sends the user to the EntryController when a day is pressed
    func dayPressed(sender: CalDay!) {
        let entryCon = self.tabBarController?.customizableViewControllers?[2] as! EntryController
        entryCon.pageDate = Calendar.current.date(bySetting: .day, value: Int(sender.dayText)!, of: pageDate)!
        entryCon.dateChanged(mod: "")
        self.tabBarController?.selectedIndex = 2
    }
}
