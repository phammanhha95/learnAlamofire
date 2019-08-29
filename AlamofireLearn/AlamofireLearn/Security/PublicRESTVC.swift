//
//  PublicRESTVC.swift
//  AlamofireLearn
//
//  Created by Techmaster on 4/28/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class PublicRESTVC: UITableViewController {
    var json: JSON?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PersonCell.self, forCellReuseIdentifier: "PersonCell")
        tableView.rowHeight = 100
        
        Alamofire.request(ServerSetting.baseURL + "pokemon").responseJSON { response in
            
            switch response.result {
            case .success(let value):
                self.json = JSON(value)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.json == nil) {
            return 0
        } else {
            return self.json!.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let record: JSON =  self.json![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
        
        let url = URL(string: ServerSetting.baseURL + "photo/" + record["photo"].stringValue)
        cell.avatar.kf.setImage(with: url)
        cell.name.text = record["name"].stringValue
        return cell
    }
}
