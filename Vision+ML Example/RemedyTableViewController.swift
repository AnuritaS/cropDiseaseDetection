//
//  RemedyTableViewController.swift
//  Vision+ML Example
//
//  Created by Anurita Srivastava on 14/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class RemedyTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var remedies: [String]!
    var imageUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

}
extension RemedyTableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remedies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "remedyCell") as! RemedyTableViewCell
        cell.stepLabel.text = remedies[indexPath.row]
        cell.stepNo.text = "\(indexPath.row)"
        UIView.animate(withDuration: 2.0,
                       delay: 1.0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                       cell.stepNo.backgroundColor = UIColor.green
                        self.view.layoutIfNeeded()
                       
        }, completion: { (finished) -> Void in
            // ....
        })
        return cell
    }
    
    
}
