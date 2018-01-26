//
//  SkillsViewController.swift
//  swifty companion
//
//  Created by Paul DESPRES on 1/25/18.
//  Copyright © 2018 42. All rights reserved.
//

import Foundation
import UIKit
import GTProgressBar

class SkillsViewController: UIViewController, UITableViewDataSource {
    
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
        return (user?.skills.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillsCell", for: indexPath) as! SkillsTableViewCell
        let selectedItem = user?.skills[indexPath.row]
        cell.name.text = selectedItem?.0
        cell.score.text = String(format: "%.2f", (selectedItem?.1)!)
        
        let progressBar = GTProgressBar()
//        progressBar.progress = CGFloat(selectedItem!.1 / 20)
        progressBar.barBorderColor = UIColor.black
        progressBar.barFillColor = UIColor.darkGray
        progressBar.barBackgroundColor = UIColor.white
        progressBar.barBorderWidth = 1
        progressBar.barFillInset = 2
        progressBar.labelTextColor = UIColor.white
        progressBar.progressLabelInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        progressBar.font = UIFont.boldSystemFont(ofSize: 18)
        progressBar.labelPosition = GTProgressBarLabelPosition.right
        progressBar.barMaxHeight = 12
        progressBar.direction = GTProgressBarDirection.clockwise
        
        progressBar.font = UIFont.boldSystemFont(ofSize: 10)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        cell.addSubview(progressBar)
        progressBar.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        progressBar.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 15).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -15).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 20).isActive = true
        UIView.animate(withDuration: 0.5, delay: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            progressBar.animateTo(progress: CGFloat(selectedItem!.1 / 20))
            }, completion: nil)
        
        cell.backgroundColor = .clear
        cell.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return cell
    }
    
}
