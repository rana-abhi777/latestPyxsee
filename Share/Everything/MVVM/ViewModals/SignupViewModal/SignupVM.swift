//
//  SignupVM.swift
//  Share
//
//  Created by Aseem 14 on 15/11/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit
import Moya
import Moya_ModelMapper
import RxCocoa
import RxSwift

class SignupVM {

//MARK: - local Variables
    var emailText = Variable<String?>("")
    var passwrodText = Variable<String?>("")
    var confirmPasswrodText = Variable<String?>("")
    var nameText = Variable<String?>("")
    let provider: RxMoyaProvider<Share>
    let disposeBag = DisposeBag()
    var userTracker: UserTrackerModal!
    let SignupVCObj:SignupVC
    
//MARK: - Initializing ViewModel
    init(signupVCObj:SignupVC) {
        SignupVCObj=signupVCObj
        self.provider = RxMoyaProvider<Share>()
        self.userTracker = UserTrackerModal(provider: self.provider, providerWithHeader:self.provider)
    }
  
//MARK: - Create Account
    func btnCreateAccountClicked()
    {
        SignupVCObj.activityIndicator.isHidden=false
        self.userTracker.registerUser(name: nameText.value!, email: emailText.value!, passwd: passwrodText.value!)
            .subscribe { event in
                switch event {
                case .next(let userMap):
                    if(userMap?.UstatusCode == 201)
                    {
                        print(userMap?.UserData?.UaccessToken ?? "")
                        self.SignupVCObj.performSegue(withIdentifier: "segueMain", sender: self.SignupVCObj)
                        UserDefaults.standard.setValue(userMap?.UserData?.UaccessToken, forKey: userDefaultsKey.accessToken.rawValue)
                        UserDefaults.standard.setValue(userMap?.UserData?.name, forKey: userDefaultsKey.userName.rawValue)
                        self.SignupVCObj.activityIndicator.isHidden=true
                    }
                    else
                    {
                        print(userMap?.Umessage ?? "Error Occured")
                        self.SignupVCObj.presentError(title:"Attention",message:(userMap?.Umessage)!,okText:"OK")
                        self.SignupVCObj.activityIndicator.isHidden=true
                    }
                    break
                case .error(let error):
                    print("Failed:",error.localizedDescription)
                    self.SignupVCObj.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
                    break
                default:break
                }
            }.addDisposableTo(self.disposeBag)
    }
}
