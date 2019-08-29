//
//  SecuredRESTVC.swift
//  AlamofireLearn
//
//  Created by Techmaster on 4/28/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class SecuredRESTVC: UITableViewController {
    var json: JSON?
    var sessionManager: SessionManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PersonCell.self, forCellReuseIdentifier: "PersonCell")
        tableView.rowHeight = 100
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onLogOut),
                                               name: NSNotification.Name("logout"),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sessionManager = SessionManager()

        self.sessionManager.adapter = JWTAccessTokenAdapter(accessToken: ServerSetting.JWTToken)
        self.sessionManager.request(ServerSetting.baseURL + "evolve").responseJSON { response in
            
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
    
    @objc func onLogOut() {
        json = nil
        tableView.reloadData()
    }

}
