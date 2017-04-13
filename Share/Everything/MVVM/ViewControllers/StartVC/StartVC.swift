//
//  StartVC.swift
//  Share
//
//  Created by Aseem 14 on 13/12/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit

class StartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let remember = UserDefaults.standard.value(forKey: userDefaultsKey.remember.rawValue) as? String {
            if remember == "1" {
                performSegue(withIdentifier: "segueMain", sender: self)
            }
        }
    }
}
