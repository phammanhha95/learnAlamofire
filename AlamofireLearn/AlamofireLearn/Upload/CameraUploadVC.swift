//
//  CameraUploadVC.swift
//  AlamofireLearn
//
//  Created by Techmaster on 4/22/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import UIKit
import NextLevel
import AVFoundation

class CameraUploadVC: UIViewController {
    var previewView: UIView!
    
    override func loadView() {
        super.loadView()
        print("loadView")
        configureNextLevel()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func configureNextLevel() {
        let screenBounds = UIScreen.main.bounds
        self.previewView = UIView(frame: screenBounds)
        if let previewView = self.previewView {
            previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            previewView.backgroundColor = UIColor.black
            NextLevel.shared.previewLayer.frame = previewView.bounds
            previewView.layer.addSublayer(NextLevel.shared.previewLayer)
            self.view.addSubview(previewView)
        }
        
        NextLevel.shared.delegate = self
        NextLevel.shared.photoDelegate = self
        NextLevel.requestAuthorization(forMediaType: .video) { (AVMediaType, NextLevelAuthorizationStatus) in
            
        }
        
        // modify .videoConfiguration, .audioConfiguration, .photoConfiguration properties
        // Compression, resolution, and maximum recording time options are available
        NextLevel.shared.photoConfiguration.isHighResolutionEnabled = true
        NextLevel.shared.photoConfiguration.codec = .jpeg
        NextLevel.shared.photoConfiguration.generateThumbnail = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(animated)
        do {
            try NextLevel.shared.start()
        } catch let error {
            print(error)
        }
        
        // …
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
        NextLevel.shared.stop()
        // …
    }
}

extension CameraUploadVC : NextLevelDelegate {
    func nextLevel(_ nextLevel: NextLevel, didUpdateAuthorizationStatus status: NextLevelAuthorizationStatus, forMediaType mediaType: AVMediaType) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoConfiguration videoConfiguration: NextLevelVideoConfiguration) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didUpdateAudioConfiguration audioConfiguration: NextLevelAudioConfiguration) {
        
    }
    
    func nextLevelSessionWillStart(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelSessionDidStart(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelSessionDidStop(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelSessionWasInterrupted(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelSessionInterruptionEnded(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelCaptureModeWillChange(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelCaptureModeDidChange(_ nextLevel: NextLevel) {
        
    }
    
    
}

extension CameraUploadVC : NextLevelPhotoDelegate {
    func nextLevel(_ nextLevel: NextLevel, willCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didProcessPhotoCaptureWith photoDict: [String : Any]?, photoConfiguration: NextLevelPhotoConfiguration) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didProcessRawPhotoCaptureWith photoDict: [String : Any]?, photoConfiguration: NextLevelPhotoConfiguration) {
        
    }
    
    func nextLevelDidCompletePhotoCapture(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didFinishProcessingPhoto photo: AVCapturePhoto) {
        
    }
    
    
}
