//
//  WebViewVC.swift
//  Share
//
//  Created by Aseem 14 on 14/11/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController {

//MARK: - Outlets
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    
//MARK: - DidLoad Function
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
//MARK: - Setup Webview
    func setupWebView() {
        
        var url:String;
        
        //load requested url in webview
        switch (self.restorationIdentifier! as String) {
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
        
        UIWebView.loadRequest(webView)(URLRequest(url: URL(string: url)!))
    }
    
//MARK: - WebView Delegates
    func webViewDidStartLoad(_ webView : UIWebView) {
        activityIndicator.isHidden=false;
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView){
        activityIndicator.isHidden=true;
    }


}
