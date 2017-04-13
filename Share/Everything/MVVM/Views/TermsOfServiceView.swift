//
//  TermsOfServiceView.swift
//  Share
//
//  Created by Aseem 14 on 15/12/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TermsOfServiceView: UIView {
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet weak var backBtn: UIButton!
    let disposeBag = DisposeBag()

    func loadView() {
        if let pdf = Bundle.main.url(forResource: "Pyxsee Privacy Policy", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
            webView.loadRequest(req as URLRequest)
        }
    }
    
    class func instanceFromNib() -> TermsOfServiceView {
        
        return UINib(nibName: "TermsOfServiceView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TermsOfServiceView
    }

    @IBAction func btnBackClicked(_ sender: Any) {
        self.removeFromSuperview()
    }

}
