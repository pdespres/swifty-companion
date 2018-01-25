//
//  ProfileViewController.swift
//  swifty companion
//
//  Created by Paul DESPRES on 1/22/18.
//  Copyright © 2018 42. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController, UIScrollViewDelegate {

    var user: User?
    var json: JSON = JSON.null
    
    let yourAttributes : [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
    //.styleDouble.rawValue, .styleThick.rawValue, .styleNone.rawValue
    
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var containerview: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var displayname: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var act_ind: UIActivityIndicatorView!
    @IBOutlet weak var campus: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var staff: UILabel!
    @IBOutlet weak var phone: UIButton!
    @IBOutlet weak var email: UIButton!
    @IBOutlet weak var promotion: UILabel!
    @IBOutlet weak var cursus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImage(named: "background.jpg")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.view.insertSubview(imageView, at: 0)

        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerview.backgroundColor = .clear
        scrollview.backgroundColor = .clear
        
        act_ind.startAnimating()
        scrollview.delegate = self
        let tbvc = self.tabBarController as! TabBarViewController
        user = tbvc.user
        level.layer.masksToBounds = true
        level.layer.cornerRadius = 30
        loadUserData()
        print("end of viewdidload")
    }

    override func viewDidAppear(_ animated: Bool) {
        print("viewdidappear")
        act_ind.stopAnimating()
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
//                print(self.json)
                self.user?.fullName = self.json["displayname"].string
                if self.json["pool_month"].string != nil && self.json["pool_year"].string != nil {
                    self.user?.pool = "\(self.json["pool_month"].stringValue) \(self.json["pool_year"].stringValue)"
                }
                self.user?.phone = self.json["phone"].string
                self.user?.email = self.json["email"].string
                self.user?.image = self.json["image_url"].string
                self.user?.location = self.json["location"].string
                self.user?.isStaff = self.json["staff?"].bool
                let e = self.json["campus"].arrayValue.map{($0["name"])}
                self.user?.campus = e[0].stringValue
                for index in 1...(e.count - 1) {
                    self.user?.campus = "\(self.user?.campus ?? "?"), \(e[index])"
                }
                let a = self.json["titles_users"].array?.filter({$0["selected"].stringValue == "true"}) ?? []
                if a.count > 0 {
                    let titre: String = (self.json["titles"].array?.filter({$0["id"].intValue == a[0]["title_id"].intValue})[0]["name"].stringValue ?? nil)!
                    self.user!.login = titre.replacingOccurrences(of: "%login", with: self.user!.login)
                }
                let c = self.json["cursus_users"].array?.filter({$0["end_at"].stringValue == ""}) ?? []
                if c.count > 0 {
                    self.user?.cursusId = c[0]["cursus_id"].int
                    self.user?.cursus = c[0]["cursus"]["name"].string
                    self.user?.level = c[0]["level"].float
                    for ( _, subJson):(String, JSON) in c[0]["skills"] {
                        self.user?.skills.append((subJson["name"].stringValue, subJson["level"].floatValue))
                    }
                } else {
                    self.user?.cursus = "-"
                    self.user?.level = nil
                }
                let d = self.json["projects_users"].array?.filter({$0["project"]["parent_id"].stringValue == ""}) ?? []
                for subJson: JSON in d {
                    let e = subJson["cursus_ids"]
                    for index in 0...e.count {
                        if e[index].intValue == self.user?.cursusId {
                            let p = Project(name: subJson["project"]["name"].stringValue,
                                            mark: subJson["final_mark"].intValue,
                                            validated: subJson["validated?"].boolValue,
                                            status: subJson["status"].stringValue)
                            self.user?.projects.append(p)
                        }
                    }
                }
                self.user?.projects.sort {
                    if $0.status != $1.status {
                        return $0.status! > $1.status!
                    } else {
                        return $0.name < $1.name
                    }
                }
                let tbvc = self.tabBarController as! TabBarViewController
                tbvc.user = self.user
                tbvc.title = self.user!.login
                self.displayUser()
        }
    }

    func displayUser () {
        staff.isHidden = true
        if let isStaff = self.user?.isStaff {
            if isStaff == true { staff.isHidden = false }
        }
        if let url = URL(string: (self.user?.image)!) {
            imageView.contentMode = .scaleAspectFit
            downloadImage(url: url)
        }
        displayname.text = self.user?.fullName
        if self.user?.phone != nil {
            let attributeString = NSMutableAttributedString(string: "\(self.user?.phone ?? "nil")",
                                                            attributes: yourAttributes)
            phone.setAttributedTitle(attributeString, for: .normal)
        } else { phone.titleLabel?.text = "nil" }
        if self.user?.email != nil {
            let attributeString = NSMutableAttributedString(string: "\(self.user?.email ?? "nil")",
                attributes: yourAttributes)
            email.setAttributedTitle(attributeString, for: .normal)
        } else { email.titleLabel?.text = "nil" }
        location.text = self.user?.location
        campus.text = self.user?.campus
        promotion.text = self.user?.pool
        cursus.text = self.user?.cursus
        if self.user?.level != nil {
            level.text = String(format: "%.2f", (self.user?.level)!)
            level.isHidden = false
        }
    }
 
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func btPhone(_ sender: Any) {
        if let url = URL(string: "tel://\(phone.titleLabel?.text ?? "")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func btEmail(_ sender: Any) {
        if let url = URL(string: "mailto:\(email.titleLabel?.text ?? "")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
