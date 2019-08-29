import UIKit

class CellA: UITableViewCell {
    let photo = UIImageView(frame: CGRect(x: 4, y: 4, width: 100, height: 100))
    let title = UILabel(frame: CGRect(x: 112, y: 8, width: 200, height: 40))
    let subTitle = UILabel(frame: CGRect(x: 112, y: 50, width: 200, height: 40))
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(photo)
        self.addSubview(title)
        self.addSubview(subTitle)
        
        photo.layer.cornerRadius = 50.0
        photo.clipsToBounds = true
    }
}
