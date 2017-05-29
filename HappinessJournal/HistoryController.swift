//
//  HistoryController.swift
//  HappinessJournal
//
//  Created by Asher Dale on 12/12/16.
//  Copyright © 2016 Asher Dale. All rights reserved.
//

import UIKit

class HistoryController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var containerView = UIView()
    var header: Header!
    let width = 375
    let height = 667
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    var control = UISegmentedControl()
    let noEntriesLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the header, background, and other views
        self.view.backgroundColor = Header.bg
        header = Header(title: "History")
        self.view.addSubview(header)
        let headerBottomBorder = UIView(frame: CGRect(x: 0.0, y: 63.5, width: Double(width), height: 0.5, scale: true))
        headerBottomBorder.backgroundColor = UIColor.lightGray
        self.view.addSubview(headerBottomBorder)
                
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.width, height: self.height-164, scale: true)
        containerView = UIView()
        self.view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        noEntriesLabel.frame = CGRect(x: width/2 - 100, y: 64, width: 200, height: 52, scale: true)
        noEntriesLabel.text = "No Entries"
        noEntriesLabel.textColor = UIColor.gray
        noEntriesLabel.textAlignment = NSTextAlignment.center
        noEntriesLabel.font = UIFont(name:"HelveticaNeue-Medium", size: 26)!
        containerView.addSubview(noEntriesLabel)

        showFilterButtons()
    }
    
    // Readjusts the UIScrollView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: 116, width: self.width, height: self.height-64-52-49, scale: true)
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    // Creates the UISegmentedControl buttons at the top of the view
    func showFilterButtons() {
        control = UISegmentedControl(frame: CGRect(x: 15, y: 74, width: width-30, height: 30, scale: true))
        control.tintColor = User.sharedUser.color
        control.insertSegment(withTitle: "Past Week", at: 0, animated: false)
        control.insertSegment(withTitle: "Past Month", at: 1, animated: false)
        control.insertSegment(withTitle: "Past Year", at: 2, animated: false)
        control.insertSegment(withTitle: "All Time", at: 3, animated: false)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(self.controlChanged(_:)), for: .valueChanged)
        self.view.addSubview(control)
        fillBoxes(mod: 0)
    }
    
    // Updates the HistoryBoxes when the user chooses a new filter button
    func controlChanged(_ sender: UISegmentedControl!) {
        fillBoxes(mod: sender.selectedSegmentIndex)
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    // Creates the HistoryBoxes based on the selected filter in the UISegmentedControl
    func fillBoxes(mod: Int) {
        for subview in containerView.subviews {
            subview.removeFromSuperview()
        }
        var boxes = Array<HistoryBox>()
        for key in User.sharedUser.days.keys {
            for entry in User.sharedUser.days[key]!.entries {
                if entry != "" && entry != "Press here to begin typing..." {
                    let entryDate = dateFormatter.date(from: key)
                    if (mod == 0 && currentDate.weeks(from: entryDate!) == 0) || (mod == 1 && currentDate.months(from: entryDate!) == 0) || (mod == 2 && currentDate.years(from: entryDate!) == 0) || (mod == 3) {
                        boxes.append(HistoryBox(dayStr: key, boxText: entry))
                    }
                }
            }
        }
        if boxes.count == 0 {
            containerView.addSubview(noEntriesLabel)
            return
        }
        var i = 0
        for box in sortDates(fromBoxArr: boxes) {
            box.frame = CGRect(x: 15, y: i*140, width: width-30, height: 130, scale: true)
            containerView.addSubview(box)
            i += 1
            
            let textSize = CGSize(width: box.entryLabel.frame.size.width, height: CGFloat(Float.infinity))
            let lineCount = lroundf(Float(box.entryLabel.sizeThatFits(textSize).height))/lroundf(Float(box.entryLabel.font.lineHeight))
            if lineCount < 3 {
                box.entryLabel.font = UIFont(name:"HelveticaNeue-Medium", size: CGFloat(37-lineCount*6), scale: 3)
            }
        }
        scrollView.contentSize = CGSize(width: self.width, height: i*140+10, scale: true)
    }
    
    // Sorts the HistoryBoxes so they appear from newest to oldest
    func sortDates(fromBoxArr: Array<HistoryBox>) -> Array<HistoryBox> {
        var newArr = Array<HistoryBox>()
        newArr.append(fromBoxArr[0])
        for i in 1..<fromBoxArr.count {
            for sortedBox in newArr {
                if fromBoxArr[i].date > sortedBox.date {
                    newArr.insert(fromBoxArr[i], at: newArr.index(of: sortedBox)!)
                    break
                }
                if sortedBox == newArr.last {
                    newArr.append(fromBoxArr[i])
                }
            }
        }
        return newArr
    }
}

extension Date {
    // Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    // Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    // Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    
    // Returns the amount of days from another date
    func days(from date: Date) -> Int {
        let date1 = Calendar.current.startOfDay(for: self)
        let date2 = Calendar.current.startOfDay(for: date)
        return Calendar.current.dateComponents([.day], from: date2, to: date1).day ?? 0
    }
}
