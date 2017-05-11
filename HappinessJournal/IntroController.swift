//
//  IntroViewController.swift
//  HappinessJournal
//
//  Created by Asher Dale on 3/4/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit

class IntroController: UIViewController, UITextFieldDelegate {
    
    let width = Int(UIScreen.main.bounds.width)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Header.appColor
        
        // Sets up the header, background, and other views
        makeLabel(text: "Hello!", rect: CGRect(x: width/2 - 150, y: 64, width: 300, height: 52), font: UIFont(name:"HelveticaNeue-Bold", size: 29)!)
        makeLabel(text: "Please enter your name here:", rect: CGRect(x: width/2 - 150, y: 260, width: 300, height: 52), font: UIFont(name:"HelveticaNeue-Thin", size: 19)!)
        
        let textField = UITextField(frame: CGRect(x: width/2-100, y: 310, width: 200, height: 40))
        textField.font = UIFont(name:"HelveticaNeue-Thin", size: 17)!
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = self
        self.view.addSubview(textField)
        textField.becomeFirstResponder()
    }
    
    // Saves the name that the user enters (as long as it is not empty)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            textField.resignFirstResponder()
            User.sharedUser.name = textField.text!
            done()
        }
        return true
    }
    
    // Performs a segue to go back to the TabController
    func done() {
        OperationQueue.main.addOperation { self.performSegue(withIdentifier: "showTabs", sender: self) }
    }
    
    // Sends the user to the EntryController screen when performing the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTabs" {
            let tabbarController = segue.destination as! UITabBarController
            tabbarController.selectedIndex = 2
        }         
    }
    
    // Creates a label based on the pre-determined text, frame, and font to be used
    func makeLabel(text: String, rect: CGRect, font: UIFont) {
        let label = UILabel()
        label.frame = rect
        label.text = text
        label.font = font
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
    }
}
