//
//  CalDay.swift
//  HappinessJournal
//
//  Created by Asher Dale on 2/11/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit

protocol CalDayDelegate {
    func dayPressed(sender: CalDay!)
}

class CalDay: UIButton {
    
    let width = Int(UIScreen.main.bounds.width)
    var month: CalMonth
    var dayText: String
    var delegate: CalDayDelegate!
    
    init(frame: CGRect, parentMonth: CalMonth, day: String) {
        month = parentMonth
        delegate = month.parent
        dayText = day
        super.init(frame: frame)
        self.setTitle(dayText, for: .normal)
        self.titleLabel?.font = UIFont(name:"HelveticaNeue-Thin", size: 17)!
        self.titleLabel?.textAlignment = NSTextAlignment.center
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.addTarget(self, action: #selector(self.dayTouched(_:)), for: .touchUpInside)
        self.showsTouchWhenHighlighted = true
    }
    
    // Called when a calDay is touched (in CalendarController)
    func dayTouched(_ sender: CalDay) {
        delegate.dayPressed(sender: sender)
    }
    
    // Determines if a calDay is enabled and filled-in
    override func setTitle(_ title: String?, for state: UIControlState) {
        self.setTitleColor(UIColor.lightGray, for: .normal)
        self.backgroundColor = UIColor.white
        isEnabled = false
        if dayText != "" {
            let date = Calendar.current.date(bySetting: .day, value: Int(dayText)!, of: month.parent.pageDate)!
            if date < Date() && User.sharedUser.startDate.days(from: date) < 3 {
                isEnabled = true
                self.setTitleColor(UIColor.black, for: .normal)
                let dayStr = createDayString(fromDate: date)
                if User.sharedUser.days[dayStr]?.isComplete != nil && User.sharedUser.days[dayStr]!.isComplete {
                    self.backgroundColor = Header.appColor
                }
            }
        }
        super.setTitle(title, for: state)
    }
    
    // Create a string from the specified date in the format of "mm/dd/yyyy"
    func createDayString(fromDate: Date) -> String {
        return "\(Calendar.current.component(.month, from: fromDate))/\(Calendar.current.component(.day, from: fromDate))/\(Calendar.current.component(.year, from: fromDate))"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
