//
//  StaffTableViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/26/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import SwiftSpinner

class StaffTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, addStaffControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var staffs:[Staff] = []
    
    
    
    @IBOutlet var navBar: UIBarButtonItem!
    
    
    @IBAction func addStaffButton(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("AddStaff", sender: nil)
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.target = self.revealViewController()
        navBar.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        getStaff()
        tableView.contentInset = UIEdgeInsets(top: -50, left: 0, bottom: 0, right: 0)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setScreeName("Staff List")
    }
    
    func getStaff(){
        var staffMethods = StaffNetworkCall()
        
        if sharedDataSingleton.allStaffs.count > 0 {
            staffMethods.getStaffs(sharedDataSingleton.user.medical_facility, completionBlock: { (done) -> Void in
                if(done){
                    println("all staffs fetched and passed from staff table view controller")
                    self.tableView.reloadData()
                    println("staff count \(sharedDataSingleton.allStaffs.count) ")
                }else{
                    println("error fetching and passing all staffs from staff table view controller")
                    
                }
            })
        }else {
            SwiftSpinner.show("Loading Staff", animated: true)
            staffMethods.getStaffs(sharedDataSingleton.user.medical_facility, completionBlock: { (done) -> Void in
                if(done){
                    println("all staffs fetched and passed from staff table view controller")
                    self.tableView.reloadData()
                    SwiftSpinner.hide(completion: nil)
                    println("staff count \(sharedDataSingleton.allStaffs.count) ")
                }else{
                    SwiftSpinner.hide(completion: nil)
                    println("error fetching and passing all staffs from staff table view controller")
                    
                }
            })
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sharedDataSingleton.allStaffs.count == 0 {
            return 1
        }else{
          return sharedDataSingleton.allStaffs.count
        }
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StaffCell") as! StaffTableViewCell
        
        if sharedDataSingleton.allStaffs.count == 0 {
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
            
            
            var staff = sharedDataSingleton.allStaffs[indexPath.row]
            let imageData:NSData = NSData(base64EncodedString: staff.image as String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            println("member id \(staff.member_id)")
             println("general id \(staff.general_practional_id)")
            cell.staffNameLabel.text = "\(staff.firstname) \(staff.surname)"
            cell.staffIDLabel.text = staff.id
            //            cell.staffContactLabel.text = staff["contact"]
            cell.staffImageView.image = UIImage(data: imageData)
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let staff = sharedDataSingleton.allStaffs[indexPath.row]
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
            controller.isMyProfile = false
            controller.staff = sender as! Staff
            
        }
    }
    
    func addStaffViewController(controller: AddStaffViewController, finishedAddingStaff staff: Staff) {
        staffs.insert(staff, atIndex: staffs.count)
        tableView.reloadData()
        println("delegate called")
    }

}

extension StaffTableViewController {
    
    func setScreeName(name: String) {
        self.title = name
        self.sendScreenView(name)
    }
    
    func sendScreenView(screenName: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: self.title)
        let build = GAIDictionaryBuilder.createScreenView().set(screenName, forKey: kGAIScreenName).build() as NSDictionary
        
        tracker.send(build as [NSObject: AnyObject])
    }
    
    func trackEvent(category: String, action: String, label: String, value: NSNumber?) {
        let tracker = GAI.sharedInstance().defaultTracker
        let trackDictionary = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build()
        tracker.send(trackDictionary as [NSObject: AnyObject])
    }
    
}
