//
//  LoginVC.swift
//  AlamofireLearn
//
//  Created by Techmaster on 4/28/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import UIKit
import Stevia
import Alamofire
import SwiftyJSON

class LoginVC: UIViewController {
    let userID = UnderlineTextField(frame: CGRect.zero, lineColor: nil)
    let pass = UnderlineTextField(frame: CGRect.zero, lineColor: nil)

    
    let login =  RoundButton(title: "Login", rgbColor: 0x39589b, cornerRadius: 5)
    let cancel =  RoundButton(title: "Cancel", rgbColor: 0x888888, cornerRadius: 5)
    
    let iconStatus = UIImageView(frame: CGRect.zero)
    let labelStatus = UILabel(frame: CGRect.zero)
    
    var json: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.sv(
            userID,
            pass,
            login,
            cancel,
            iconStatus,
            labelStatus
        )
        let margin : CGFloat = 16.0
        view.layout (
            100,
            |-(margin)-userID-(margin)-| ~ 40,
            20,
            |-(margin)-pass-(margin)-| ~ 40,
            40,
            |-(margin)-login.width(120)-(>=40)-cancel.width(120)-(margin)-| ~ 40,
            30,
            iconStatus.width(64).height(64),
            30,
            |-(margin)-labelStatus-(margin)-|,
            (>=20)
        )
        
        userID.placeholder("userID")
        userID.autocapitalizationType = .none
        
        
        pass.isSecureTextEntry = true
        pass.placeholder("Password")
        
        login.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        cancel.addTarget(self, action: #selector(onCancel), for: .touchUpInside)
        
        iconStatus.centerHorizontally()
        iconStatus.alpha = 0.0
        labelStatus.textAlignment = .center
        labelStatus.alpha = 0.0
        
    }
    
    @objc func onLogin() {
  
        let parameters = [
            "username": userID.text,
            "password": pass.text
        ]
        
        Alamofire.request(ServerSetting.baseURL + "auth",
                          method: .post,
                          parameters: parameters as Parameters,
                          encoding: JSONEncoding.default,
                          headers: [:]).responseJSON {response in
                            
                            switch response.result {
                            case .success(let value):
                                switch response.response?.statusCode {
                                case 200:
                                    let json = JSON(value)
                                    ServerSetting.JWTToken = json["access_token"].stringValue
                                    ServerSetting.refreshToken = json["refresh_token"].stringValue
                                    ServerSetting.loginUser = self.userID.text!
                                        
                                    self.displayLoginResult(true)
                                default:
                                    ServerSetting.JWTToken = ""
                                    ServerSetting.refreshToken = ""
                                    self.displayLoginResult(false)
                                }
                               
                            case .failure(let error):
                                print("Failed to connect: \(error)") // Failed to connect
                            }
        }
    }
    
    @objc func onCancel() {
        self.dismiss(animated: true)
    }
    
    
    
    func displayLoginResult(_ isSuccess: Bool) {
        if isSuccess {
            iconStatus.image = UIImage(named:"success")
            labelStatus.text = "Login sucessfully"
        } else {
            iconStatus.image = UIImage(named:"error")
            labelStatus.text = "Login is failed"
        }
        
        
        UIView.animate(withDuration: 1, animations: {
            self.iconStatus.alpha = 1.0
            self.labelStatus.alpha = 1.0
        }) { (_) in
            if isSuccess {
                NotificationCenter.default.post(name: NSNotification.Name("login_sucess"), object: nil)
                self.dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 1, animations: {
                    self.iconStatus.alpha = 0.0
                    self.labelStatus.alpha = 0.0
                })
            }
        }
    }

}
