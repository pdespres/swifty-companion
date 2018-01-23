//
//  ProfileViewController.swift
//  swifty companion
//
//  Created by Paul DESPRES on 1/22/18.
//  Copyright © 2018 42. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var user: User?
    
    @IBOutlet weak var displayname: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as! TabBarViewController
        user = tbvc.user
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.png")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        print(user?.fullName!)
        displayname.text = user?.fullName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
