//
//  OutboxViewController.swift
//  MediBand
//
//  Created by Ahmed Onawale on 10/1/15.
//  Copyright © 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import SwiftSpinner
import JLToast

class Alert {
    class func outbox() -> UIAlertController {
        let alert = UIAlertController(title: "Network Unavilable", message: "Saved to the Outbox" , preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        return alert
    }
}

class OutboxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var navBar: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var deleteTaskIndexPath: NSIndexPath? = nil
//    @IBAction func refresh(sender: UIBarButtonItem) {
//        for (index, value) in sharedDataSingleton.outbox.enumerate() {
//            SwiftSpinner.show("Updating Offline Transactions")
//            let requestType = value["requestType"] as! String
//            switch requestType {
//                case "CreateStaff", "UpdateStaff":
//                    createUpdateStaff(value["staff"] as! Staff, staffImage: value["image"] as? UIImage, isCreatingNewStaff: value["isCreatingNewStaff"] as! Bool, index: index)
//                case "CreateTask":
//                    createTask(value["task"] as! Task, index: index)
//                case "CreateNewPatient":
//                    print(value)
//                    createPatient(value["patient"] as! Patient, fromMedicalFacility: value["fromMedicalFacility"] as! String, image: value["image"] as! UIImage, isCreatingNewPatient: value["isCreatingNewPatient"] as! Bool, index: index)
//                case "UpdateTaskStatus":
//                    updateTaskStatus(value["taskID"] as! String, userID: value["staffID"] as! String, resolutionID: value["resolutionID"] as! String, index: index)
//                case "createCaseNote":
//                    createCaseNote(value["caseNote"] as! CaseNote, index: index)
//                default:
//                    break
//            }
//        }
//        SwiftSpinner.hide()
//    }
    
    func UpdateOutbox(dict: [String: Any], index:Int) {
       let requestType = dict["requestType"] as! String
        switch requestType {
        case "CreateStaff", "UpdateStaff":
            createUpdateStaff(dict["value"] as! Staff, staffImage: dict["image"] as? UIImage, isCreatingNewStaff: dict["isCreatingNewStaff"] as! Bool, index: index)
        case "CreateTask":
            createTask(dict["value"] as! Task, index: index)
        case "CreateNewPatient":
            print(dict)
            createPatient(dict["value"] as! Patient, fromMedicalFacility: sharedDataSingleton.user.clinic_id, image: dict["image"] as? UIImage, isCreatingNewPatient: dict["isCreatingNewPatient"] as! Bool, index: index)
        case "UpdateTaskStatus":
            updateTaskStatus(dict["taskID"] as! String, userID: dict["staffID"] as! String, resolutionID: dict["resolutionID"] as! String, index: index)
        case "createCaseNote":
            createCaseNote(dict["value"] as! CaseNote, index: index)
        default:
            break
        }
    }
    
    func createUpdateStaff(staff: Staff, staffImage: UIImage?, isCreatingNewStaff: Bool, index: Int) {
        StaffNetworkCall().create(staff, image: staffImage, isCreatingNewStaff: isCreatingNewStaff) { [unowned self] in
            if $0 {
                sharedDataSingleton.outbox.removeAtIndex(index)
                self.tableView.reloadData()
            }
        }
    }
    
    func createTask(task: Task, index: Int) {
        TaskAPI().createTask(task) { [unowned self] createdtask, error in
            if let _ = createdtask as? Task {
                sharedDataSingleton.outbox.removeAtIndex(index)
                JLToast.makeText("Success").show()
                self.tableView.reloadData()
            }
        }
    }
    
    func createPatient(patient: Patient, fromMedicalFacility: String, image: UIImage?, isCreatingNewPatient: Bool, index: Int) {
        PatientAPI().createNewPatient(patient, fromMedicalFacility: fromMedicalFacility, image: image, isCreatingNewPatient: isCreatingNewPatient) { [unowned self] in
            if $0 {
                sharedDataSingleton.outbox.removeAtIndex(index)
                JLToast.makeText("Success").show()
                self.tableView.reloadData()
            }
        }
    }

    func updateTaskStatus(taskID: String, userID: String, resolutionID: String, index: Int) {
        let taskAPI = TaskAPI()
        taskAPI.updateTaskStatus(taskID, staff_id: userID, resolution_id: resolutionID) { [unowned self] updatedTask, error in
            if error == nil {
                sharedDataSingleton.outbox.removeAtIndex(index)
                JLToast.makeText("Success").show()
                self.tableView.reloadData()
            }
        }
    }

    func createCaseNote(caseNote: CaseNote, index: Int) {
        CaseNoteAPI().createCaseNote(caseNote) { [unowned self] createdCaseNote, error in
            if error == nil {
                sharedDataSingleton.outbox.removeAtIndex(index)
                JLToast.makeText("Success").show()
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.target = self.revealViewController()
        navBar.action = "revealToggle:"
        tableView.rowHeight = 64
            UINavigationBar.appearance().barTintColor = sharedDataSingleton.theme
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let send = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Send", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            if !Reachability.connectedToNetwork() {
                JLToast.makeText("No Internet Connection").show()
            }else {
                let value = sharedDataSingleton.outbox[indexPath.row];
                self.UpdateOutbox(value, index: indexPath.row)
            }
        })
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
        }
        
        let arrayofactions: Array = [delete, send]
        
        return arrayofactions
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Outbox Cell") as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Outbox Cell")
        }
        cell.textLabel?.text = sharedDataSingleton.outbox[indexPath.row]["description"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedDataSingleton.outbox.count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteTaskIndexPath = indexPath
            let taskToDelete = sharedDataSingleton.outbox[indexPath.row]
            confirmDelete(taskToDelete)
        }
    }
    
    func confirmDelete(task: [String:Any]) {
        let alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to permanently delete this transaction?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteTask)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDelete)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeleteTask(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteTaskIndexPath {
            tableView.beginUpdates()
            
            sharedDataSingleton.outbox.removeAtIndex(indexPath.row)
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            deleteTaskIndexPath = nil
            tableView.endUpdates()
            
        }
    }
    
    func cancelDelete(alertAction: UIAlertAction!) {
        deleteTaskIndexPath = nil
    }
    
   
}
