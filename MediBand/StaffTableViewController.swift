//
//  StaffTableViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/26/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import SwiftSpinner
import Haneke
import JLToast

class StaffTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, addStaffControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var staffs:[Staff] = []
    var currentPageNumber:Int = 1
    var isRefreshing = false
    var isFirstLoad = true
    var sideMenuRequired = false
    var selectedStaffFlag = Staff()
    
    @IBOutlet var navBar: UIBarButtonItem!
    
    
    @IBAction func addStaffButton(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("AddStaff", sender: nil)
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            if self.revealViewController() != nil {
                navBar.target = self.revealViewController()
                navBar.action = "revealToggle:"
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

            }
        
        let pageNoToString:String = String(currentPageNumber)
        getStaff(pageNoToString)
        tableView.contentInset = UIEdgeInsets(top: -50, left: 0, bottom: 0, right: 0)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setScreeName("Staff List")
    }
    
    func getStaff(pageNumber:String){
        if !Reachability.connectedToNetwork() {
            JLToast.makeText("No Internet Connection").show()
            return
        }
        var staffMethods = StaffNetworkCall()
        if sharedDataSingleton.allStaffs.count <= 0 {
            SwiftSpinner.show("Loading Staff", animated: true)
            staffMethods.getStaffs(sharedDataSingleton.user.clinic_id, inPageNumber: pageNumber, completionBlock: { (done) -> Void in
                if(done){
                    print("all staffs fetched and passed from staff table view controller")
                    self.tableView.reloadData()
                    SwiftSpinner.hide(nil)
                    print("staff count \(sharedDataSingleton.allStaffs.count) ")
                }else{
                    SwiftSpinner.hide(nil)
                    print("error fetching and passing all staffs from staff table view controller")
                    
                }
            })
        }else {
            staffMethods.getStaffs(sharedDataSingleton.user.clinic_id, inPageNumber: pageNumber, completionBlock: { (done) -> Void in
                if(done){
                    print("all staffs fetched and passed from staff table view controller")
                    self.tableView.reloadData()
                    SwiftSpinner.hide(nil)
                    print("staff count \(sharedDataSingleton.allStaffs.count) ")
                }else{
                    SwiftSpinner.hide(nil)
                    print("error fetching and passing all staffs from staff table view controller")
                    
                }
            })
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int = 1
        if sharedDataSingleton.allStaffs.count > 0 {
            count = sharedDataSingleton.allStaffs.count
        }
        return count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       

        let cell = tableView.dequeueReusableCellWithIdentifier("StaffCell") as? StaffTableViewCell
         cell!.staffImageView.image = nil;
        if sharedDataSingleton.allStaffs.count == 0 {
            cell?.emptyLabel.hidden = false
            cell?.staffIDLabel.hidden = true
            cell?.staffImageView.hidden = true
            cell?.staffNameLabel.hidden = true
            cell?.flagImageView.hidden = true
        }else {
            
            cell?.emptyLabel.hidden = true
            cell?.staffIDLabel.hidden = false
            cell?.staffImageView.hidden = false
            cell?.staffNameLabel.hidden = false
            cell?.flagImageView.hidden = false
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
            tap.numberOfTapsRequired = 1
            cell?.flagImageView.userInteractionEnabled = true
            cell?.flagImageView.tag = indexPath.row
            cell?.flagImageView.addGestureRecognizer(tap)
            
            
            let staff = sharedDataSingleton.allStaffs[indexPath.row]
            print("member id \(staff.member_id)")
             print("general id \(staff.general_practional_id)")
            cell?.staffNameLabel.text = "\(staff.firstname) \(staff.surname)"
            cell?.staffIDLabel.text = staff.id
            //            cell.staffContactLabel.text = staff["contact"]
            if staff.image != "" {
                let URL = NSURL(string: staff.image)!
                
                cell?.staffImageView.hnk_setImageFromURL(URL)
            }else {
                cell?.staffImageView.image = UIImage(named: "defaultImage")
            }
        }

        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let staff = sharedDataSingleton.allStaffs[indexPath.row]
        self.performSegueWithIdentifier("StaffProfile", sender: staff);
    }
    
    func handleTap(sender:UITapGestureRecognizer){
        let staff = sharedDataSingleton.allStaffs[(sender.view?.tag)!];
        let taskViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TaskViewController") as! ActivitiesViewController
        taskViewController.isPatientTask = false
        taskViewController.srcViewStaffID = staff.id
        self.navigationController?.pushViewController(taskViewController, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddStaff" {
            sharedDataSingleton.selectedStaff = nil
            let controller = segue.destinationViewController
                as! AddStaffViewController
            controller.delegate = self
        }else if segue.identifier == "StaffProfile" {
            let controller = segue.destinationViewController
                as! StaffProfileViewController
            controller.isMyProfile = false
            controller.staff = sender as! Staff
            
        }
    }
    
//    func addStaffViewController(controller: AddStaffViewController, finishedAddingStaff staff: Staff) {
//        staffs.insert(staff, atIndex: staffs.count)
//        tableView.reloadData()
//        println("delegate called")
//    }
    func addStaffViewController(controller: AddStaffViewController, finishedAddingStaff staff: Staff) {
        staffs.insert(staff, atIndex: staffs.count)
        tableView.reloadData()
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
