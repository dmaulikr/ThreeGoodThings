//
//  IntroPageController.swift
//  HappinessJournal
//
//  Created by Asher Dale on 5/16/17.
//  Copyright © 2017 Asher Dale. All rights reserved.
//

import UIKit

class IntroPageController : UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    let pages = ["PageOne", "PageTwo", "PageThree"]
    var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the PageViewController
        self.delegate = self
        self.dataSource = self
            
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PageOne")
        setViewControllers([vc!],
            direction: .forward,
            animated: true,
            completion: nil)
        
    }
    
    // Lays out the ViewController's subviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            }
            else if view is UIPageControl {
                pageControl = view as! UIPageControl
                pageControl.pageIndicatorTintColor = User.sharedUser.color.withAlphaComponent(0.5)
                pageControl.currentPageIndicatorTintColor = User.sharedUser.color
                let view = UIView(frame: CGRect(x: 0, y: 580, width: 0, height: 0, scale: true))
                pageControl.frame = CGRect(x: pageControl.frame.minX, y: view.frame.origin.y, width: pageControl.frame.width, height: pageControl.frame.height)
            }
        }
    }
    
    // Called when the user goes a page backward
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index > 0 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index-1])
                }
            }
        }
        return nil
    }
    
    // Called when the user goes a page forward
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index < pages.count - 1 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index+1])
                }
            }
        }
        return nil
    }
    
    // Returns the number of pages in the PageViewController
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    // Returns the index of the page that the user is on
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let identifier = viewControllers?.first?.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                return index
            }
        }
        return 0
    }
}
