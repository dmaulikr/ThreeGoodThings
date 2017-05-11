//
//  EntryHeader.swift
//  HappinessJournal
//
//  Created by Asher Dale on 1/7/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit

protocol EntryHeaderDelegate {
    func dateChanged(mod: String)
}

class EntryHeader: Header {

    var delegate: EntryHeaderDelegate!
    var dateLabel = UILabel()
    var forwardButton = UIButton()
    var backwardButton = UIButton()
    let todayButton = UIButton()
    
    init() {
        super.init(title: "Entry")
        showHeaderButtons()
    }
    
    // Determines the date to be shown in the middle of the header
    override func showTitle(fromDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        self.title = dateFormatter.string(from: fromDate)
        
        let pos = title.characters.distance(from: title.startIndex, to: title.characters.index(of: ",")!)
        let singlesDigit = title[title.index(title.startIndex, offsetBy: (pos-1))]
        let tensDigit = title[title.index(title.startIndex, offsetBy: (pos-2))]
        let dayNum = "\(tensDigit)\(singlesDigit)"
        var suffix: String
        if dayNum == "11" || dayNum == "12" || dayNum == "13" {
            suffix = "th"
        } else if singlesDigit == "1" {
            suffix = "st"
        } else if singlesDigit == "2" {
            suffix = "nd"
        } else if singlesDigit == "3" {
            suffix = "rd"
        } else {
            suffix = "th"
        }
        self.title.insert(contentsOf: suffix.characters, at: self.title.index(self.title.startIndex, offsetBy: (pos)))
        makeDateTitle(rect: CGRect(x: self.width/2-100, y: 26, width: 200, height: 30), font: UIFont(name:"HelveticaNeue-Bold", size: 17)!)
    }
    
    // Displays the buttons on the header
    func showHeaderButtons() {
        todayButton.frame = CGRect(x: self.width-60, y: 26, width: 50, height: 30)
        todayButton.setTitle("Today", for: .normal)
        todayButton.setTitleColor(Header.appColor, for: .normal)
        todayButton.addTarget(self, action: #selector(self.todayButtonPressed(_:)), for:.touchUpInside)
        todayButton.isHidden = true
        self.addSubview(todayButton)
        
        backwardButton = makeButton(fileName: "Backward.png", buttonX: self.width/2-112, selector: #selector(self.backwardArrowPressed(_:)), showTouch: true)
        forwardButton = makeButton(fileName: "Forward.png", buttonX: self.width/2+90, selector: #selector(self.forwardArrowPressed(_:)), showTouch: false)
        forwardButton.tintColor = UIColor.white
    }
    
    // Creates the label that shows the date in the middle of the header
    func makeDateTitle(rect: CGRect, font: UIFont) {
        dateLabel.frame = rect
        dateLabel.text = self.title
        dateLabel.font = font
        dateLabel.textColor = Header.appColor
        dateLabel.textAlignment = NSTextAlignment.center
        self.addSubview(dateLabel)
    }
    
    // Moves date forward (in EntryController)
    func forwardArrowPressed(_ sender: UIButton!) {
        delegate.dateChanged(mod: "forward")
    }
    
    // Moves date backward (in EntryController)
    func backwardArrowPressed(_ sender: UIButton!) {
        delegate.dateChanged(mod: "backward")
    }
    
    // Moves date to today (in EntryController)
    func todayButtonPressed(_ sender: UIButton!) {
        delegate.dateChanged(mod: "today")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
