//
//  StaffTableViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/26/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class StaffTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, addStaffControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var staffs:[Dictionary<String, String>] = []
    @IBAction func addStaffButton(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("AddStaff", sender: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: -50, left: 0, bottom: 0, right: 0)
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if staffs.count == 0 {
            return 1
        }else{
          return staffs.count
        }
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StaffCell") as! StaffTableViewCell
        
        if staffs.count == 0 {
            cell.emptyLabel.hidden = false
            cell.staffIDLabel.hidden = true
            cell.staffImageView.hidden = true
            cell.staffNameLabel.hidden = true
            cell.flagImageView.hidden = true
        }else {
            
            cell.emptyLabel.hidden = true
            cell.staffIDLabel.hidden = false
            cell.staffImageView.hidden = false
            cell.staffNameLabel.hidden = false
            cell.flagImageView.hidden = false
            
            var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
            tap.numberOfTapsRequired = 1
            
            cell.flagImageView.userInteractionEnabled = true
            cell.flagImageView.tag = indexPath.row
            cell.flagImageView.addGestureRecognizer(tap)
            
            
            let staff = staffs[indexPath.row]
            
            let imageData:NSData = NSData(base64EncodedString: staff["staffImage"]!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            
            cell.staffNameLabel.text = staff["name"]
            cell.staffIDLabel.text = staff["staffID"]
            //            cell.staffContactLabel.text = staff["contact"]
            cell.staffImageView.image = UIImage(data: imageData)
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let staff = staffs[indexPath.row]
        self.performSegueWithIdentifier("StaffProfile", sender: staff);
    }
    
    func handleTap(sender:UITapGestureRecognizer){
        println(sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddStaff" {
            let navigationController = segue.destinationViewController
                as! UINavigationController
            let controller = navigationController.topViewController
                as! AddStaffViewController
            controller.delegate = self
        }else if segue.identifier == "StaffProfile" {
            let navigationController = segue.destinationViewController
                as! UINavigationController
            let controller = navigationController.topViewController
                as! StaffProfileViewController
            controller.staff = sender as! [String: String]
            
        }
    }
    
    func addStaffViewController(controller: AddStaffViewController, finishedAddingStaff staff: [String : String]) {
        staffs.insert(staff, atIndex: staffs.count)
        tableView.reloadData()
        println("delegate called")
    }

}
