//
//  UserTrackerModal.swift
//  Share
//
//  Created by Aseem 14 on 17/11/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift

struct UserTrackerModal {
    let provider: RxMoyaProvider<Share>
    let providerWithHeader: RxMoyaProvider<Share>
    
    //MARK: - Login
    func validateLogin(email:String , passwd:String) -> Observable<UserMap?>  {
        
        return self.provider
            .request(Share.Login(email: email, password: passwd))
            .debug()
            .mapObjectOptional(type:UserMap.self)
    }
    
    //MARK: - Register
    func registerUser(name:String, email:String, passwd:String) -> Observable<UserMap?> {
        return self.provider
            .request(Share.Register(name: name, email: email, password: passwd))
            .debug()
            .mapObjectOptional(type: UserMap.self)
    }
    
    //MARK: - ForgotPass
    func forgotPass(email:String) -> Observable<UserMap?> {
        return self.provider
            .request(Share.ForgotPass(email: email))
            .debug()
            .mapObjectOptional(type: UserMap.self)
    }
    
    //MARK: - Update Profile
    func updateProfile(name:String) -> Observable<UserMap?> {
        return self.providerWithHeader
            .request(Share.UpdateProfile(name: name))
            .debug()
            .mapObjectOptional(type: UserMap.self)
    }
    
    //MARK: - ResetCounter
    func resetCounter() -> Observable<UserMap?> {
        return self.providerWithHeader
            .request(Share.ResetCounter())
            .debug()
            .mapObjectOptional(type: UserMap.self)
    }
    
    //MARK: - Change Password
    func changePassword(oldPass:String, newPass:String) -> Observable<UserMap?> {
        return self.providerWithHeader
            .request(Share.UpdatePassword(password: newPass))
            .debug()
            .mapObjectOptional(type: UserMap.self)
    }
    
    //MARK: - Get Status
    func getStatus() -> Observable<UserMap?> {
        return self.providerWithHeader
        .request(Share.GetStatus())
        .debug()
        .mapObjectOptional(type: UserMap.self)
    }
    
    //MARK: - send Status
    func sendStatus(facebook:String, instagram:String, twitter:String, tumblr:String, vine:String, pinterest:String, linkedin:String,youtube:String) -> Observable<UserMap?> {
        return self.providerWithHeader
            .request(Share.UpdateTime(facebook: facebook, instagram: instagram, twitter: twitter, tumblr: tumblr, vine: vine, pinterest: pinterest, linkedin: linkedin, yotube: youtube))
            .debug()
            .mapObjectOptional(type: UserMap.self)
    }
}
