//
//  SwiftyVC.swift
//  AlamofireLearn
//
//  Created by Techmaster on 4/18/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SwiftyVC: UITableViewController {
    //var posts: [Post]!
    var json: JSON?
    //Lấy dữ liệu
    override func loadView() {
        super.loadView()
        print("loadView is called")

        
        /*
         Hãy thử jump to definition hàm responseJSON bạn sẽ thấy @escape
         An escaping closure is a closure that’s called after the function it was passed to returns. In other words, it outlives the function it was passed to.
         A non-escaping closure is a closure that’s called within the function it was passed into, i.e. before it returns.\
         
         Trường hợp closure chạy thời gian quá lâu mà hàm bố nó cần thoát sớm, thì chúng ta phải dùng @escape để giữ các biến môi trường cho
         closure chạy
        */
        //Tạo lời gọi lên server. sau đó xử lý kết quả trả về trong responseJSON
        Alamofire.request("https://my-json-server.typicode.com/typicode/demo/posts").responseJSON { response in  //Đây là khai báo closure. Closure khác gì một method, functioon bình thường
            
            switch response.result {
            case .success(let value):
                self.json = JSON(value)
                print("Number of records \(self.json!.count)")
                print("JSON: \(self.json![0])")
                
                for (_, record) in self.json! {
                    print(record["title"])
                }
                self.tableView.reloadData()  //Reload lại tableview khi có dữ liệu mới
            case .failure(let error):
                print(error)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection is called")
        if (self.json == nil) {
            print("but json is nil")
            return 0
        } else {
            return self.json!.count
        }
       
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if (cell == nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        let record: JSON =  self.json![indexPath.row]
        //print(record["title"])
        cell?.textLabel?.text = record["title"].stringValue
        cell?.detailTextLabel?.text = "\(record["id"].intValue)   " + record["body"].stringValue
        return cell!
    }


}
