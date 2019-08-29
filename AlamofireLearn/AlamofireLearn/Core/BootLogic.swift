//
//  BootLogic.swift
//  BootStrap
//
//  Created by Techmaster on 3/19/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import Foundation
import UIKit
class BootLogic {
    
    class func boot(window: UIWindow) {
        let mainScreen = MainScreen.init(style: .grouped)
        mainScreen.title = "Demo Alamorefire"
        mainScreen.about = "Written by Cuong@techmaster.vn"
        mainScreen.sections = [
            
            Section(title: "Basic",
                    menu: [
                        Menu(title: "GET", identifier: "GetVC"),
                        Menu(title: "GET Swifty JSON", identifier: "SwiftyVC"),
                        Menu(title: "Run in background", identifier: "RequestInBackGroundTableViewController"),
                        Menu(title: "Gloss", identifier: "Gloss")
                ]),
            Section(title: "Upload",
                    menu: [
                        Menu(title: "Upload Image", identifier: "UploadImageVC"),
                        Menu(title: "Upload Camera Photo", identifier: "CameraUploadVC")
                ]),
            Section(title: "Security",
                    menu: [
                        Menu(title: "Login", identifier: "RESTSecureTabBar")
            
                ]),
            Section(title: "Smooth",
                    menu: [
                        Menu(title: "Smooth Loading", identifier: "SmoothLoadVC")
                ])
        ]
                
        let navigationController = UINavigationController.init(rootViewController: mainScreen)
        window.rootViewController = navigationController
    }
}
