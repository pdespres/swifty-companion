//
//  TabBarViewController.swift
//  swifty companion
//
//  Created by Paul DESPRES on 1/23/18.
//  Copyright © 2018 42. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TabBarViewController: UITabBarController {

    var user: User?
    var json: JSON = .null
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = user!.login
        loadUserData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadUserData() {
        Alamofire.request(
            ("https://api.intra.42.fr/v2/users/\(user!.id)"),
            parameters: ["access_token": Global.tokenId!])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching user data: \(String(describing: response.result.error))")
                    return
                }
                self.json = JSON(response.result.value!)
                self.user?.fullName = self.json["displayname"].string
                print(self.user?.fullName!)
                self.user?.pool = "\(String(describing: self.json["pool_month"].string)) \(String(describing: self.json["pool_year"].string))"
                self.user?.phone = self.json["phone"].string
                self.user?.email = self.json["email"].string
                self.user?.image = self.json["image_url"].string
                self.user?.location = self.json["location"].string
                self.user?.isStaff = self.json["displayname"].bool
//                self.user?.fullName = json["displayname"].string
//                for (index, subJson):(String, JSON) in json {
//                    print(index, subJson)
//                }
        }
    }
    
//    func parseJson(key: String, ksearch: String, kvalue: String, kreturn: String) {
//        let subJson: [JSON] = self.json[key].array!
//        for (index, ssJson):(String, JSON) in subJson {
//            print(ssJson[ksearch])
//        }
//    }

}
