//
//  SettingsVM.swift
//  Share
//
//  Created by Aseem 14 on 21/11/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import Foundation
import Moya
import Moya_ModelMapper
import RxCocoa
import RxSwift

class SettingsVM{

//MARK: - local Variables
    let disposeBag = DisposeBag()
    var provider: RxMoyaProvider<Share>!
    var userTracker: UserTrackerModal!
    var name = Variable<String?>("")
    var oldPassword = Variable<String?>("")
    var newPassword = Variable<String?>("")
    let SettingsVCObj:SettingsVC
    
//MARK: - Initializing ViewModel
    init(settingsVCObj:SettingsVC){
        
        let endpointClosure = { (target: Share) -> Endpoint<Share> in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(target)
            let authkey = "bearer " + (UserDefaults.standard.value(forKey: userDefaultsKey.accessToken.rawValue) as! String)
            return defaultEndpoint.adding(newHttpHeaderFields: ["authorization": authkey])
        }
        let providerWithHeader = RxMoyaProvider<Share>(endpointClosure: endpointClosure)
        
        self.provider = RxMoyaProvider<Share>()
        self.userTracker = UserTrackerModal(provider: self.provider, providerWithHeader:providerWithHeader)
        SettingsVCObj=settingsVCObj
    }
    
//MARK: - Saving New Name
    func saveName() {
        SettingsVCObj.activityIndicator.isHidden=false
        self.userTracker.updateProfile(name: name.value!)
            .subscribe { event in
                switch event {
                case .next(let userMap):
                    guard let statusCode = userMap?.UstatusCode else{
                        return
                    }
                    switch(statusCode){
                        case 200:self.SettingsVCObj.presentError(title:"Success",message:"Name successfully saved",okText:"OK")
                        UserDefaults.standard.set(self.name.value!, forKey: userDefaultsKey.userName.rawValue)
                        default: print(userMap?.Umessage ?? "Success")
                    self.SettingsVCObj.presentError(title:"Attention",message:(userMap?.Umessage)!,okText:"OK")
                        self.SettingsVCObj.activityIndicator.isHidden=true
                        
                    }
                case .error(let error):
                    print("Failed:",error.localizedDescription)
                    self.SettingsVCObj.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
                    self.SettingsVCObj.activityIndicator.isHidden=true
                    break
                default:break
                }
        }.addDisposableTo(self.disposeBag)
    }
    
//MARK: - Change Password
    func chnagePassword() {
        SettingsVCObj.activityIndicator.isHidden=false
        self.userTracker.changePassword(oldPass: oldPassword.value!, newPass: newPassword.value!)
            .subscribe { event in
                switch event {
                case .next(let userMap):
                    guard let statusCode = userMap?.UstatusCode else{
                        return
                    }
                    switch(statusCode){
                    case 200:
                        self.SettingsVCObj.presentError(title:"Success",message:"Password successfully changed",okText:"OK")
                        self.SettingsVCObj.activityIndicator.isHidden=true
                   
                    default: print(userMap?.Umessage ?? "Success")
                        self.SettingsVCObj.presentError(title:"Attention",message:(userMap?.Umessage)!,okText:"OK")
                    self.SettingsVCObj.activityIndicator.isHidden=true
                        break
                    }
                case .error(let error):
                    print("Failed:",error.localizedDescription)
                    self.SettingsVCObj.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
                    self.SettingsVCObj.activityIndicator.isHidden=true
                    break
                default:break
                }
        }.addDisposableTo(self.disposeBag)
    }

//MARK: - Reset Graph
    func resetGraph() {
        SettingsVCObj.activityIndicator.isHidden=false
        self.userTracker.resetCounter()
            .subscribe { event in
                switch event {
                case .next(let userMap):
                    
                    if(userMap?.UstatusCode == 200)
                    {
                        self.SettingsVCObj.presentError(title:"Success",message:"Resetting graph successful",okText:"OK")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetGraph"), object: nil)
                        self.SettingsVCObj.activityIndicator.isHidden=true
                    }
                    else
                    {
                        print(userMap?.Umessage ?? "Error Occured")
                        self.SettingsVCObj.presentError(title:"Attention",message:(userMap?.Umessage)!,okText:"OK")
                        self.SettingsVCObj.activityIndicator.isHidden=true
                    }
                    break
                case .error(let error):
                    print("Failed:",error.localizedDescription)
                    self.SettingsVCObj.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
                    self.SettingsVCObj.activityIndicator.isHidden=true
                    break
                default:break
                }
        }.addDisposableTo(self.disposeBag)
    }
}
