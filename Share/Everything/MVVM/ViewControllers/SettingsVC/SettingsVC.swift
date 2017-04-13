//
//  SettingsVC.swift
//  Share
//
//  Created by Aseem 7 on 17/10/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit
import Moya
import Moya_ModelMapper
import RxCocoa
import RxSwift


class SettingsVC: UIViewController {
    
//MARK: - local Variables
    let disposeBag = DisposeBag()
    var viewModel:SettingsVM?
    enum txtType:Int {
        case txtName = 0
        case txtNewPass = 1
    }
    let constants:Constants = Constants()
    let commonFunc:CommonFunction = CommonFunction()
    enum toggleType:Int{
        case facebookT = 0
        case instaT = 1
        case twitterT = 2
        case tumblrT = 3
        case vineT = 4
        case pintrestT = 5
        case linkedinT = 6
        case youtubeT = 7
    }
    
//MARK: - Outlets    
    @IBOutlet weak var btnSaveName: UIButton!
    @IBOutlet weak var btnChangePass: UIButton!
    @IBOutlet weak var btnResetGraph: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet var tfCollection: [TextField]!
    @IBOutlet var toggleCollection: [UIButton]!{
        didSet{
            toggleCollection.forEach{
                let socialName:String = constants.getSocialName($0.tag)
                if(UserDefaults.standard.value(forKey: socialName) != nil)
                {
                    let value:String = UserDefaults.standard.value(forKey: socialName) as! String
                    if(value == "0")
                    {
                        $0.isSelected=false;
                    }
                    else
                    {
                        $0.isSelected=true;
                    }
                }
                else
                {
                    $0.isSelected=true;
                }
            }
        }
    }
    @IBOutlet var stackCollection: [UIStackView]!{
        didSet{
            stackCollection.forEach {
                $0.isHidden = !($0.isHidden)
            }
        }
    }
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet var colorBtnCollection: [UIButton]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
//MARK: - DidLoad Function    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingsVM(settingsVCObj: self)
        bindingUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(UserDefaults.standard.value(forKey: userDefaultsKey.bgColor.rawValue) != nil ){
            
            let bgColor:Data = UserDefaults.standard.value(forKey: userDefaultsKey.bgColor.rawValue) as! Data
            let color:UIColor = NSKeyedUnarchiver.unarchiveObject(with: bgColor) as! UIColor
            self.view.backgroundColor=color
        }
        
        tfCollection[txtType.txtName.rawValue].text = UserDefaults.standard.value(forKey: userDefaultsKey.userName.rawValue) as! String?

    }
    
//MARK: - BindingUI
    func bindingUI(){
        
        //Binding Username text
        tfCollection[txtType.txtName.rawValue].rx.text
            .bindTo((viewModel?.name)!)
            .addDisposableTo(disposeBag)
        
        //Binding Password Text
        tfCollection[txtType.txtNewPass.rawValue].rx.text.bindTo((viewModel?.newPassword)!).addDisposableTo(disposeBag)
        
        toggleCollection.forEach{
            let btn:UIButton = $0
            btn.rx.tap.subscribe(onNext:{ _ in
                btn.isSelected = !(btn.isSelected);
                self.toggleCollection.forEach{ button in

                    let socialName:String = self.constants.getSocialName(button.tag)
                    
                    if(button.isSelected)
                    {
                        UserDefaults.standard.setValue("1", forKey: socialName)
                    }
                    else
                    {
                        UserDefaults.standard.setValue("0", forKey: socialName)
                    }
                }
            }).addDisposableTo(disposeBag)
            
            
        }
        
        colorBtnCollection.forEach{
            let btn:UIButton = $0
            btn.rx.tap.subscribe(onNext:{ _ in
                self.view.backgroundColor=btn.backgroundColor
                let colorData:Data = NSKeyedArchiver.archivedData(withRootObject: btn.backgroundColor!)
                UserDefaults.standard.setValue(colorData, forKey: userDefaultsKey.bgColor.rawValue)
            }).addDisposableTo(disposeBag)
            
        }

        
        btnDropDown.rx.tap.subscribe(onNext: { _ in
            self.stackCollection.forEach { stack in
                stack.isHidden = !(stack.isHidden)
            }
            self.btnDropDown.isSelected = !(self.btnDropDown.isSelected)
        }).addDisposableTo(disposeBag)
        
        //Binding Save button
        btnSaveName.rx.tap.subscribe(onNext: { _ in
            self.view.endEditing(true)
            self.viewModel?.saveName()
        }).addDisposableTo(disposeBag)
        
        //Binding Change password Button
        btnChangePass.rx.tap.subscribe(onNext: {_ in
            self.view.endEditing(true)
            self.viewModel?.chnagePassword()
        }).addDisposableTo(disposeBag)
        
        //Binding reset Graph Button
        btnResetGraph.rx.tap.subscribe(onNext: {_ in
            self.viewModel?.resetGraph()
        }).addDisposableTo(disposeBag)
        
        //Binding Logout Button
        btnLogout.rx.tap.subscribe(onNext:{_ in
           _ = self.navigationController?.popToRootViewController(animated: true)
            self.commonFunc.logout()
        }).addDisposableTo(disposeBag)
        
        //Binding Back button
        btnBack.rx.tap.subscribe(onNext:{_ in
            _ = self.navigationController?.popViewController(animated: true)
        }).addDisposableTo(disposeBag)
        
         self.view.rx.sentMessage(#selector(UIView.touchesBegan)).subscribe (onNext:{_ in self.view.endEditing(true)}).addDisposableTo(disposeBag)

    }

}
