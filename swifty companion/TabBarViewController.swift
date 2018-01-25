//
//  TabBarViewController.swift
//  swifty companion
//
//  Created by Paul DESPRES on 1/23/18.
//  Copyright © 2018 42. All rights reserved.
//

import UIKit


class TabBarViewController: UITabBarController {

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = user!.login
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
