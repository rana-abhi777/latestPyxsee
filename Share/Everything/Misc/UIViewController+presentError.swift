//
//  UIViewController+Extensions.swift
//  WhatsTheWeatherIn
//
//  Created by Marin Benčević on 16/06/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import UIKit

extension UIViewController {
  
    func presentError(title:String , message:String, okText:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: okText, style: .default, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: true, completion: nil)
    }
}
