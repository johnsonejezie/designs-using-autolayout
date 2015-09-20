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
    
    var status = Contants().resolution
    
    weak var delegate: activityStatusTableViewControllerDelegate!


    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return status.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StatusCell", forIndexPath: indexPath) 
        
        cell.textLabel?.text = status[indexPath.row] as? String
        cell.textLabel?.textAlignment = NSTextAlignment.Center

        // Configure the cell...

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let stat: String = status[indexPath.row] as! String
        delegate?.activityStatusTableViewController(self, didSelectItem: stat)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
