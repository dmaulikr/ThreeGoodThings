//
//  StoreItem.swift
//  HappinessJournal
//
//  Created by Asher Dale on 5/16/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit

class StoreItem: UIView {
    
    let itemHeight = 240
    var buyButton: UIButton!
    var check: UIButton!
    var title: String!
    
    // Initializes the object
    init(yVal: Int, title: String) {
        super.init(frame: CGRect(x: (375-itemHeight)/2, y: yVal, width: itemHeight, height: itemHeight, scale: true))
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.title = title
        
        let labelHeight = 40
        self.addSubview(makeLabel(text: title, rect: CGRect(x: 0, y: 0, width: itemHeight, height: labelHeight, scale: true), font: UIFont(name: "HelveticaNeue-Light", size: 23, scale: 3)))
        
        let labelBorder = UIView(frame: CGRect(x: 0.0, y: Double(labelHeight), width: Double(itemHeight), height: 1, scale: true))
        labelBorder.backgroundColor = UIColor.lightGray
        self.addSubview(labelBorder)
        
        self.addSubview(makeLabel(text: "$2.99", rect: CGRect(x: 0, y: itemHeight-labelHeight-10, width: 80, height: labelHeight, scale: true), font: UIFont(name: "HelveticaNeue-Thin", size: 20)!))
        
        let buttonWidth = 70
        buyButton = UIButton(frame: CGRect(x: itemHeight-buttonWidth-10, y: itemHeight-labelHeight-10, width: buttonWidth, height: labelHeight, scale: true))
        buyButton.setTitleColor(User.sharedUser.color, for: .normal)
        buyButton.setTitle("Buy", for: .normal)
        buyButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
        buyButton.layer.cornerRadius = 5
        buyButton.layer.borderWidth = 1
        buyButton.layer.borderColor = User.sharedUser.color.cgColor
        buyButton.addTarget(self, action: #selector(self.buy(_:)), for: .touchUpInside)
        self.addSubview(buyButton)
        
        let image = UIImage(named: "Check.png")?.withRenderingMode(.alwaysTemplate)
        check = UIButton(type: UIButtonType.custom)
        check.frame = CGRect(x: itemHeight-50, y: itemHeight-45, width: 30, height: 30, scale: true)
        check.setImage(image, for: .normal)
        check.tintColor = User.sharedUser.color
        self.addSubview(check)
        check.isHidden = true
        
        if (title == "Change Color Theme" && User.sharedUser.boughtColor) || (title == "XP Multiplier" && User.sharedUser.boughtMulti) {
            buy(buyButton)
        }
    }
    
    // Displays the title text of the tab in the center of the header
    func makeLabel(text: String, rect: CGRect, font: UIFont) -> UILabel {
        let label = UILabel(frame: rect)
        label.text = text
        label.font = font
        label.textColor = User.sharedUser.color
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    // Buys the in-app purchase and applies its effects
    func buy(_ sender: UIButton) {
        
        // TODO: Get in-app purchase
        
        if title == "Change Color Theme" {
            User.sharedUser.boughtColor = true
        } else if title == "XP Multiplier" {
            User.sharedUser.boughtMulti = true
            User.sharedUser.xpMultiplier = 2
        }
        
        buyButton.isHidden = true
        check.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
