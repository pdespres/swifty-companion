//
//  ProjectsViewController.swift
//  swifty companion
//
//  Created by Paul DESPRES on 1/25/18.
//  Copyright © 2018 42. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController, UITableViewDataSource {

    var user: User?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as! TabBarViewController
        user = tbvc.user
     }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backgroundImage = UIImage(named: "background.jpg")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundView = imageView
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (user?.projects.count)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectsCell", for: indexPath) as! ProjectsTableViewCell
        let selectedItem = user?.projects[indexPath.row]
        cell.name.text = selectedItem?.name
        if selectedItem?.status == "finished" && selectedItem?.name != "Rushes" {
            cell.mark.text = "\(selectedItem?.mark ?? 0)"
            if selectedItem?.validated == true {
                cell.mark.textColor = .white
            } else {cell.mark.textColor = .red}
        } else {cell.mark.text = "..."}
        
        cell.backgroundColor = .clear
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        return cell
    }

 

}
