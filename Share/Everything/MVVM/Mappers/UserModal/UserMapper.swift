//
//  UserMapper.swift
//  Share
//
//  Created by Aseem 14 on 17/11/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import Mapper

struct UserMap: Mappable{
    var Umessage: String?
    var UstatusCode: Int?
    var UserData : UserData?
     init(map: Mapper) throws{
        UstatusCode = try? map.from("statusCode")
        Umessage = try? map.from("message")
        UserData = (try? map.from("data")) ?? nil
    }
}
/*
 
 "facebookTime": 99.99870508726417,
 "instagramTime": 0.0003469766172457638,
 "tumblrTime": 0.00012799137466126158,
 "twitterTime": 0.00038597398921286696,
 "pinterestTime": 0.000052996428570678626,
 "youtubeTime": 0.00017198840970107025,
 "linkeDinTime": 0.00010399299191227503,
 
 
 "totalTime": 100006739,
 "fbTime": 100005443,
 "instaTIme": 346,
 "tumbTime": 127,
 "twitTime": 385,
 "pinTime": 52,
 "ytubeTime": 171,
 "linktime": 103,
 "vineTime": 104,
*/
struct UserData: Mappable{
    var userDetails: Userdetails?
    var UaccessToken: String?
    var name: String?
    var facebookTime:Int!
    var instagramTime:Int!
    var tumblrTime:Int!
    var twitterTime:Int!
    var pinterestTime:Int!
    var vineTime:Int!
    var linkedInTime:Int!
    var youtubeTime:Int!
    
    var fbTime:Int!
    var instaTIme:Int!
    var tumbTime:Int!
    var twitTime:Int!
    var pinTime:Int!
    var vinTime:Int!
    var linktime:Int!
    var ytubeTime:Int!
    
    var totalTime:Int!
    
    init(map: Mapper) throws{
        UaccessToken = try? map.from("accessToken")
        userDetails = (try? map.from("userDetails")) ?? nil
        name = (try? map.from("name")) ?? ""
        facebookTime = (try? map.from("facebookTime")) ?? 1
        instagramTime = (try? map.from("instagramTime")) ?? 1
        tumblrTime = (try? map.from("tumblrTime")) ?? 1
        twitterTime = (try? map.from("twitterTime")) ?? 1
        pinterestTime = (try? map.from("pinterestTime")) ?? 1
        vineTime = (try? map.from("vineTime")) ?? 1
        linkedInTime = (try? map.from("linkeDinTime")) ?? 1
        youtubeTime = (try? map.from("youtubeTime")) ?? 1
        
        fbTime = (try? map.from("fbTime")) ?? 1
        instaTIme = (try? map.from("instaTIme")) ?? 1
        tumbTime = (try? map.from("tumbTime")) ?? 1
        twitTime = (try? map.from("twitTime")) ?? 1
        pinTime = (try? map.from("pinTime")) ?? 1
        vinTime = (try? map.from("vinTime")) ?? 1
        linktime = (try? map.from("linktime")) ?? 1
        ytubeTime = (try? map.from("ytubeTime")) ?? 1
        
        totalTime = (try? map.from("totalTime")) ?? 1
        
    }
}

struct Userdetails: Mappable{
    var name: String?
    init(map: Mapper) throws{
        name = try? map.from("name")
    }
}
