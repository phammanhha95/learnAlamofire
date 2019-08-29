//
//  SmoothLoadVC.swift
//  AlamofireLearn
//
//  Created by Techmaster on 5/6/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

struct Record {
    let id: Int
    let title: String
    let subtitle: String
    let photo: String
}
class SmoothLoadVC: UIViewController {
    var table = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
    var records = [Int: Record]()  //Dictionary
    
    //Tạo dispatch queue chạy nền, chuyên để lấy dữ liệu không ảnh hưởng đến main thread
    let queue = DispatchQueue(label: "vn.techmaster.api", qos: .background, attributes: .concurrent)

    //Tạo tên cellID unique
    let cellID = "oho"
    
    //BaseURL cần khai bao tập trung ở một nơi
    let baseURL = "http://0.0.0.0:8000/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Nên viết tách phần cấu hình table ra ngoài function đừng gõ vào trong viewDidLoad
        configureTable()
    }
    
    func configureTable() {
        table.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)
        table.dataSource = self
        table.delegate = self
        view.addSubview(table)
        //Đăng ký customize UITableViewCell
        table.register(CellA.self, forCellReuseIdentifier: cellID)
        //Đặt giá trị chiều cao row xác định sẽ giúp tăng tốc hiển thị
        table.rowHeight = 108
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Lấy dữ liệu có số bản ghi khoảng gấp 2-3 lần số dòng hiển thị
        requestData(at: 0, count: 15, onComplete: {
            //Lấy dữ liệu xong thì reload table
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        })
    }
    //Định nghĩa onComplete closure
    func requestData(at: Int, count: Int = 8, onComplete: @escaping ()->Void) {
        //Xem ví dụ LearnPython/sanic/17-RESTPagination
        Alamofire.request("\(baseURL)\(at)/\(count)").responseJSON(queue: queue) { response in
            switch response.result {
            case .success(let value):
                let jsonArray = JSON(value) //Convert value trả về ra kiểu JSON
                
                //Duyệt từng bản ghi trong mảng JSON
                for (_, item) in jsonArray {
                    let id = item["id"].intValue  //Tạo ra một key kiểu Int
                    
                    //Tạo struct record
                    let record = Record(id: id,
                                        title: item["title"].stringValue,
                                        subtitle: item["subtitle"].stringValue,
                                        photo: item["photo"].stringValue)
                    
                    //Thêm từng record vào trong dictionary
                    self.records[id] = record
                    
                }
                // Chuẩn bị xong dữ liệu thì gọi closure onComplete
                // Theo SOLID pattern, cần phải viết logic onComplete tách bạch ra khỏi hàm requestData để
                // cho người dùng thoải mái tùy biến.
                onComplete()
                
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension SmoothLoadVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Giá trị records.count liên tục thay đổi theo số lượng bản ghi lấy về
       return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CellA
        
        if let record = records[indexPath.row] {
            cell.title.text = record.title
            cell.subTitle.text = record.subtitle
            let photo_url = baseURL + "static/" + String(format: "%03d.jpg", indexPath.row)
            let url = URL(string: photo_url)
            //Dùng extension KingFisher để load ảnh, sau đó caching ảnh
            cell.photo.kf.setImage(with: url,
                                   placeholder: UIImage(named: "placeholder"), //Nếu ảnh chưa kịp lấy về thì hiển thị tạm placeholder image
                                   options: [
                                    .cacheOriginalImage  //Caching ảnh
                                    ])
       
        }
        
        return cell
    }
    
}

extension SmoothLoadVC : UITableViewDelegate {
    // Hàm này cực quan trọng
    // Nó trả về vị trí của cell sắp xửa cần phải hiển thi
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Nếu dòng chuẩn bị hiển thị sắp vượt số bản ghi caching, thì yêu cầu lên server lấy tiếp dữ liệu
        if indexPath.row == records.count - 1{
            requestData(at: indexPath.row, count: 15, onComplete: {
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
                
            })
        }
        
    }
}

