//
//  AboutController.swift
//  HappinessJournal
//
//  Created by Asher Dale on 5/19/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit

class AboutController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the header, background, and other views
        self.view.backgroundColor = Header.bg
        let header = Header(title: "About")
        self.view.addSubview(header)
        let headerBottomBorder = UIView(frame: CGRect(x: 0.0, y: 63.5, width: 375, height: 0.5, scale: true))
        headerBottomBorder.backgroundColor = UIColor.lightGray
        self.view.addSubview(headerBottomBorder)
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: 375, height: 604, scale: true)
        containerView = UIView()
        scrollView.addSubview(containerView)
        self.view.addSubview(scrollView)
        
        let _ = makeButton(fileName: "Backward.png", rect: CGRect(x: 10, y: 31, width: 22, height: 22, scale: true), selector: #selector(self.close(_:)))
        
        let textView = UITextView(frame: CGRect(x: 8, y: 6, width: 359, height: 597, scale: true))
        textView.text = "I initially discovered the method behind \"Three Good Things\" in a book by Shawn Achor, a Harvard Professor. I was impressed that a method so simple could have a large impact on one's happiness and mental health, and I have been doing the exercise ever since.\n\nThe method was created by Martin Seligman, a professor at the University of Pennsylvania, who has been called the father of positive psychology. Along with a group of other psychologists, he conducted a study which showed that \"Three Good Things\" has a lasting effect on one's happiness and optimism, even if only done for a few weeks.\n\nI created this app because I wanted to use my deep interest in computer science to help people become happier. I hope you enjoy the app, and feel free to send me an email with feedback and/or suggestions from the settings. Most importantly, if you like the app, tell your friends about it!\n\n- Asher Dale"
        textView.textColor = User.sharedUser.color
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont(name: "HelveticaNeue-Light", size: 18, scale: 2.7)
        textView.isScrollEnabled = false
        textView.isEditable = false
        containerView.addSubview(textView)
    }
    
    // Readjusts the UIScrollView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: 64, width: 375, height: 603, scale: true)
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
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
}
