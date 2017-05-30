//
//  PageOne.swift
//  HappinessJournal
//
//  Created by Asher Dale on 5/16/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit

class PageThree: PageOne, UITextFieldDelegate, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the subviews
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: 375, height: 668, scale: true)
        containerView = UIView()
        scrollView.addSubview(containerView)
        self.view.addSubview(scrollView)
        
        setUpPicture(fileName: "Badge.png")
        setUpLargeText(text: "Engage and Improve")
        setUpSmallText(text: "Level up, gain experience points (XP), view previous entries, set a customizable notification, choose a profile picture, and more.")
        setUpNameField()
    }
    
    // Readjusts the UIScrollView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: 0, width: 375, height: 667, scale: true)
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    // Sets up the large icon
    override func setUpPicture(fileName: String) {
        let imageView = UIImageView(image: UIImage(named: fileName)?.withRenderingMode(.alwaysTemplate))
        imageView.frame = CGRect(x: 125, y: 200-125/2, width: 125, height: 125, scale: true)
        imageView.tintColor = User.sharedUser.color
        containerView.addSubview(imageView)
    }
    
    // Sets up the large text
    override func setUpLargeText(text: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 275, width: 375, height: 100, scale: true))
        label.text = text
        label.textAlignment = .center
        label.textColor = User.sharedUser.color
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 25)!
        containerView.addSubview(label)
    }
    
    // Sets up the smaller text
    override func setUpSmallText(text: String) {
        let textView = UITextView(frame: CGRect(x: 30, y: 375, width: 315, height: 200, scale: true))
        textView.text = text
        textView.textAlignment = .center
        textView.textColor = User.sharedUser.color
        textView.font = UIFont(name: "HelveticaNeue-Thin", size: 19, scale: 2)
        textView.isScrollEnabled = false
        textView.isEditable = false
        containerView.addSubview(textView)
    }
    
    // Sends the user to the EntryController screen when performing the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showTabs" {
            let tabbarController = segue.destination as! UITabBarController
            tabbarController.selectedIndex = 2
        }
    }
    
    // Creates a textField for the user to enter their name
    func setUpNameField() {
        let textField = UITextField(frame: CGRect(x: 75/2, y: 510, width: 300, height: 50, scale: true))
        textField.delegate = self
        textField.font =  UIFont(name:"HelveticaNeue-Light", size: 18, scale: 3)
        textField.textColor = UIColor.lightGray
        textField.returnKeyType = UIReturnKeyType.done
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = User.sharedUser.color.cgColor
        textField.layer.borderWidth = 2
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textField.text = "Enter your name here to get started!"
        textField.autocorrectionType = .no
        textField.clearButtonMode = .never
        textField.textAlignment = .center
        containerView.addSubview(textField)
    }
    
    // Saves the name that the user enters (as long as it is not empty)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            User.sharedUser.name = textField.text!
            self.performSegue(withIdentifier: "showTabs", sender: self)
        }
        return true
    }
    
    // Called when the user begins to enter their name
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = User.sharedUser.color
        textField.text = ""
        if UIScreen.main.bounds.width == 320 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 140), animated: true)
        } else if UIScreen.main.bounds.width == 375 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 125), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 160), animated: true)
        }
        scrollView.isScrollEnabled = false
    }
}
