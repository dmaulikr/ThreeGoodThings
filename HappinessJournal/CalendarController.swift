//
//  CalendarController.swift
//  HappinessJournal
//
//  Created by Asher Dale on 12/12/16.
//  Copyright © 2016 Asher Dale. All rights reserved.
//

import UIKit

class CalendarController: UIViewController, CalDayDelegate, UIScrollViewDelegate {
    
    let width = 375
    var header: Header!
    var pageDate = Date()
    let dateFormatter = DateFormatter()
    var monthLabel = UILabel()
    var backwardButton = UIButton()
    var backwardDisabled = true
    var monthCounter = 0
    var cal: CalMonth!
    var calX: CGFloat!
    
    var scrollView: UIScrollView!
    var containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the header, background, and other views
        self.view.backgroundColor = User.sharedUser.color
        header = Header(title: "Calendar")
        self.view.addSubview(header)
        let headerBottomBorder = UIView(frame: CGRect(x: 0.0, y: 63.5, width: Double(width), height: 0.5, scale: true))
        headerBottomBorder.backgroundColor = UIColor.lightGray
        self.view.addSubview(headerBottomBorder)
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: 375, height: 555, scale: true)
        containerView = UIView()
        scrollView.addSubview(containerView)
        self.view.addSubview(scrollView)
                
        if Calendar.current.component(.day, from: pageDate) != 1 {
            pageDate = Calendar.current.date(byAdding: .month, value: -1, to: pageDate)!
            pageDate = Calendar.current.date(bySetting: .day, value: 1, of: pageDate)!
        }
        cal = CalMonth(parentController: self)
        calX = cal.frame.origin.x
        containerView.addSubview(cal)
        createMonthElements()
    }
    
    // Readjusts the UIScrollView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: 64, width: 375, height: 554, scale: true)
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }

    // Creates the labels and buttons that accompany the calendar
    func createMonthElements() {
        dateFormatter.dateFormat = "MMMM yyyy"
        monthLabel = makeLabel(text: dateFormatter.string(from: pageDate), rect: CGRect(x: width/2 - 90, y: 20, width: 180, height: 52, scale: true), font: UIFont(name:"HelveticaNeue-Medium", size: 23, scale: 3.5))
        containerView.addSubview(monthLabel)
        
        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        for i in 0...6 {
            let dayLabel = makeLabel(text: days[i], rect: CGRect(x: 15 + i*cal.frameWidth/7, y: 120-cal.frameWidth/7, width: cal.frameWidth/7, height: cal.frameWidth/7, scale: true), font: UIFont(name:"HelveticaNeue-Light", size: 17)!)
            containerView.addSubview(dayLabel)
        }
        
        let _ = makeButton(fileName: "Forward.png", buttonX: width/2+90, selector: #selector(self.monthForward(sender:)), showTouch: true)
        backwardButton = makeButton(fileName: "Backward.png", buttonX: width/2-120, selector: #selector(self.monthBackward(sender:)), showTouch: true)
        backwardButton.tintColor = User.sharedUser.color
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
        button.frame = CGRect(x: buttonX, y: 31, width: 30, height: 30, scale: true)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.showsTouchWhenHighlighted = showTouch
        containerView.addSubview(button)
        return button
    }
    
    // Called when the user presses the forward month arrow
    func monthForward(sender: UIButton!) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.cal.frame.origin.x -= UIScreen.main.bounds.width
             },
                       completion: {
                        (value: Bool) in
                        self.monthChange(val: 1)
                        self.cal.frame.origin.x = UIScreen.main.bounds.width
                        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                            self.cal.frame.origin.x = self.calX
                        },
                                       completion: {
                                        (value: Bool) in
                                        self.cal.frame.origin.x = self.calX
                        })
        })
        
    }
    
    // Called when the user presses the backward month arrow
    func monthBackward(sender: UIButton!) {
        if !backwardDisabled {
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.cal.frame.origin.x += UIScreen.main.bounds.width
            },
                           completion: {
                            (value: Bool) in
                            self.monthChange(val: -1)
                            self.cal.frame.origin.x = -UIScreen.main.bounds.width
                            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                                self.cal.frame.origin.x = self.calX
                            },
                                           completion: {
                                            (value: Bool) in
                                            self.cal.frame.origin.x = self.calX
                            })
            })
        }
    }
    
    // Updates the calendar when the month is changed
    func monthChange(val: Int) {
        pageDate = NSCalendar.current.date(byAdding: .month, value: val, to: pageDate)!
        monthLabel.text = dateFormatter.string(from: pageDate)
        cal.fillMonth(param: "monthChange")
        monthCounter += val
        if monthCounter <= 0 {
            backwardDisabled = true
            backwardButton.tintColor = User.sharedUser.color
        } else {
            backwardDisabled = false
            backwardButton.tintColor = UIColor.white
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
