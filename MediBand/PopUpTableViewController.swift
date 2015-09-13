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
        didSelectItem item: String, inRow:String, fromArray:[AnyObject])
    func popUpTableViewwController(controller:PopUpTableViewController, selectedStaffs staff:[Staff], withIDs ids:[String], andName name:String)
}

class PopUpTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var isSelectingStaff:Bool?
    weak var delegate: popUpTableViewControllerDelegate!
    @IBOutlet weak var tableView: UITableView!
            
            var list:[AnyObject]!
            var containImage:Bool!
    var staff:[Staff] = sharedDataSingleton.allStaffs
    var selected_staff_ids:[String] = []
    var selected_staff:[Staff] = []
    
    
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
          cell.textLabel?.text = list[indexPath.row] as? String
            
        }
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
        return cell
    }
    
    func removeObject<T : Equatable>(object: T, inout fromArray array: [T])
    {
        var index = find(array, object)
        if let ind = index {
            array.removeAtIndex(ind)
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        var row = String(indexPath.row + 1)
        if isSelectingStaff == true {
            if cell?.accessoryType == UITableViewCellAccessoryType.Checkmark {
                cell?.accessoryType = UITableViewCellAccessoryType.None
                let aStaff:Staff = staff[indexPath.row]
                let name:String = aStaff.firstname + " " + aStaff.surname
                self.removeObject(aStaff.id, fromArray: &selected_staff_ids)
                self.removeStaff(aStaff)
//                delegate?.popUpTableViewwController(self, selectedStaffs: selected_staff, withIDs: selected_staff_ids)
                delegate.popUpTableViewwController(self, selectedStaffs: selected_staff, withIDs: selected_staff_ids, andName: name)
            }else {
                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
                let aStaff:Staff = staff[indexPath.row]
                let name:String = aStaff.firstname + " " + aStaff.surname
                selected_staff.append(aStaff)
                selected_staff_ids.append(aStaff.id)
//                delegate?.popUpTableViewwController(self, selectedStaffs: selected_staff, withIDs: selected_staff_ids)
                delegate.popUpTableViewwController(self, selectedStaffs: selected_staff, withIDs: selected_staff_ids, andName: name)
            }
            
        }else {
            delegate?.popUpTableViewController(self, didSelectItem: list[indexPath.row] as! String, inRow: row, fromArray: list)
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
 
        }
    }
    
    func removeStaff(aStaff:Staff) {
        for var i = 0; i < selected_staff.count; ++i {
            if aStaff.id == selected_staff[i].id {
                selected_staff.removeAtIndex(i)
            }
        }
    }
    
}


