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

    var resultSearchController:UISearchController? = nil
    var token: Token?
    
     override func viewDidLoad() {
        super.viewDidLoad()
        token = Token()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.png")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LoginSearchTable") as! LoginSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "search login..."
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.viewDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        resultSearchController!.searchBar.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Global.tokenId != nil {
            token!.checkToken()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segTo" {
            if let vc = segue.destination as? TabBarViewController {
                vc.user = sender as? User
            }
        }
    }
    
}

