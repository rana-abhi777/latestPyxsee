//
//  SocialScreenCollectionViewCell.swift
//  Pyxsee
//
//  Created by Sierra 4 on 30/03/17.
//  Copyright © 2017 CodeBrew. All rights reserved.
//

import UIKit

class SocialScreenCollectionViewCell: UICollectionViewCell {
    
    //variables
    var indexSelected: Int = 0
    
    // outlets
    @IBOutlet weak var webViewSocial: UIWebView!
    @IBOutlet weak var activityIndicatorPage: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        //webViewSocial.delegate = self
        //setupWebView()
    }
    //Enumeration of social urls
    enum stringURL :String
    {
        case facebook   = "http://m.facebook.com"
        case instagram  = "https://www.instagram.com/?hl=en"
        case twitter    = "https://mobile.twitter.com"
        case tumblr     = "https://www.tumblr.com"
        case vine       = "https://vine.co"
        case pintrest   = "https://www.pinterest.com"
        case linkedin   = "https://www.linkedin.com"
        case youtube    = "https://www.youtube.com"
    }
    
    //MARK: - Setup Webview
    func setupWebView(_ socialSelected: String) {
        
        var url:String
        print("The string selected: \(socialSelected)")
        //load requested url in webview
        switch (socialSelected) {
        case  "facebook":
            url=stringURL.facebook.rawValue
            break;
        case "instagram":
            url=stringURL.instagram.rawValue
            break
        case "twitter":
            url=stringURL.twitter.rawValue
            break
        case "tumblr":
            url=stringURL.tumblr.rawValue
            break
        case "vine":
            url=stringURL.vine.rawValue
            break
        case "pinterest":
            url=stringURL.pintrest.rawValue
            break
        case "linkedin":
            url = stringURL.linkedin.rawValue
            break
        case "youtube":
            url = stringURL.youtube.rawValue
        default:
            url=""
            break
        }
        
        UIWebView.loadRequest(webViewSocial)(URLRequest(url: URL(string: url)!))
    }
    
    //MARK: - WebView Delegates
    func webViewDidStartLoad(_ webView : UIWebView) {
        activityIndicatorPage.isHidden=false;
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView){
        activityIndicatorPage.isHidden=true;
    }
}


