//
//  MainVM.swift
//  Share
//
//  Created by Iqbinder Brar on 20/11/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
import Moya_ModelMapper
class MainVM
{

//MARK: - local Variables
    let disposeBag = DisposeBag()
    let viewControllerIdentifiers = ["facebook","instagram","twitter","tumblr","vine","pinterest","linkedin","youtube"]
    var facebookVC:UIViewController!
    var instagramVC:UIViewController!
    var twitterVC:UIViewController!
    var tumblrVC:UIViewController!
    var vineVC:UIViewController!
    var pinterestVC:UIViewController!
    var linkedinVC:UIViewController!
    var youtuveVC:UIViewController!
    let MainVCObj:MainVC
    var userTracker: UserTrackerModal!
    var provider: RxMoyaProvider<Share>!
    let commonFunc:CommonFunction = CommonFunction()
    var statusTimeArr = [0,0,0,0,0,0,0,0]
    
//MARK: - Initializing ViewModel
  init(mainVCObj:MainVC) {
    
    MainVCObj = mainVCObj
    
    facebookVC =  (MainVCObj.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[0]))! as UIViewController
    
    instagramVC =  (MainVCObj.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[1]))! as UIViewController
    
    twitterVC =  (MainVCObj.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[2]))! as UIViewController
    
    tumblrVC =  (MainVCObj.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[3]))! as
        UIViewController
    
    vineVC = (MainVCObj.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[4]))! as
        UIViewController
    
    pinterestVC = (MainVCObj.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[5]))! as UIViewController
    
    linkedinVC = (MainVCObj.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[6]))! as UIViewController
    
    youtuveVC = (MainVCObj.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[7]))! as UIViewController
    
    let endpointClosure = { (target: Share) -> Endpoint<Share> in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(target)
        let authkey = "bearer " + (UserDefaults.standard.value(forKey: userDefaultsKey.accessToken.rawValue) as! String)
        return defaultEndpoint.adding(newHttpHeaderFields: ["authorization": authkey])
    }
    
    let providerWithHeader = RxMoyaProvider<Share>(endpointClosure: endpointClosure)
    self.provider = RxMoyaProvider<Share>()
    
    userTracker = UserTrackerModal(provider: self.provider, providerWithHeader:providerWithHeader)
    
  //  setIndicatorColor(0)
    
    statusTimeArr[0]=1
    
    NotificationCenter.default.addObserver(self, selector: #selector(resetGraphNotification), name: NSNotification.Name(rawValue: "resetGraph"), object: nil)


  }
    
    @objc func resetGraphNotification(){
//        updateStatus()
    }
  
//MARK: - Social Button Clicked
    func socialBtnClicked(_ index:Int) {
        changeChildView(index)
    //    setIndicatorColor(btn.tag)
    }    
    
//MARK: - Change Child View controller
  func changeChildView(_ tag:Int) {
    var newController:UIViewController!
    statusTimeArr = [0,0,0,0,0,0,0,0]
    statusTimeArr[tag]=1
    switch (tag) {
    case 0:
      newController = facebookVC
      break
    case 1:
      newController = instagramVC
      break
    case 2:
      newController = twitterVC
      break
    case 3:
      newController = tumblrVC
      break
    case 4:
      newController = vineVC
      break
    case 5:
      newController = pinterestVC
      break
    case 6:
        newController = linkedinVC
        break
    case 7:
        newController = youtuveVC
        break
    default:
      break
    }
    
    let oldController = MainVCObj.childViewControllers.last! as UIViewController
    
    oldController.willMove(toParentViewController: nil)
    MainVCObj.addChildViewController(newController)
    newController.view.frame = oldController.view.frame
    
    MainVCObj.transition(from: oldController, to: newController, duration: 0.25, options: .transitionCrossDissolve, animations:{ () -> Void in
      }, completion: { (finished) -> Void in
        oldController.removeFromParentViewController()
        newController.didMove(toParentViewController: self.MainVCObj)
    })
  }
  // MARK: Editing for changing the collection cell controller
    
//MARK: - Updating Graph Status    
    func updateStatus() {
       
        self.userTracker.getStatus()
            .subscribe { event in
                switch event {
                case .next(let userMap):
                    if(userMap?.UstatusCode == 200)
                    {
                        let userDt = userMap?.UserData
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("DataPieChanged"), object: self, userInfo: ["userModel": userDt!])
                        
                    }
                    else if(userMap?.UstatusCode == 401)
                    {
                        self.MainVCObj.presentError(title:"Attention",message:"Your session is expired kindly login again",okText:"OK")
                        self.commonFunc.logout()
                        self.MainVCObj.statusTimer?.invalidate()
                        _ = self.MainVCObj.navigationController?.popToRootViewController(animated: true)
                        
                    }
                    break
                case .error(let error):
                    print("Failed:",error.localizedDescription)
                    self.MainVCObj.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
                    break
                default:break
                }
            }.addDisposableTo(self.disposeBag)

    }
    
    func sendStatus()
    {
        //print("The time obtained from usage stat is for 0, 1, 2, 3: \(statusTimeArr[0]) \(statusTimeArr[1]) \(statusTimeArr[2]) \(statusTimeArr[3])")
        self.userTracker.sendStatus(facebook: "\(statusTimeArr[0])", instagram: "\(statusTimeArr[1])", twitter: "\(statusTimeArr[2])", tumblr: "\(statusTimeArr[3])", vine: "\(statusTimeArr[4])", pinterest: "\(statusTimeArr[5])", linkedin: "\(statusTimeArr[6])", youtube: "\(statusTimeArr[7])")
            .subscribe { event in
                switch event {
                case .next(let userMap):
                    print(userMap?.Umessage! ?? "no message")
                    print("Data being saved----------------------------------------------------")
                case .error(let error):
                    print("Failed:",error.localizedDescription)
                    self.MainVCObj.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
                    break
                default:break
                }
            }.addDisposableTo(self.disposeBag)

    }
    
    func homeClicked() {
        let selectedVC:WebViewVC = MainVCObj.childViewControllers.last! as UIViewController as! WebViewVC
        if(selectedVC.webView.canGoBack)
        {
            selectedVC.webView.goBack()
        }
    }
    
    func topClicked() {
        let selectedVC:WebViewVC = MainVCObj.childViewControllers.last! as UIViewController as! WebViewVC
        selectedVC.webView.scrollView.contentOffset = CGPoint(x:0, y:0)
    }
}
