//
//  OutboxViewController.swift
//  MediBand
//
//  Created by Ahmed Onawale on 10/1/15.
//  Copyright © 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class OutboxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var navBar: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        for (index, value) in sharedDataSingleton.outbox.enumerate() {
            let requestType = value["requestType"] as! String
            switch requestType {
                case "CreateStaff", "UpdateStaff":
                    createUpdateStaff(value["staff"] as! Staff, staffImage: value["image"] as! UIImage, isCreatingNewStaff: value["isCreatingNewStaff"] as! Bool, index: index)
                case "CreateTask":
                    createTask(value["task"] as! Task, index: index)
                case "CreateNewPatient":
                    print(value)
                    createPatient(value["patient"] as! Patient, fromMedicalFacility: value["fromMedicalFacility"] as! String, image: value["image"] as! UIImage, isCreatingNewPatient: value["isCreatingNewPatient"] as! Bool, index: index)
                case "UpdateTaskStatus":
                    updateTaskStatus(value["taskID"] as! String, userID: value["staffID"] as! String, resolutionID: value["resolutionID"] as! String, index: index)
                case "createCaseNote":
                    createCaseNote(value["caseNote"] as! CaseNote, index: index)
                default:
                    break
            }
        }
    }
    
    func createUpdateStaff(staff: Staff, staffImage: UIImage, isCreatingNewStaff: Bool, index: Int) {
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
                self.tableView.reloadData()
            }
        }
    }
    
    func createPatient(patient: Patient, fromMedicalFacility: String, image: UIImage, isCreatingNewPatient: Bool, index: Int) {
        PatientAPI().createNewPatient(patient, fromMedicalFacility: fromMedicalFacility, image: image, isCreatingNewPatient: isCreatingNewPatient) { [unowned self] in
            if $0 {
                sharedDataSingleton.outbox.removeAtIndex(index)
                self.tableView.reloadData()
            }
        }
    }

    func updateTaskStatus(taskID: String, userID: String, resolutionID: String, index: Int) {
        let taskAPI = TaskAPI()
        taskAPI.updateTaskStatus(taskID, staff_id: userID, resolution_id: resolutionID) { [unowned self] updatedTask, error in
            if error == nil {
                sharedDataSingleton.outbox.removeAtIndex(index)
                self.tableView.reloadData()
            }
        }
    }

    func createCaseNote(caseNote: CaseNote, index: Int) {
        CaseNoteAPI().createCaseNote(caseNote) { [unowned self] createdCaseNote, error in
            if error == nil {
                sharedDataSingleton.outbox.removeAtIndex(index)
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.target = self.revealViewController()
        navBar.action = "revealToggle:"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Outbox Cell") as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Outbox Cell")
        }
        cell.textLabel?.text = sharedDataSingleton.outbox[indexPath.row]["requestType"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedDataSingleton.outbox.count
    }

}
