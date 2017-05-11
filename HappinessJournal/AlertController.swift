//
//  StreakAlert.swift
//  HappinessJournal
//
//  Created by Asher Dale on 5/1/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit

class AlertController: UIViewController {
    
    let width = Int(UIScreen.main.bounds.width)
    let height = Int(UIScreen.main.bounds.height)
    var container = UIView()
    var alertStyle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        self.view.addGestureRecognizer(tap)
        
        container = UIView(frame: CGRect(x: self.width/2-150, y: self.height/2-150, width: 300, height: 300))
        container.backgroundColor = UIColor.white
        container.layer.cornerRadius = 10
        self.view.addSubview(container)
        
        let closeTexts = ["Huzzah!", "Woohoo!", "Yippee!", "Okey Dokey!", "Whoopee!", "Yay!", "Hooray!", "Awesome!", "Hurrah!", "Cool!", "Fantastic!"]
        
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: 0, y: container.frame.height-50, width: container.frame.width, height: 50)
        closeButton.setTitle(closeTexts[Int(arc4random_uniform(UInt32(closeTexts.count)))], for: .normal)
        closeButton.setTitleColor(Header.appColor, for: .normal)
        closeButton.showsTouchWhenHighlighted = true
        closeButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        closeButton.backgroundColor = UIColor.clear
        closeButton.addTarget(self, action: #selector(self.close(_:)), for:.touchUpInside)
        container.addSubview(closeButton)
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: container.frame.height-50, width: container.frame.width, height: 1.5))
        bottomLine.backgroundColor = UIColor.lightGray
        container.addSubview(bottomLine)
        
        let bottomButton = UIView(frame: CGRect(x: 0, y: container.frame.height-50, width: container.frame.width, height: 50))
        let maskPath = UIBezierPath(roundedRect: bottomButton.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        bottomButton.layer.mask = shape
        bottomButton.backgroundColor = Header.appColor
        bottomButton.alpha = 0.15
        container.addSubview(bottomButton)
        
        if alertStyle == "streak" {
            setUpStreak()
        } else if alertStyle == "past" {
            setUpPast()
        } else if alertStyle == "level" {
            setUpLevel()
        }
    }
    
    func close(_ sender: UIButton) {
        let tabBarCon = self.presentingViewController as! UITabBarController
        let entryCon = tabBarCon.viewControllers![2] as! EntryController
        self.dismiss(animated: true, completion: nil)
        let pastLevel = User.sharedUser.level
        
        if alertStyle == "streak" {
            entryCon.addXpToUser(num: 10 + User.sharedUser.streakDates.count)
        } else if alertStyle == "past" {
            entryCon.addXpToUser(num: 5)
        }
        
        if User.sharedUser.level == pastLevel {
            UIView.animate(withDuration: 0.3) {
                entryCon.view.alpha = 1
            }
        }
    }
    
    func setUpStreak() {
        let streakCount = "\(User.sharedUser.streakDates.count)"
        container.addSubview(makeLabel(text: "Your streak has grown to a", rect: CGRect(x: 0, y: 0, width: container.frame.width, height: 50), font: UIFont(name:"HelveticaNeue-Thin", size: 20)!))
        container.addSubview(makeLabel(text: streakCount, rect: CGRect(x: 0, y: 50, width: container.frame.width, height: 75), font: UIFont(name:"HelveticaNeue-Bold", size: 78)!))
        container.addSubview(makeLabel(text: "day streak!", rect: CGRect(x: 0, y: 125, width: container.frame.width, height: 50), font: UIFont(name:"HelveticaNeue-Thin", size: 20)!))
        container.addSubview(makeLabel(text: "Met daily goal: +10 XP", rect: CGRect(x: 0, y: 175, width: container.frame.width, height: 25), font: UIFont(name:"HelveticaNeue-Thin", size: 20)!))
        container.addSubview(makeLabel(text: streakCount + " day streak: +" + streakCount + " XP", rect: CGRect(x: 0, y: 205, width: container.frame.width, height: 25), font: UIFont(name:"HelveticaNeue-Thin", size: 20)!))
    }
    
    func setUpPast() {
        container.addSubview(makeLabel(text: "+5 XP", rect: CGRect(x: 0, y: 50, width: container.frame.width, height: 75), font: UIFont(name:"HelveticaNeue-Bold", size: 78)!))
        container.addSubview(makeLabel(text: "for filling out a previous day.", rect: CGRect(x: 0, y: 150, width: container.frame.width, height: 50), font: UIFont(name:"HelveticaNeue-Thin", size: 20)!))
    }
    
    func setUpLevel() {
        container.addSubview(makeLabel(text: "By becoming happier and", rect: CGRect(x: 0, y: 40, width: container.frame.width, height: 25), font: UIFont(name:"HelveticaNeue-Thin", size: 20)!))
        container.addSubview(makeLabel(text: "more positive, you've grown to", rect: CGRect(x: 0, y: 70, width: container.frame.width, height: 25), font: UIFont(name:"HelveticaNeue-Thin", size: 20)!))
        container.addSubview(makeLabel(text: "Level \(User.sharedUser.level)!", rect: CGRect(x: 0, y: 105, width: container.frame.width, height: 75), font: UIFont(name:"HelveticaNeue-Bold", size: 52)!))
    }
    
    // Creates a label based on the pre-determined text, frame, and font to be used
    func makeLabel(text: String, rect: CGRect, font: UIFont) -> UILabel {
        let label = UILabel()
        label.frame = rect
        label.text = text
        label.font = font
        label.textColor = Header.appColor
        label.textAlignment = NSTextAlignment.center
        return label
    }
}
