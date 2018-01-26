//
//  ProjectsViewController.swift
//  swifty companion
//
//  Created by Paul DESPRES on 1/25/18.
//  Copyright © 2018 42. All rights reserved.
//

import UIKit
import KJExpandableTableTree

class ProjectsViewController: UIViewController, UITableViewDataSource,  UITableViewDelegate {

    var user: User?
    var arrayTree:[Parent] = []
    var kjtreeInstance: KJTree = KJTree()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as! TabBarViewController
        user = tbvc.user
        var indices: [String] = []
        var i: Int = 0
        for p in user!.projects {
            if p.subproj.count < 1 {
                indices.append("\(user!.projects[i].id).1")
            } else {
                var j: Int = 0
                for _ in p.subproj {
                    indices.append("\(user!.projects[i].id).\(user!.projects[i].subproj[j].id)")
                    j += 1
                }
            }
            i += 1
        }
        kjtreeInstance = KJTree(indices: indices)
        kjtreeInstance.isInitiallyExpanded = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
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
        let total = kjtreeInstance.tableView(tableView, numberOfRowsInSection: section)
        print("rows \(total)")
        return total
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let node = kjtreeInstance.cellIdentifierUsingTableView(tableView, cellForRowAt: indexPath)
        
        if node.givenIndex.index(of: ".") == nil {
            let selectedItem = user?.projects[(user?.projects.index(where: {$0.id == Int(node.givenIndex)!}))!]
            let cellIdentifier = "projectsCell"
            var cell: ProjectsTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ProjectsTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "ProjectsTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ProjectsTableViewCell
            }
            cell?.name.text = selectedItem?.name
            if selectedItem?.status == "finished" && selectedItem?.name != "Rushes" {
                cell?.mark.text = "\(selectedItem?.mark ?? 0)"
                if selectedItem?.validated == true {
                    cell?.mark.textColor = .white
                } else {cell?.mark.textColor = .red}
            } else {
                cell?.mark.text = "..."
            }
            if selectedItem!.subproj.count > 0 {
                cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            } else { cell?.accessoryType = UITableViewCellAccessoryType.none }
            cell?.selectionStyle = .none
            cell?.backgroundColor = .clear
            cell?.backgroundColor = UIColor(white: 1, alpha: 0.1)
            return cell!
        } else {
            let idarray = node.givenIndex.components(separatedBy: ".")
            let idMaster = Int(idarray[0])
            let id = Int(idarray[1])
//            let n = node.givenIndex.index(of: ".")
//            let idMaster = Int(node.givenIndex.prefix(upTo: n!))
//            let id = Int(node.givenIndex.suffix(indexEndOfText - node.givenIndex.count))
            print("idmaster \(idMaster) id \(id)")
            let proj = user!.projects[(user!.projects.index(where: {$0.id == idMaster}))!]
            print(proj.subproj)
            let selectedItem = proj.subproj[(proj.subproj.index(where : {$0.id == id}))!]
            let cellIdentifier = "projectsSubCell"
            var cell: Projects2TableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? Projects2TableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "Projects2TableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? Projects2TableViewCell
            }
            cell?.name.text = selectedItem.name
            if selectedItem.status == "finished" {
                cell?.mark.text = "\(selectedItem.mark ?? 0)"
                if selectedItem.validated == true {
                    cell?.mark.textColor = .white
                } else {cell?.mark.textColor = .red}
            } else {
                cell?.mark.text = "..."
            }
            cell?.selectionStyle = .none
            cell?.backgroundColor = .clear
            cell?.backgroundColor = UIColor(white: 0, alpha: 0.1)
            return cell!
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = kjtreeInstance.tableView(tableView, didSelectRowAt: indexPath)
    }


}
