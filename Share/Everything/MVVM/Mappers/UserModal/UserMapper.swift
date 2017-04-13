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
    }
}

struct Userdetails: Mappable{
    var name: String?
    init(map: Mapper) throws{
        name = try? map.from("name")
    }
}
