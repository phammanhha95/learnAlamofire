//
//  GetVC.swift
//  AlamofireLearn
//
//  Created by Techmaster on 4/18/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import UIKit
import Alamofire
class GetVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        Alamofire.request("https://jsonplaceholder.typicode.com/posts").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
    
    

    
}
