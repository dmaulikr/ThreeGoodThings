//
//  EntryBox.swift
//  HappinessJournal
//
//  Created by Asher Dale on 1/24/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit

class EntryBox: UIView, UITextViewDelegate {
    
    var parent: EntryController
    let width = 375
    var yValue: Int
    var textView: UITextView
    var imageView = UIImageView()
    let charLabel = UILabel()
    let charLimit = 100
    let typePrompt = "Press here to begin typing..."
    var lastEntryEdited = ""
    
    // Initializes the object
    init(parentController: EntryController, boxNum: Int) {
        self.parent = parentController
        textView = UITextView(frame: CGRect(x: 80, y: 15, width: width-120, height: 130, scale: true))
        yValue = boxNum * 165
        super.init(frame: CGRect(x: 15, y: yValue, width: width-30, height: 150, scale: true))
        self.backgroundColor = UIColor.white
        textView.delegate = self
        self.layer.cornerRadius = 10
        
        showIcon()
        createTextField()
    }
    
    // Displays the smiley face on the left side of the EntryBox
    func showIcon() {
        imageView = UIImageView(image: UIImage(named: "Happy.png")?.withRenderingMode(.alwaysTemplate))
        imageView.frame = CGRect(x: 20, y: 50, width: 50, height: 50, scale: true)
        imageView.tintColor = UIColor.gray
        self.addSubview(imageView)
    }
    
    // Creates the text field on the right side of the EntryBox
    func createTextField() {
        textView.font =  UIFont(name:"HelveticaNeue-Light", size: 19, scale: 3)
        textView.textColor = UIColor.gray
        textView.isScrollEnabled = false
        textView.returnKeyType = UIReturnKeyType.done
        textView.spellCheckingType = .no
        self.addSubview(textView)
        
        charLabel.frame = CGRect(x: 300, y: 120, width: 50, height: 30, scale: true)
        charLabel.font = UIFont(name:"HelveticaNeue-Light", size: 11)!
        charLabel.textColor = User.sharedUser.color
        charLabel.textAlignment = NSTextAlignment.center
        charLabel.isHidden = true
        self.addSubview(charLabel)
    }
    
    // Called when the user enters the editing mode
    func textViewDidBeginEditing(_ textView: UITextView) {
        parent.scrollView.isScrollEnabled = false
        lastEntryEdited = textView.text
        if textView.text == typePrompt {
            textView.text = ""
        }
        charLabel.text = "\(charLimit-textView.text.characters.count)"
        textView.textColor = User.sharedUser.color
        charLabel.isHidden = false
        shouldHideHeaderButtons(true)
        
        parent.scrollView.setContentOffset(CGPoint(x: 0, y: yValue-52), animated: true)
    }
    
    // Called when the user presses a key on the keyboard
    func textViewDidChange(_ textView: UITextView) {
        var charCount = charLimit-textView.text.characters.count
        charLabel.text = "\(charCount)"
        if charCount < 0 {
            let endIndex = textView.text.index(textView.text.endIndex, offsetBy: charCount)
            textView.text = textView.text.substring(to: endIndex)
            charCount = 0
            charLabel.text = "\(charCount)"
        }
    }
    
    // Called when the user presses "done"
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.endEditing(true)
        }
        return true
    }
    
    // Called when the user exits the editing mode
    func textViewDidEndEditing(_ textView: UITextView) {
        parent.scrollView.isScrollEnabled = true
        charLabel.isHidden = true
        parent.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        if textView.text.isEmpty || textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            textView.text = lastEntryEdited
        }
        resetBoxIfAppropriate()
        parent.textChanged()
        shouldHideHeaderButtons(false)
    }
    
    // Resets the visual aspects of the textbox if there is no text inside of it
    func resetBoxIfAppropriate() {
        if textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty || textView.text == typePrompt {
            textView.textColor = UIColor.gray
            imageView.tintColor = UIColor.gray
        } else {
            textView.textColor = User.sharedUser.color
            imageView.tintColor = User.sharedUser.color
        }
    }
    
    // Shows the EntryBox's placeholder text prompt
    func resetBoxToPrompt() {
        textView.text = typePrompt
        textView.textColor = UIColor.gray
        imageView.tintColor = UIColor.gray
    }
    
    // Stops editing an entry
    func doneEditing(_ sender: UIButton!) {
        self.endEditing(true)
    }
    
    // Toggles whether the buttons on EntryHeader are hiden and enabled
    func shouldHideHeaderButtons(_ bool: Bool) {
        parent.header.forwardButton.isHidden = bool
        parent.header.forwardButton.isEnabled = !bool
        
        parent.header.backwardButton.isHidden = bool
        parent.header.backwardButton.isEnabled = !bool
        
        if bool || parent.pageDate.days(from: Date()) != 0 {
            parent.header.todayButton.isHidden = bool
            parent.header.todayButton.isEnabled = !bool
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
