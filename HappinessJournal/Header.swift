//
//  Header.swift
//  HappinessJournal
//
//  Created by Asher Dale on 12/25/16.
//  Copyright © 2016 Asher Dale. All rights reserved.
//

import UIKit

class Header: UIView {
    
    var height = 64
    let width = Int(UIScreen.main.bounds.width)
    static let appColor = UIColor(hexString: "#4A86E8")
    static let bg = UIColor(hexString: "#E3E3E3")
    var title: String
    let streakIcon = UIView()
    let streakLabel = UILabel()
    
    init(title: String) {
        self.title = title
        super.init(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        self.backgroundColor = UIColor.white
        
        showTitle(fromDate: Date())
        showStreakIcon()
    }
    
    // Displays the title of the tab
    func showTitle(fromDate: Date) {
        makeLabel(label: UILabel(), text: title, rect: CGRect(x: self.width/2-75, y: 26, width: 150, height: 30), font: UIFont(name:"HelveticaNeue-Bold", size: 17)!)
    }
    
    // Displays steak icon
    func showStreakIcon() {
        streakIcon.frame = CGRect(x: self.width-50, y: 21, width: 40, height: 40)
        self.addSubview(streakIcon)
        
        streakLabel.frame = CGRect(x: 0, y: 0, width: streakIcon.frame.width, height: streakIcon.frame.height)
        streakLabel.text = "\(User.sharedUser.streakDates.count)"
        streakLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 17)!
        streakLabel.textColor = Header.appColor
        streakLabel.textAlignment = NSTextAlignment.center
        streakIcon.addSubview(streakLabel)
        
        let image = UIImage(named: "Fire.png")?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: streakIcon.frame.width, height: streakIcon.frame.height)
        button.setImage(image, for: .normal)
        button.tintColor = Header.appColor
        streakIcon.addSubview(button)
    }
    
    func updateStreakIcon() {
        streakLabel.text = String(User.sharedUser.streakDates.count)
    }
    
    // Loads and places a button icon on a specified part of the header
    func makeButton(fileName: String, buttonX: Int, selector: Selector, showTouch: Bool) -> UIButton {
        let image = UIImage(named: fileName)?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: buttonX, y: 31, width: 22, height: 22)
        button.setImage(image, for: .normal)
        button.tintColor = Header.appColor
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.showsTouchWhenHighlighted = showTouch
        self.addSubview(button)
        return button
    }
    
    // Displays the title text of the tab in the center of the header
    func makeLabel(label: UILabel, text: String, rect: CGRect, font: UIFont) {
        label.frame = rect
        label.text = text
        label.font = font
        label.textColor = Header.appColor
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label)
    }
    
    func btnTouched(_ sender: UIButton!) {
        print("Touched!")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Extension of UIColor to allow for hex color values
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
