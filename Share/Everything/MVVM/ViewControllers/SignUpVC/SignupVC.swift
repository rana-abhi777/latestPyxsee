//
//  SignupVC.swift
//  Share
//
//  Created by Aseem 7 on 17/10/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import Moya_ModelMapper
class SignupVC: UIViewController {

//MARK: - local Variables
    let disposeBag = DisposeBag()
    var provider: RxMoyaProvider<Share>!
    var userTracker: UserTrackerModal!
    var viewModel:SignupVM?
    
    //Enumerating Textfields
    enum txtType:Int {
      case txtName = 0
      case txtEmail = 1
      case txtPassword = 2
      case txtConfirmPassword = 3
    }

//MARK: - Outlets
    @IBOutlet var tfCollection: [UITextField]!{
        didSet{
            tfCollection.forEach{
                $0.layer.sublayerTransform=CATransform3DMakeTranslation(7, 0, 0)
            }
        }

    }
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SignupVM(signupVCObj: self)
        bindingUI()
    }
    
//MARK: - BindingUI
    func bindingUI()  {
      
        tfCollection[txtType.txtName.rawValue].rx.text.bindTo((viewModel?.nameText)!).addDisposableTo(disposeBag)
            tfCollection[txtType.txtEmail.rawValue].rx.text.bindTo((viewModel?.emailText)!).addDisposableTo(disposeBag)
            tfCollection[txtType.txtPassword.rawValue].rx.text.bindTo((viewModel?.passwrodText)!).addDisposableTo(disposeBag)
            tfCollection[txtType.txtConfirmPassword.rawValue].rx.text.bindTo((viewModel?.confirmPasswrodText)!).addDisposableTo(disposeBag)
        
        self.view.rx.sentMessage(#selector(UIView.touchesBegan)).subscribe (onNext:{_ in self.view.endEditing(true)}).addDisposableTo(disposeBag)
//        print("data")
//        print(tfCollection[txtType.txtConfirmPassword.rawValue])
    
         btnCreateAccount.rx.tap.subscribe(onNext:{ _ in
           
            print("Create button tapped")
            if self.viewModel?.passwrodText.value != self.viewModel?.confirmPasswrodText.value {
                self.presentError(title: "Alert", message: "Password and Confirm Password don't match.", okText: "OK")
            }
            else {
                self.viewModel?.btnCreateAccountClicked()
            }
         }).addDisposableTo(disposeBag)
        
        btnBack.rx.tap.subscribe(onNext: { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }).addDisposableTo(disposeBag)
    }
}
