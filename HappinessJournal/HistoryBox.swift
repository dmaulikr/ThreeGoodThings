//
//  HistoryBox.swift
//  HappinessJournal
//
//  Created by Asher Dale on 2/13/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit

class HistoryBox: UIView {
    
    let width = 375
    var dateLabel = UILabel()
    var entryLabel = UILabel()
    var date = Date()
    
    // Initializes the object
    init(dayStr: String, boxText: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        dateLabel = makeLabel(label: dateLabel, rect: CGRect(x: 10, y: 0, width: 150, height: 30, scale: true), font: UIFont(name:"HelveticaNeue-Light", size: 13)!, color: UIColor.black)
        entryLabel = makeLabel(label: entryLabel, rect: CGRect(x: 10, y: 15, width: 325, height: 115, scale: true), font: UIFont(name:"HelveticaNeue-Medium", size: 18.8, scale: 2.8), color: User.sharedUser.color)
        showEntry(dayStr: dayStr, entry: boxText)
    }
    
    // Displays the entry and its corresponding date
    func showEntry(dayStr: String, entry: String) {
        entryLabel.text = entry
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        date = dateFormatter.date(from: dayStr)!
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    // Creates a label based on the pre-determined frame, font, and color to be used
    func makeLabel(label: UILabel, rect: CGRect, font: UIFont, color: UIColor) -> UILabel {
        label.frame = rect
        label.font = font
        label.textColor = color
        label.numberOfLines = 0
        self.addSubview(label)
        return label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
