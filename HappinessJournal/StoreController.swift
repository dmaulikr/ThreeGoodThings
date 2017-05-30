//
//  StoreController.swift
//  HappinessJournal
//
//  Created by Asher Dale on 5/12/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit

class StoreController: UIViewController {
    
    let itemHeight = 240
    var itemBreak = 0
    var colorButtons = [UIButton]()
    let cEdge = 25
    var colorChanger: StoreItem!
    var xpMultiplier: StoreItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the header, background, and other views
        self.view.backgroundColor = User.sharedUser.color
        let header = Header(title: "Store")
        self.view.addSubview(header)
        let headerBottomBorder = UIView(frame: CGRect(x: 0.0, y: 63.5, width: 375, height: 0.5, scale: true))
        headerBottomBorder.backgroundColor = UIColor.lightGray
        self.view.addSubview(headerBottomBorder)
        
        let _ = makeButton(fileName: "Backward.png", rect: CGRect(x: 10, y: 31, width: 22, height: 22, scale: true), selector: #selector(self.close(_:)))
        
        itemBreak = (553-itemHeight*2)/3
        
        colorChanger = StoreItem(yVal: 64+itemBreak, title: "Change Color Theme")
        xpMultiplier = StoreItem(yVal: 64+itemBreak*2+itemHeight, title: "XP Multiplier")
        
        self.view.addSubview(colorChanger)
        self.view.addSubview(xpMultiplier)
        
        let colors = [[UIColor.yellow, UIColor.cyan, UIColor(hexString: "#ffb3ff"), UIColor.green],
                      [UIColor.orange, UIColor(hexString: "#4A86E8"), UIColor.magenta, UIColor(hexString: "#00cc00")],
                      [UIColor.red, UIColor.blue, UIColor.purple, UIColor(hexString: "#009900")]]
        let wBreak = (itemHeight-colors[0].count*cEdge)/(colors[0].count+1)
        let hBreak = (itemHeight-100-colors.count*cEdge)/(colors.count+1)
        for i in 0..<colors.count {
            for j in 0..<colors[i].count {
                let color = UIButton(frame: CGRect(x: (j+1)*wBreak+cEdge*j, y: 50+(i+1)*hBreak+cEdge*i, width: cEdge, height: cEdge, scale: true))
                color.backgroundColor = colors[i][j]
                if colors[i][j].description == User.sharedUser.color.description {
                    color.frame.size = CGSize(width: cEdge+10, height: cEdge+10, scale: true)
                    color.frame.origin.x -= 5
                    color.frame.origin.y -= 5
                }
                color.layer.cornerRadius = 4
                color.addTarget(self, action: #selector(self.colorSelected(_:)), for: .touchUpInside)
                colorButtons.append(color)
                colorChanger.addSubview(color)
            }
        }
        
        let xpDescription = UITextView(frame: CGRect(x: 10, y: 50, width: itemHeight-20, height: itemHeight-100, scale: true))
        xpDescription.isEditable = false
        xpDescription.text = "With this upgrade, you will earn twice the amount of XP that you would normally get, enabling you to level up much faster."
        xpDescription.textAlignment = .center
        xpDescription.textColor = User.sharedUser.color
        xpDescription.font = UIFont(name: "HelveticaNeue-Thin", size: 19, scale: 3)
        xpMultiplier.addSubview(xpDescription)
        
        let restore = UIButton(frame: CGRect(x: 375/2-100, y: 607, width: 200, height: 40, scale: true))
        restore.setTitleColor(UIColor.white, for: .normal)
        restore.setTitle("Restore Purchases", for: .normal)
        restore.titleLabel?.textAlignment = .center
        restore.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
        restore.addTarget(self, action: #selector(self.restorePurchases(_:)), for: .touchUpInside)
        restore.showsTouchWhenHighlighted = true
        self.view.addSubview(restore)
    }
    
    // Sends the user back to Settings
    func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Loads and places a button icon on a specified part of the header
    func makeButton(fileName: String, rect: CGRect, selector: Selector) {
        let image = UIImage(named: fileName)?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: UIButtonType.custom)
        button.frame = rect
        button.setImage(image, for: .normal)
        button.tintColor = User.sharedUser.color
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        self.view.addSubview(button)
    }
    
    // Called when the user selects a different color
    func colorSelected(_ sender: UIButton) {
        if !User.sharedUser.boughtColor {
            return
        }
        for button in colorButtons {
            if button.backgroundColor?.description == User.sharedUser.color.description {
                button.frame.size = CGSize(width: cEdge, height: cEdge, scale: true)
                button.frame.origin.x += 5
                button.frame.origin.y += 5
            }
        }
        User.sharedUser.color = sender.backgroundColor!
        sender.frame.size = CGSize(width: cEdge+10, height: cEdge+10, scale: true)
        sender.frame.origin.x -= 5
        sender.frame.origin.y -= 5
        
        let alertController = UIAlertController(title: "To see your new color theme, close and re-open the app!", message: "Thank you for supporting the developer :)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK!", style: .default ) { action in }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {}
    }
    
    // Restores the user's purchases
    func restorePurchases(_ sender: UIButton) {
                
        User.sharedUser.boughtColor = false
        User.sharedUser.boughtMulti = false
        User.sharedUser.color = UIColor(hexString: "#4A86E8")
        User.sharedUser.xpMultiplier = 1
        
        colorChanger.buyButton.isHidden = false
        xpMultiplier.buyButton.isHidden = false
        colorChanger.check.isHidden = true
        xpMultiplier.check.isHidden = true
    }
}
