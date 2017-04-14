//
//  LoginVM.swift
//  Share
//
//  Created by Aseem 14 on 14/11/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit
import Moya
import Moya_ModelMapper
import RxCocoa
import RxSwift

class LoginVM {

//MARK: - local Variables
  var emailText = Variable<String?>("")
  var passwrodText = Variable<String?>("")
  let provider: RxMoyaProvider<Share>
  let disposeBag = DisposeBag()
  var userTracker: UserTrackerModal!
  let LoginVCObj:LoginVC
  
//MARK: - Initializing ViewModel
  init(loginVCObj:LoginVC){
    LoginVCObj=loginVCObj
    self.provider = RxMoyaProvider<Share>()
    self.userTracker = UserTrackerModal(provider: self.provider, providerWithHeader:self.provider)
    
  }
  
//MARK: - login
  func login(){
    
    self.LoginVCObj.activityIndicator.isHidden=false
    self.userTracker.validateLogin(email:emailText.value!, passwd: passwrodText.value!)
      .subscribe { event in
        switch event {
        case .next(let userMap):
          if(userMap?.UstatusCode == 200)
          {
            //MARK: Access Token
            print("The access token of user: ")
            print(userMap?.UserData?.UaccessToken ?? "")
            if(self.LoginVCObj.btnRemember.tag==1)
            {
               UserDefaults.standard.setValue(self.emailText.value, forKey: userDefaultsKey.emailid.rawValue)
                UserDefaults.standard.setValue(self.passwrodText.value, forKey: userDefaultsKey.password.rawValue)
            }
            var socialName:String = ""
            for index in 0..<8
            {
                switch (index) {
                case 0:
                    socialName = "facebookShare"
                    
                case 1:
                    socialName = "instagramShare"
                case 2:
                    socialName = "twitterShare"
                case 3:
                    socialName = "tumblrShare"
                    
                case 4:
                    socialName = "vineShare"
                    
                case 5:
                    socialName = "pinterestShare"
                case 6:
                    socialName = "linkedinShare"
                    
                case 7:
                    socialName = "youtubeShare"
                    
                default:
                    socialName = "Share"
                }
                
                UserDefaults.standard.setValue("1", forKey: socialName)
                
            }

            
            UserDefaults.standard.setValue("1", forKey: userDefaultsKey.remember.rawValue)
            self.LoginVCObj.performSegue(withIdentifier: "segueMain", sender: self.LoginVCObj)
            UserDefaults.standard.setValue(userMap?.UserData?.UaccessToken, forKey: userDefaultsKey.accessToken.rawValue)
            UserDefaults.standard.setValue(userMap?.UserData?.userDetails?.name, forKey: userDefaultsKey.userName.rawValue)
            self.LoginVCObj.activityIndicator.isHidden=true
          }
          else
          {
            print(userMap?.Umessage ?? "Error Occured")
            self.LoginVCObj.presentError(title:"Attention",message:(userMap?.Umessage)!,okText:"OK")
            self.LoginVCObj.activityIndicator.isHidden=true
          }
          break
        case .error(let error):
          print("Failed:",error.localizedDescription)
          self.LoginVCObj.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
          break
        default:break
        }
      }.addDisposableTo(self.disposeBag)
  }
  
//MARK: - Remember me
  func btnRememberClicked(){
    switch LoginVCObj.btnRemember.tag {
    case 0:
      LoginVCObj.btnRemember.setImage(UIImage(named:"ic_remeber_true"), for: UIControlState.normal)
      LoginVCObj.btnRemember.tag=1
      break
    case 1:
      LoginVCObj.btnRemember.setImage(UIImage(named:"ic_remeber"), for: UIControlState.normal)
      LoginVCObj.btnRemember.tag=0
      break
    default:break
    }
  }
  
//MARK: - Forgot Password
  func forgotPasswordClikced(){
    self.LoginVCObj.activityIndicator.isHidden=false
    self.userTracker.forgotPass(email:self.emailText.value!)
      .subscribe { event in
        switch event {
        case .next(let userMap):
          if(userMap?.UstatusCode == 200)
          {
            self.LoginVCObj.presentError(title:"Success",message:"Check your email for password",okText:"OK")
            self.LoginVCObj.activityIndicator.isHidden=true
          }
          else
          {
            print(userMap?.Umessage ?? "Error Occured")
            self.LoginVCObj.presentError(title:"Attention",message:(userMap?.Umessage)!,okText:"OK")
            self.LoginVCObj.activityIndicator.isHidden=true
          }
          break
        case .error(let error):
          print("Failed:",error.localizedDescription)
          self.LoginVCObj.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
          break
        default:break
        }
      }.addDisposableTo(self.disposeBag)
  }
  

}
