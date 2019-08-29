//
//  UnderlineTextField.swift
//  AlamofireLearn
//
//  Created by Techmaster on 4/28/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import UIKit

class UnderlineTextField: UITextField, UITextFieldDelegate {
    let border = CALayer()
    var lineColor = UIColor.black {
        didSet{
            border.borderColor = lineColor.cgColor
        }
    }
    var selectedLineColor = UIColor(rgb: 0xFF5736)
    
    var lineHeight : CGFloat = CGFloat(1.0) {
        didSet{
            border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    convenience init(frame: CGRect,
                     lineColor: UIColor? = nil,
                     selectedLineColor: UIColor? = nil,
                     lineHeight: CGFloat? = nil) {
        self.init(frame: frame)
        
        if lineColor != nil {
            self.lineColor = lineColor!
        }
        
        if selectedLineColor != nil {
            self.selectedLineColor = selectedLineColor!
        }
        
        if lineHeight != nil {
            self.lineHeight = lineHeight!
        }
        
        self.delegate = self;
        border.borderColor = self.lineColor.cgColor
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        

        border.borderWidth = self.lineHeight
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        border.borderColor = selectedLineColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        border.borderColor = lineColor.cgColor
    }
}
