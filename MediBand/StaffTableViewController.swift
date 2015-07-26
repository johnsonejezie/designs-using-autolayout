//
//  StaffTableViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/26/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class StaffTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBAction func addStaffButton(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("AddStaff", sender: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    tableView.contentInset = UIEdgeInsets(top: -50, left: 0, bottom: 0, right: 0)

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StaffCell") as! StaffTableViewCell
        cell.staffNameLabel.text = "Janet Jack"
        cell.staffIDLabel.text = "12345"
        cell.staffContactLabel.text = "2/4 funsho street alara Yaba"
        cell.staffImageView.image = UIImage(named: "HS3")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
