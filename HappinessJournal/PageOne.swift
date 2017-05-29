//
//  PageOne.swift
//  HappinessJournal
//
//  Created by Asher Dale on 5/16/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit

class PageOne: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the subviews
        if !(self is PageTwo || self is PageThree) {
            setUpPicture(fileName: "IconBig.png")
            setUpLargeText(text: "Three Good Things")
            setUpSmallText(text: "In just 5 minutes a day, increase your happiness and rewire your brain to focus on the positive.")

        }
    }
    
    // Sets up a large icon in the middle of the screen
    func setUpPicture(fileName: String) {
        let imageView = UIImageView(image: UIImage(named: fileName))
        imageView.frame = CGRect(x: 225/2, y: 125, width: 150, height: 150, scale: true)
        imageView.tintColor = User.sharedUser.color
        self.view.addSubview(imageView)
    }
    
    // Sets up the large text
    func setUpLargeText(text: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 275, width: 375, height: 100, scale: true))
        label.text = text
        label.textAlignment = .center
        label.textColor = User.sharedUser.color
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 25)!
        self.view.addSubview(label)
    }
    
    // Sets up the smaller text
    func setUpSmallText(text: String) {
        let textView = UITextView(frame: CGRect(x: 30, y: 375, width: 315, height: 200, scale: true))
        textView.text = text
        textView.textAlignment = .center
        textView.textColor = User.sharedUser.color
        textView.font = UIFont(name: "HelveticaNeue-Thin", size: 19, scale: 2)
        textView.isScrollEnabled = false
        textView.isEditable = false
        self.view.addSubview(textView)
    }
}
