//
//  CalMonth.swift
//  HappinessJournal
//
//  Created by Asher Dale on 2/11/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit

class CalMonth: UIView {
    
    let frameWidth = Int(UIScreen.main.bounds.width) - 30
    let parent: CalendarController
    var calDays = Array<CalDay>()
    
    init(parentController: CalendarController) {
        parent = parentController
        super.init(frame: CGRect(x: 15, y: 170, width: frameWidth, height: 6*frameWidth/7))
        self.backgroundColor = UIColor.white
        fillMonth(param: "init")
    }
    
    // Creates the calendar box based on the month
    func fillMonth(param: String) {
        let numDays = Calendar.current.range(of: .day, in: .month, for: parent.pageDate)!.count
        let dayOffset = Calendar.current.component(.weekday, from: parent.pageDate)-1
        let dayWidth = frameWidth/7
        for i in 0...36 {
            var dayText = "\(i+1-dayOffset)"
            if i < dayOffset || (i+1-dayOffset) > numDays {
                dayText = ""
            }
            if param == "init" {
                calDays.append(CalDay(frame: CGRect(x: (i%7)*dayWidth, y: (i/7)*dayWidth, width: dayWidth, height: dayWidth), parentMonth: self, day: dayText))
                self.addSubview(calDays[i])
            } else {
                calDays[i].dayText = dayText
                calDays[i].setTitle(dayText, for: .normal)
            }
        }
    }
    
    // Updates the calendar by checking if each calDay should be filled-in
    func updateCompleteDays() {
        for calDay in calDays {
            if calDay.dayText != "" {
                let date = Calendar.current.date(bySetting: .day, value: Int(calDay.dayText)!, of: parent.pageDate)!
                let dayStr = calDay.createDayString(fromDate: date)
                if User.sharedUser.days[dayStr]?.isComplete != nil && User.sharedUser.days[dayStr]!.isComplete {
                    calDay.backgroundColor = Header.appColor
                } else {
                    calDay.backgroundColor = UIColor.white
                }
            } else {
                calDay.backgroundColor = UIColor.white
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
