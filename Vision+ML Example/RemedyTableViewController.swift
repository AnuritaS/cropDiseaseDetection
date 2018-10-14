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
    @IBOutlet weak var image: UIImageView!
    var remedies = [String]()
    var imageUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if imageUrl == ""{
            image.isHidden = true
        }else{
            image.isHidden = false
      image.loadImageUsingCacheWithURLString(imageUrl, placeHolder: UIImage(named: "download"))
        }
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
       
        return cell
    }
    
    
}
