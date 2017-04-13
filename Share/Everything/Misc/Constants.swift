//
//  Constants.swift
//  Share
//
//  Created by Aseem 14 on 14/12/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import Foundation

enum userDefaultsKey:String{
    case accessToken = "share_auth_token"
    case userName = "share_user_name"
    case remember = "share_user_remember"
    case bgColor = "share_bg_color"
    case facebookTogle = "facebookShare"
    case instagramToggle = "instagramShare"
    case twitterToggle = "twitterShare"
    case tumblerToggle = "tumblrShare"
    case vineToggle = "vineShare"
    case pintrestToggle = "pinterestShare"
    case linkedinToggle = "linkedinShare"
    case youtubeToggle = "youtubeShare"
    case emailid = "emailShare"
    case password  = "passwordShare"
}

class Constants {
    
    func getSocialName(_ index:Int) -> String
    {
        switch (index) {
        case 0:
            return userDefaultsKey.facebookTogle.rawValue
        case 1:
            return userDefaultsKey.instagramToggle.rawValue
        case 2:
            return userDefaultsKey.twitterToggle.rawValue
        case 3:
            return userDefaultsKey.tumblerToggle.rawValue
        case 4:
            return userDefaultsKey.vineToggle.rawValue
        case 5:
            return userDefaultsKey.pintrestToggle.rawValue
        case 6:
            return userDefaultsKey.linkedinToggle.rawValue
        case 7:
            return userDefaultsKey.youtubeToggle.rawValue
        default:
            return "Share"
        }
    }
}




