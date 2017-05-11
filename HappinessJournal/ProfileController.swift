//
//  ProfileController.swift
//  HappinessJournal
//
//  Created by Asher Dale on 12/12/16.
//  Copyright © 2016 Asher Dale. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
    
    let width = Int(UIScreen.main.bounds.width)
    let height = Int(UIScreen.main.bounds.height)
    var header: Header!
    let nameCharLimit = 9
    
    let levelLabel = UILabel()
    var xpBar = UIView()
    var xpProgress = UIView()
    let xpLabel = UILabel()
    var numLabels = [UILabel]()
    
    let profileCirlce = UIButton(type: UIButtonType.custom)
    var avatarImageView = UIImageView(image: UIImage(named: "Pro-Pic.png")?.withRenderingMode(.alwaysTemplate))
    let imagePicker =  UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the header, background, and other views
        self.view.backgroundColor = Header.bg
        header = Header(title: "Profile")
        self.view.addSubview(header)
        let headerBottomBorder = UIView(frame: CGRect(x: 0.0, y: 63.5, width: Double(width), height: 0.5))
        headerBottomBorder.backgroundColor = UIColor.lightGray
        self.view.addSubview(headerBottomBorder)
        
        profileCirlce.frame = CGRect(x: 30, y: 82, width: 100, height: 100)
        profileCirlce.layer.cornerRadius = 0.5 * profileCirlce.bounds.size.width
        profileCirlce.backgroundColor = UIColor.white
        profileCirlce.layer.borderWidth = 4
        profileCirlce.layer.borderColor = Header.appColor.cgColor
        profileCirlce.contentMode = .scaleAspectFit
        profileCirlce.imageView?.clipsToBounds = true
        profileCirlce.addTarget(self, action: #selector(self.picTouched(_:)), for: .touchUpInside)
        self.view.addSubview(profileCirlce)
        
        let editButton = UIButton(type: UIButtonType.custom)
        editButton.frame = CGRect(x: 118, y: 118, width: 28, height: 28)
        editButton.layer.cornerRadius = 0.5 * editButton.bounds.size.width
        editButton.backgroundColor = Header.appColor
        editButton.addTarget(self, action: #selector(self.picTouched(_:)), for: .touchUpInside)
        self.view.addSubview(editButton)
        
        let editIcon = UIImageView(image: UIImage(named: "Entry.png")?.withRenderingMode(.alwaysTemplate))
        editIcon.frame = CGRect(x: 5, y: 5, width: 18, height: 18)
        editIcon.tintColor = UIColor.white
        editButton.addSubview(editIcon)
        
        avatarImageView.frame = CGRect(x: 39, y: 88, width: 80, height: 80)
        avatarImageView.tintColor = Header.appColor
        self.view.addSubview(avatarImageView)
        
        let nameTextView = UITextView(frame: CGRect(x: 150, y: 72, width: width-150, height: 50))
        nameTextView.delegate = self
        nameTextView.text = User.sharedUser.name
        nameTextView.font =  UIFont(name:"HelveticaNeue-Bold", size: 40)!
        nameTextView.textColor = Header.appColor
        nameTextView.backgroundColor = UIColor.clear
        nameTextView.isScrollEnabled = false
        nameTextView.returnKeyType = UIReturnKeyType.done
        self.view.addSubview(nameTextView)
        
        levelLabel.frame = CGRect(x: 156, y: 127, width: 130, height: 40)
        levelLabel.text = "Level \(User.sharedUser.level)"
        levelLabel.font = UIFont(name:"HelveticaNeue-Thin", size: 35)!
        levelLabel.textColor = Header.appColor
        self.view.addSubview(levelLabel)
        
        xpBar = UIView(frame: CGRect(x: 75/2, y: 200, width: 300, height: 10))
        xpBar.backgroundColor = UIColor.lightGray
        xpBar.layer.cornerRadius = xpBar.bounds.height/2
        self.view.addSubview(xpBar)
        configureXpProgress()
        
        xpLabel.frame = CGRect(x: 0, y: 210, width: self.width, height: 40)
        xpLabel.text = "\(User.sharedUser.xp) / \(20*User.sharedUser.level-10)"
        xpLabel.textAlignment = NSTextAlignment.center
        xpLabel.font = UIFont(name:"HelveticaNeue-Thin", size: 21)!
        xpLabel.textColor = Header.appColor
        self.view.addSubview(xpLabel)
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if User.sharedUser.proPic.image.debugDescription != "nil" {
            profileCirlce.setImage(User.sharedUser.proPic.image, for: .normal)
            profileCirlce.imageView?.layer.cornerRadius = (profileCirlce.imageView?.frame.height)!/2
            avatarImageView.isHidden = true
        }
        
        setUpStats()
    }
    
    // Called when the user presses a key on the keyboard
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > nameCharLimit {
            textView.text.remove(at: textView.text.index(before: textView.text.endIndex))
        }
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
        avatarImageView.isHidden = true
        dismiss(animated:true, completion: nil)
    }
    
    // Dismisses the imagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func configureXpProgress() {
        xpProgress.removeFromSuperview()
        xpProgress = UIView(frame: CGRect(x: 75/2, y: 200, width: 300*User.sharedUser.xp/(20*User.sharedUser.level-10), height: 10))
        xpProgress.backgroundColor = Header.appColor
        let maskPath = UIBezierPath(roundedRect: xpProgress.bounds, byRoundingCorners: [.bottomLeft, .topLeft], cornerRadii: CGSize(width: xpProgress.bounds.height/2, height: xpProgress.bounds.height/2))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        xpProgress.layer.mask = shape
        self.view.addSubview(xpProgress)
    }
    
    func setUpStats() {
        let stats = [UIView(), UIView(), UIView(), UIView()]
        let nums = [User.sharedUser.streakDates.count, User.sharedUser.longestStreak, getTotalFullDays(), getTotalGoodThings()]
        let strings = ["Current Streak", "Longest Streak", "Total Completed Days", "Total Good Things"]
        var textLabels = [UILabel]()
        
        let statsHeight = self.height-250-49
        
        for i in 0 ..< stats.count {
            stats[i].frame = CGRect(x: 0, y: 255+i*statsHeight/4, width: self.width, height: statsHeight/4-3)
            stats[i].backgroundColor = UIColor.white
            self.view.addSubview(stats[i])
            
            numLabels.append(makeLabel(label: UILabel(), text: "\(nums[i])", rect: CGRect(x: 0, y: 0, width: self.width/4, height: statsHeight/4-3), font: UIFont(name:"HelveticaNeue-Bold", size: 30)!))
            stats[i].addSubview(numLabels[i])
            
            textLabels.append(makeLabel(label: UILabel(), text: strings[i], rect: CGRect(x: self.width/4, y: 0, width: self.width-(statsHeight/4-3), height: statsHeight/4-3), font: UIFont(name:"HelveticaNeue-Thin", size: 23)!))
            textLabels[i].textAlignment = .left
            stats[i].addSubview(textLabels[i])
        }
    }
    
    // Displays the title text of the tab in the center of the header
    func makeLabel(label: UILabel, text: String, rect: CGRect, font: UIFont) -> UILabel{
        label.frame = rect
        label.text = text
        label.font = font
        label.textColor = Header.appColor
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    func getTotalFullDays() -> Int {
        var sum = 0
        for key in User.sharedUser.days.keys {
            if User.sharedUser.days[key]!.isComplete {
                sum += 1
            }
        }
        return sum
    }
    
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
    
    func updateUserProgress() {
        levelLabel.text = "Level \(User.sharedUser.level)"
        configureXpProgress()
        xpLabel.text = "\(20*User.sharedUser.level-10-User.sharedUser.xp) experience to level up"
        let nums = [User.sharedUser.streakDates.count, User.sharedUser.longestStreak, getTotalFullDays(), getTotalGoodThings()]
        for i in 0 ..< numLabels.count {
            numLabels[i].text = "\(nums[i])"
        }
    }
}
