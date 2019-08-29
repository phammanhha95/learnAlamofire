import UIKit

class RoundButton: UIButton {
    convenience init(title: String, rgbColor: Int, cornerRadius: CGFloat?) {
        self.init(frame: CGRect.zero)
        setTitle(title, for: .normal)
        backgroundColor = UIColor(rgb: rgbColor)
        if cornerRadius != nil {
            layer.cornerRadius = cornerRadius!
        } else {
            layer.cornerRadius = 10.0
        }
        
    }
    
}
