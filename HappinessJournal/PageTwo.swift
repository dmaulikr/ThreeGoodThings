//
//  PageOne.swift
//  HappinessJournal
//
//  Created by Asher Dale on 5/16/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit

class PageTwo: PageOne {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the subviews
        setUpPicture(fileName: "PencilBig.png")
        setUpLargeText(text: "Log Your Highlights")
        setUpSmallText(text: "Studies have shown that writing down three good things every day has lasting effects on one's happiness, positivity, and optimism.")
    }
    
    // Sets up the large icon
    override func setUpPicture(fileName: String) {
        let imageView = UIImageView(image: UIImage(named: fileName)?.withRenderingMode(.alwaysTemplate))
        imageView.frame = CGRect(x: 150, y: 200-75/2, width: 75, height: 75, scale: true)
        imageView.tintColor = User.sharedUser.color
        self.view.addSubview(imageView)
    }
}
