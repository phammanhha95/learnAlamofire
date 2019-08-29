//
//  RequestInBackGroundTableViewController.swift
//  AlamofireLearn
//
//  Created by Techmaster on 4/18/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RequestInBackGroundTableViewController: UITableViewController {
    var json: JSON?
    override func loadView() {
        super.loadView()
        print("loadView is called")
        
        let queue = DispatchQueue(label: "com.test.api", qos: .background, attributes: .concurrent)
        Alamofire.request("https://jsonplaceholder.typicode.com/posts").responseJSON(queue: queue) { response in
            switch response.result {
            case .success(let value):
                self.json = JSON(value)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
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
        cell?.detailTextLabel?.text = record["body"].stringValue
        return cell!
    }


}
