//
//  Gloss.swift
//  AlamofireLearn
//
//  Created by Techmaster on 4/18/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import UIKit
import Gloss
import Alamofire

struct MyPost: JSONDecodable {
    let id: String?
    let body: String?
    let title: String?
    let userID: Int?

    init?(json: JSON) {
        self.id = "id" <~~ json
        self.body = "body" <~~ json
        self.title = "title" <~~ json
        self.userID = "userID" <~~ json
    }
}

class Gloss: UITableViewController {

    var posts: [MyPost]!
    override func loadView() {
        super.loadView()
        print("loadView is called")
        
        let queue = DispatchQueue(label: "com.test.api", qos: .background, attributes: .concurrent)
        Alamofire.request("https://jsonplaceholder.typicode.com/posts").responseJSON(queue: queue) { response in
            switch response.result {
            case .success(let value):
                if let array = value as? [JSON] {
                    self.posts  = [MyPost].from(jsonArray: array)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print("Failed to decode")
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
        if (self.posts == nil) {
            return 0
        } else {
            return self.posts.count
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if (cell == nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        let myPost =  self.posts[indexPath.row]

        cell?.textLabel?.text = myPost.title
        cell?.detailTextLabel?.text = myPost.body
        return cell!
    }


}
