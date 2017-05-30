//
//  ProfileController.swift
//  HappinessJournal
//
//  Created by Asher Dale on 12/12/16.
//  Copyright © 2016 Asher Dale. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var containerView = UIView()
    
    let width = 375
    let height = 667
    var header: Header!
    
    let levelLabel = UILabel()
    var xpBar = UIView()
    var xpProgress = UIView()
    let xpLabel = UILabel()
    var numLabels = [UILabel]()
    
    let profileCirlce = UIButton(type: UIButtonType.custom)
    let cameraButton = UIButton(type: UIButtonType.custom)
    let imagePicker =  UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the header, background, and other views
        self.view.backgroundColor = Header.bg
        header = Header(title: "Profile")
        self.view.addSubview(header)
        let headerBottomBorder = UIView(frame: CGRect(x: 0.0, y: 63.5, width: Double(width), height: 0.5, scale: true))
        headerBottomBorder.backgroundColor = UIColor.lightGray
        self.view.addSubview(headerBottomBorder)
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: 375, height: 555, scale: true)
        containerView = UIView()
        scrollView.addSubview(containerView)
        self.view.addSubview(scrollView)
        
        profileCirlce.frame = CGRect(x: 25, y: 16, width: 80, height: 80, scale: true)
        profileCirlce.layer.cornerRadius = 0.5 * profileCirlce.bounds.size.width
        profileCirlce.contentMode = .scaleAspectFit
        profileCirlce.imageView?.clipsToBounds = true
        profileCirlce.setImage(UIImage(named: "Happy2.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        profileCirlce.tintColor = User.sharedUser.color
        profileCirlce.addTarget(self, action: #selector(self.picTouched(_:)), for: .touchUpInside)
        containerView.addSubview(profileCirlce)
        
        cameraButton.frame = CGRect(x: 19, y: 69, width: 15, height: 15, scale: true)
        cameraButton.layer.cornerRadius = cameraButton.bounds.size.width/2
        cameraButton.setImage(UIImage(named: "Camera.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cameraButton.tintColor = User.sharedUser.color
        cameraButton.addTarget(self, action: #selector(self.picTouched(_:)), for: .touchUpInside)
        containerView.addSubview(cameraButton)
        
        if User.sharedUser.proPic.image.debugDescription != "nil" {
            profileCirlce.setImage(User.sharedUser.proPic.image, for: .normal)
            profileCirlce.imageView?.layer.cornerRadius = (profileCirlce.imageView?.frame.height)!/2
            cameraButton.isHidden = true
        }
        
        let nameTextView = UITextView(frame: CGRect(x: 115, y: 11, width: width, height: 50, scale: true))
        nameTextView.delegate = self
        nameTextView.text = User.sharedUser.name
        if nameTextView.text == "" {
            nameTextView.text = "Enter name here"
        }
        nameTextView.font =  UIFont(name:"HelveticaNeue-Medium", size: 30, scale: 3)
        nameTextView.textColor = User.sharedUser.color
        nameTextView.backgroundColor = UIColor.clear
        nameTextView.isScrollEnabled = false
        nameTextView.returnKeyType = UIReturnKeyType.done
        containerView.addSubview(nameTextView)
        
        levelLabel.frame = CGRect(x: 120, y: 51, width: 150, height: 40, scale: true)
        levelLabel.font = UIFont(name:"HelveticaNeue-Light", size: 25, scale: 3)
        levelLabel.textColor = User.sharedUser.color
        containerView.addSubview(levelLabel)
        
        xpBar = UIView(frame: CGRect(x: 75/2, y: 111, width: 300, height: 15, scale: true))
        xpBar.backgroundColor = UIColor.lightGray
        xpBar.layer.cornerRadius = xpBar.bounds.height/2
        containerView.addSubview(xpBar)
        
        xpLabel.frame = CGRect(x: 0, y: 126, width: self.width, height: 35, scale: true)
        xpLabel.textAlignment = NSTextAlignment.center
        xpLabel.font = UIFont(name:"HelveticaNeue-Light", size: 18)!
        xpLabel.textColor = User.sharedUser.color
        containerView.addSubview(xpLabel)
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        setUpStats()
    }
    
    // Readjusts the UIScrollView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: 64, width: 375, height: 554, scale: true)
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    // Called when the user presses "done"
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.view.endEditing(true)
        }
        return true
    }
    
    // Called when the user exits the editing mode
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            textView.text = User.sharedUser.name
        } else {
            User.sharedUser.name = textView.text
        }
    }
    
    // Creates a UIAlertController to either take a picture or choose from the gallery
    func picTouched(_ sender: UIButton!) {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: "How would you like to set your picture?", preferredStyle: .actionSheet)
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in })
        actionSheetController.addAction(addPhotoAction(title: "Take Picture", source: .camera, message: "Sorry, the camera is inaccessible"))
        actionSheetController.addAction(addPhotoAction(title: "Choose From Photos", source: .photoLibrary, message: "Sorry, the photo gallery is inaccessible"))
        
        if User.sharedUser.proPic.image.debugDescription != "nil" {
            actionSheetController.addAction(UIAlertAction(title: "Delete Current Picture", style: .default) { action -> Void in
                User.sharedUser.proPic = UIImageView()
                self.profileCirlce.setImage(UIImage(named: "Happy2.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
                self.cameraButton.isHidden = false
            })
        }
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // Sets up the screen that allows the user to pick or take a photo
    func addPhotoAction(title: String, source: UIImagePickerControllerSourceType, message: String) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(source) {
                self.imagePicker.sourceType = source
                self.present(self.imagePicker, animated: true,completion: nil)
            } else {
                self.errorMessage(title: message, message: "")
            }
        }
    }
    
    // Displays the appropriate error message to the user when trying to pick/take a photo
    func errorMessage(title: String, message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    // Updates the profile screen based on the chosen picture
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        User.sharedUser.proPic.image = chosenImage
        profileCirlce.setImage(chosenImage, for: .normal)
        profileCirlce.imageView?.layer.cornerRadius = (profileCirlce.imageView?.frame.height)!/2
        cameraButton.isHidden = true
        dismiss(animated:true, completion: nil)
    }
    
    // Dismisses the imagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Creates the bar that displays the user's progress to the next level
    func configureXpProgress() {
        xpProgress.removeFromSuperview()
        xpProgress = UIView(frame: CGRect(x: 75/2, y: 111, width: 300*User.sharedUser.xp/(20*User.sharedUser.level-10), height: 15, scale: true))
        xpProgress.backgroundColor = User.sharedUser.color
        let maskPath = UIBezierPath(roundedRect: xpProgress.bounds, byRoundingCorners: [.bottomLeft, .topLeft], cornerRadii: CGSize(width: xpProgress.bounds.height/2, height: xpProgress.bounds.height/2))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        xpProgress.layer.mask = shape
        containerView.addSubview(xpProgress)
    }
    
    // Creates the user's statistics on the lower half of their profile
    func setUpStats() {
        let stats = [UIView(), UIView(), UIView(), UIView()]
        let nums = [User.sharedUser.streakDates.count, User.sharedUser.longestStreak, getTotalFullDays(), getTotalGoodThings()]
        let strings = ["Current Streak", "Longest Streak", "Total Completed Days", "Total Good Things"]
        var textLabels = [UILabel]()
        
        var statsHeight = self.height-250-49
        if Int(UIScreen.main.bounds.width) == 320 {
            statsHeight -= 10
        }
        let statHeight = statsHeight/4-10
        
        for i in 0 ..< stats.count {
            stats[i].frame = CGRect(x: 10, y: 186+i*statsHeight/4, width: self.width-20, height: statHeight, scale: true)
            stats[i].layer.cornerRadius = 10
            stats[i].backgroundColor = UIColor.white
            containerView.addSubview(stats[i])
            
            numLabels.append(makeLabel(label: UILabel(), text: "\(nums[i])", rect: CGRect(x: 0, y: 0, width: self.width/4, height: statHeight, scale: true), font: UIFont(name:"HelveticaNeue-Medium", size: 30, scale: 1)))
            stats[i].addSubview(numLabels[i])
            
            textLabels.append(makeLabel(label: UILabel(), text: strings[i], rect: CGRect(x: self.width/4, y: 0, width: self.width-statHeight, height: statHeight, scale: true), font: UIFont(name:"HelveticaNeue-Light", size: 23, scale: 1)))
            textLabels[i].textAlignment = .left
            stats[i].addSubview(textLabels[i])
        }
    }
    
    // Crates and returns a UILabel
    func makeLabel(label: UILabel, text: String, rect: CGRect, font: UIFont) -> UILabel{
        label.frame = rect
        label.text = text
        label.font = font
        label.textColor = User.sharedUser.color
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    // Returns the amount of filled-in days
    func getTotalFullDays() -> Int {
        var sum = 0
        for key in User.sharedUser.days.keys {
            if User.sharedUser.days[key]!.isComplete {
                sum += 1
            }
        }
        return sum
    }
    
    // Returns the amount of individual good things
    func getTotalGoodThings() -> Int {
        var sum = 0
        for key in User.sharedUser.days.keys {
            let day = User.sharedUser.days[key]
            for entry in day!.entries {
                if entry != "" && entry != "Press here to begin typing..." {
                    sum += 1
                }
            }
        }
        return sum
    }
    
    // Updates the views on the screen when this tab is opened
    func updateUserProgress() {
        levelLabel.text = "Level \(User.sharedUser.level)"
        configureXpProgress()
        xpLabel.text = "\(20*User.sharedUser.level-10-User.sharedUser.xp) XP To Next Level"
        let nums = [User.sharedUser.streakDates.count, User.sharedUser.longestStreak, getTotalFullDays(), getTotalGoodThings()]
        for i in 0 ..< numLabels.count {
            numLabels[i].text = "\(nums[i])"
        }
    }
}
