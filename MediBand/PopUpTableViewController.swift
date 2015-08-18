//
//  PopUpTableViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/14/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

protocol popUpTableViewControllerDelegate: class {
    func popUpTableViewControllerDidCancel(controller: PopUpTableViewController)
    func popUpTableViewController(controller: PopUpTableViewController,
        didSelectItem item: String, fromArray:[String])
}

class PopUpTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var isSelectingStaff:Bool?
    weak var delegate: popUpTableViewControllerDelegate!
    @IBOutlet weak var tableView: UITableView!
            
            var list:[String]!
            var containImage:Bool!
    var staff:[Staff] = sharedDataSingleton.allStaffs
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.layer.cornerRadius = 5
        tableView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        
    }
    
 
    
    @IBAction func dismissView() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if isSelectingStaff == true {
            return staff.count
        }else {
           return list.count
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        if isSelectingStaff == true {
            let aStaff = staff[indexPath.row]
            cell.textLabel?.text = aStaff.firstname + " " + aStaff.surname
            if !aStaff.image.isEmpty {
                cell.imageView?.image = UIImage(named: aStaff.image)
            }
        }else {
          cell.textLabel?.text = list[indexPath.row]
            
        }
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            
            delegate?.popUpTableViewController(self, didSelectItem: list[indexPath.row], fromArray:list )
        
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
}
