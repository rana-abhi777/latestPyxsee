//
//  SocialScreenPageViewController.swift
//  Pyxsee
//
//  Created by Sierra 4 on 31/03/17.
//  Copyright © 2017 CodeBrew. All rights reserved.
//

import UIKit

enum viewControllerIDs: String {
    case facebook = "facebook"
    case instagram = "instagram"
    case twitter = "twitter"
    case tumblr = "tumblr"
    case vine = "vine"
    case pinterest = "pinterest"
    case linkedin = "linkedin"
    case youtube = "youtube"
    
}
var currentIndex = 0
class SocialScreenPageViewController: UIPageViewController {

    
    
    var viewControllerList:[UIViewController]?
    
    override func viewDidLoad() {
        
        viewControllerList = loadVC()
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewControllerList = loadVC()
        
        
        // Do any additional setup after loading the view.
        if let firstViewController = viewControllerList?.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
            
        }

    }
    
    
    func loadVC()->[UIViewController]{
        var socialName:String
        var VC:UIViewController
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var vCArr:[UIViewController] = []
        for index in 0..<8
        {
            switch (index) {
            case 0:
                socialName = "facebookShare"
                VC = sb.instantiateViewController(withIdentifier: viewControllerIDs.facebook.rawValue)
                
            case 1:
                socialName = "instagramShare"
                VC = sb.instantiateViewController(withIdentifier: viewControllerIDs.instagram.rawValue)
            case 2:
                socialName = "twitterShare"
                VC = sb.instantiateViewController(withIdentifier: viewControllerIDs.twitter.rawValue)
            case 3:
                socialName = "tumblrShare"
                VC = sb.instantiateViewController(withIdentifier: viewControllerIDs.tumblr.rawValue)
                
            case 4:
                socialName = "vineShare"
                VC = sb.instantiateViewController(withIdentifier: viewControllerIDs.vine.rawValue)
                
            case 5:
                socialName = "pinterestShare"
                VC = sb.instantiateViewController(withIdentifier: viewControllerIDs.pinterest.rawValue)
            case 6:
                socialName = "linkedinShare"
                VC = sb.instantiateViewController(withIdentifier: viewControllerIDs.linkedin.rawValue)
                
            case 7:
                socialName = "youtubeShare"
                VC = sb.instantiateViewController(withIdentifier: viewControllerIDs.youtube.rawValue)
                
            default:
                socialName = "Share"
                VC = sb.instantiateViewController(withIdentifier: viewControllerIDs.facebook.rawValue)
            }
            
            
            if(UserDefaults.standard.value(forKey: socialName) != nil)
            {
                let value:String = UserDefaults.standard.value(forKey: socialName) as! String
                if(value != "0")
                {
                    vCArr.append(VC)
                }
            }
            else
            {
                
            }
            
        }
        return vCArr

    }
}
extension SocialScreenPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList?.index(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {return nil}
        
        guard (viewControllerList?.count)! > previousIndex else { return nil }
        
        return viewControllerList?[previousIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList?.index(of: viewController) else {return nil}
        let nextIndex = vcIndex + 1
        
        guard viewControllerList?.count != nextIndex else { return nil }
        guard (viewControllerList?.count)! > nextIndex else { return nil }
        
        return viewControllerList?[nextIndex]
    }
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllerList!.count
    }
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    {
        if let pageItemController = pendingViewControllers[0] as? WebViewVC, let index = viewControllerList?.index(of: pageItemController) {
            currentIndex = index
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("IndexChanged"), object: self, userInfo: ["index": Int(index)])
           
        }
    }
}

