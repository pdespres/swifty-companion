//
//  LoginSearchTable.swift
//  swifty companion
//
//  Created by Paul DESPRES on 1/23/18.
//  Copyright © 2018 42. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginSearchTable: UITableViewController {

    var matchingItems: [User] = []
    var viewDelegate:ViewController? = nil
    var stkCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchingItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let selectedItem = matchingItems[indexPath.row]
        cell.textLabel?.text = selectedItem.login
//        cell.detailTextLabel?.text =
        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginSearchTable : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchBarText = searchController.searchBar.text else { return }
        // search begin arbitrary @3 char length
        if (searchBarText.count) < 3 {
            self.matchingItems = []
            self.tableView.reloadData()
            return
        } else if (searchBarText.count) > 3 && (searchBarText.count) > stkCount && self.matchingItems.count == 0 {
//            print("track count \(searchBarText.count) items \(self.matchingItems.count)")
            return
        }
        self.matchingItems = []
        stkCount = (searchBarText.count)

        Alamofire.request(
            "https://api.intra.42.fr/v2/users",
            parameters: ["access_token": Global.tokenId!, "range[login]": "\(searchBarText),\(searchBarText)z", "sort": "login"])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching users: \(String(describing: response.result.error))")
                    self.matchingItems = []
                    self.tableView.reloadData()
                    return
                }
                let json = JSON(response.result.value!)
                for ( _, subJson):(String, JSON) in json {
                    let user = User(login: subJson["login"].stringValue, id: subJson["id"].intValue)
                    self.matchingItems.append(user)
                }
                self.tableView.reloadData()
            }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row]
        matchingItems = []
        let searchCont = UISearchController(searchResultsController: self)
        searchCont.searchBar.text = ""
        viewDelegate?.resultSearchController?.searchBar.text = ""
        viewDelegate?.performSegue(withIdentifier: "segTo", sender: selectedItem)
        dismiss(animated: true, completion: nil)
    }
    
}
