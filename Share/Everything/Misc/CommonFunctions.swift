//
//  CommonFunctions.swift
//  Share
//
//  Created by Aseem 14 on 14/12/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import Foundation



class CommonFunction {
    let constants:Constants = Constants()
    func logout() {
        UserDefaults.standard.setValue("0", forKey: userDefaultsKey.remember.rawValue)
        UserDefaults.standard.removeObject(forKey: userDefaultsKey.bgColor.rawValue)
        
        for index in 0..<8
        {
            let socialName:String = constants.getSocialName(index)
            UserDefaults.standard.removeObject(forKey: socialName)
        }

    }
}
