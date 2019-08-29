//
//  ServerSetting.swift
//  AlamofireLearn
//
//  Created by Techmaster on 4/29/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import Foundation

class ServerSetting {
    static var baseURL : String = "http://0.0.0.0:8000/"
    static var JWTToken: String = ""
    static var refreshToken: String = ""
    static var loginUser: String = ""
    
    static func logout() {
        JWTToken = ""
        refreshToken = ""
        loginUser = ""
    }
}
