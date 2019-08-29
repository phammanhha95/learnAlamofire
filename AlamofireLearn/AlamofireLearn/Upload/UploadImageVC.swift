//
//  UploadImageVC.swift
//  AlamofireLearn
//
//  Created by Techmaster on 4/22/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import UIKit
import Stevia
import Alamofire

class UploadImageVC: UIViewController {
    let photo = UIImageView(image: UIImage(named: "FerrarioBW"))
    let upload_btn = UIButton(frame: CGRect.zero)
    var progessView = UIProgressView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        photo.contentMode = .scaleAspectFit
        view.sv(photo,progessView, upload_btn)
        view.layout(
           40.0,
           |-(8)-photo-(8)-| ~ 400,
           20,
           |-40-progessView-40-|,
           30,
           upload_btn.width(150) ~ 40
        )
        progessView.progress = 0
        progessView.progressTintColor = UIColor.white
        
      
        upload_btn.centerHorizontally()
        
        upload_btn.setTitle("Upload", for: .normal)
        upload_btn.setTitleColor(UIColor.white, for: .normal)
        upload_btn.backgroundColor = UIColor.gray
        upload_btn.addTarget(self, action: #selector(onUpload), for: .touchUpInside)
    }
    
    @objc func onUpload() {
        let image = photo.image
        
        let imgData = image?.jpegData(compressionQuality: 0.9)
        
        //let parameters = ["name": rname] //Optional for extra parameter
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "file",fileName: "ferarrio.jpg", mimeType: "image/jpg")
          /*  for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            } //Optional for extra parameters*/
            
        },
        to:"http://192.168.1.124:8000/upload")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    self.progessView.progress = Float(progress.fractionCompleted)
                })
                
                upload.responseJSON { response in
                    print(response.result.value!)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    


}
