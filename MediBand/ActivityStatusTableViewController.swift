//
//  ActivityStatusTableViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/27/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

protocol activityStatusTableViewControllerDelegate: class {
    func activityStatusTableViewController(controller: ActivityStatusTableViewController,
        didSelectItem item: String)
}

class ActivityStatusTableViewController: UITableViewController {
    
    var status = ["Assigned", "Ungoing", "Stopped", "Discharge", "End of care"]
    
    weak var delegate: activityStatusTableViewControllerDelegate!


    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StatusCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = status[indexPath.row]
        cell.textLabel?.textAlignment = NSTextAlignment.Center

        // Configure the cell...

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let stat: String = status[indexPath.row]
        delegate?.activityStatusTableViewController(self, didSelectItem: stat)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
