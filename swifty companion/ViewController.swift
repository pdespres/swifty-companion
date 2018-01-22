//
//  ViewController.swift
//  swifty companion
//
//  Created by Paul DESPRES on 1/22/18.
//  Copyright © 2018 42. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {


//    https://api.intra.42.fr/oauth/authorize?client_id=90158da8d5d2bafaed0c5a489d8c1a772bf5c70c98e0d84fd41e75b05931e8fa&redirect_uri=https%3A%2F%2Fwww.42.fr&response_type=code
    @IBOutlet weak var textLogin: UITextField!
    
    @IBAction func btSearch(_ sender: Any) {

        Alamofire.request(
            URL(string: "https://api.intra.42.fr/v2/users")!,
//            parameters: ["access_token": Global.tokenId!, "filter[login]": "\(textLogin.text!)"])
            parameters: ["access_token": Global.tokenId!, "range[login]": "\(textLogin.text!),\(textLogin.text!)zpres"])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching token: \(String(describing: response.result.error))")
                    return
                }
                print(JSON(response.result.value))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Token()
    }

    func APITopicsRequest(token: String) {
        
        let url = "https://api.intra.42.fr/v2/users?access_token=" + token
        let request = NSMutableURLRequest(url: (URL(string : url) as! URL))
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print(err)
            }
            else if let d = data {
                do {
                    if let json = try? JSONSerialization.jsonObject(with: d, options: []) as! [NSDictionary] {
                        print(json)
//                        for forum in json {
//                            let id: Int! = forum["id"] as! Int
//                            let topics_name: String! = forum["name"] as! String
//                            let user = forum["author"]! as! NSDictionary
//                            let name: String! = user["login"] as! String
//                            let user_id: String! = String(describing: user["id"]!)
//                            let date: String! =  forum["created_at"] as! String
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//                            let date2 = dateFormatter.date(from: date!)
//                            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
//                            let newDate = dateFormatter.string(from: date2!)
//                            self.topics.append(Topics(id: id, name: name, user_id: user_id, date: newDate, text: topics_name, content: ""))
//                        }
//                        //print(self.topics)
//                        //                        print("hello")
//                        DispatchQueue.main.async {
//                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                            self.user_id = appDelegate.id_user
//                            self.topicsTable.reloadData()
//                        }
                    }
                }
                catch (let err) {
                    print(err)
                }
            }
        }
        task.resume()
    }
    
}

