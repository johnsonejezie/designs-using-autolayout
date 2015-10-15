//
//  CaseNoteTableViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/11/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import SwiftSpinner

class CaseNoteTableViewController: UITableViewController, UIViewControllerTransitioningDelegate, addCaseControllerDelegate {

    
    @IBOutlet var navBar: UIBarButtonItem!
    var caseNoteDetails = ""
    var task: Task!
    var caseNotes = [CaseNote]()
    var currentPageNumber:Int = 1
    let caseNoteAPI = CaseNoteAPI()
    
    @IBAction func addCaseNote(sender: AnyObject) {
        
        performSegueWithIdentifier("AddCaseNote", sender: nil)
        
        print("add new note")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 120
    
    }
    
    override func viewWillAppear(animated: Bool) {
        UINavigationBar.appearance().barTintColor = sharedDataSingleton.theme
        self.setScreeName("Case Notes View")
        let pageNoToString:String = String(currentPageNumber)
        getCaseNote(task.id, staff_id: sharedDataSingleton.user.id, page: pageNoToString)
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var count = 1
        if caseNotes.count > 0 {
            count = caseNotes.count
        }
        return count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCellWithIdentifier("CaseCardCell", forIndexPath: indexPath) as! CaseNoteTableViewCell
        if caseNotes.count > 0 {
            let caseNote = caseNotes[indexPath.row]
            cell.nameLabel.text = caseNote.name
            
            var dateString = caseNote.created
            let subString = dateString.substringWithRange(Range<String.Index>(start: dateString.startIndex.advancedBy(0), end: dateString.endIndex.advancedBy(-9)))
            let formatter : NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = formatter.dateFromString(subString)
            formatter.dateFormat = "EEE, MMM d, yyyy"
            dateString = formatter.stringFromDate(date!)
            cell.dateLabel.text = dateString
            cell.nameLabel.hidden = false
            cell.dateLabel.hidden = false
            cell.addedByLabel.hidden = false
            cell.addedDateLabel.hidden = false
            cell.arrowImageView.hidden = false
            cell.caseNoteDetails.hidden = false
            cell.emptyLabel.hidden = true
        }else {
            cell.nameLabel.hidden = true
            cell.dateLabel.hidden = true
            cell.addedByLabel.hidden = true
            cell.addedDateLabel.hidden = true
            cell.arrowImageView.hidden = true
            cell.caseNoteDetails.hidden = true
            cell.emptyLabel.hidden = false
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let caseNote = self.caseNotes[indexPath.row]
        let detail:String = caseNote.details
        self.performSegueWithIdentifier("CaseNoteDetails", sender: detail);
//        let alertView = SCLAlertView()
//        alertView.showEdit(self, title: "Case Note Detail", subTitle: detail, closeButtonTitle: "CANCEL", duration: 20000)
    }
    
    
    func getCaseNote(task_id:String, staff_id:String, page:String) {
        if self.caseNotes.count == 0 {
            SwiftSpinner.show("Getting Case Notes", animated: true)
            caseNoteAPI.getCaseNotes(task_id, staff_id: staff_id, page: page) { (allCaseNotes, error) -> () in
                if error == nil {
                    let taskCaseNotes:[CaseNote] = (allCaseNotes as? [CaseNote])!
                    self.caseNotes = taskCaseNotes
                    self.tableView.reloadData()
                    SwiftSpinner.hide(nil)
                }else {
                    SwiftSpinner.hide(nil)
                    let alertView = SCLAlertView()
                    alertView.showError(self, title: "Error", subTitle: "Failed to load Case Notes", closeButtonTitle: "Cancel", duration: 2000)
                }
            }
        }else {
            caseNoteAPI.getCaseNotes(task_id, staff_id: staff_id, page: page) { (allCaseNotes, error) -> () in
                if error == nil {
                    let taskCaseNotes:[CaseNote] = (allCaseNotes as? [CaseNote])!
                    self.caseNotes = taskCaseNotes
                    self.tableView.reloadData()
                }else {
                  
                }
            }
        }

    }
    
    
    func createCaseNote(task_id:String) {
        let caseNote = CaseNote()
        caseNote.task_id = task_id
        caseNote.staff_id = sharedDataSingleton.user.id
        caseNote.details = self.caseNoteDetails
        if !Reachability.connectedToNetwork() {
            let dictionary: Dictionary<String, Any> = ["requestType": "createCaseNote", "caseNote": caseNote]
            sharedDataSingleton.outbox.append(dictionary)
            return
        }
        SwiftSpinner.show("Creating Case Note", animated: true)
        let caseNoteAPI = CaseNoteAPI()
        caseNoteAPI.createCaseNote(caseNote, callback: { (createdCaseNote, error) -> () in
            if error == nil {
                let newCaseNote:CaseNote = (createdCaseNote as? CaseNote)!
                self.caseNotes.append(newCaseNote)
                self.tableView.reloadData()
                SwiftSpinner.hide({ () -> Void in
                })
            }else {
                
            }
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddCaseNote" {
            let toViewController = segue.destinationViewController as! AddCaseViewController
            toViewController.transitioningDelegate = self
            toViewController.delegate = self
            toViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        }else if segue.identifier == "CaseNoteDetails" {
            let toViewController = segue.destinationViewController as! CaseDetailViewController
            toViewController.transitioningDelegate = self
            toViewController.caseNoteDetails = sender as! String
        }
    }
    
    func addCaseController(controller: AddCaseViewController, filledInDetails details: String) {
        self.caseNoteDetails = details
        self.createCaseNote(self.task.id)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animationPresentationController = AnimationPresentationController()
        
        animationPresentationController.isPresenting = true
        
        return animationPresentationController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationPresentationController = AnimationPresentationController()
        return animationPresentationController
    }
}

extension CaseNoteTableViewController {
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == (caseNotes.count - 1) {
            print("end of table")
            ++currentPageNumber
            let pageNoToString = String(currentPageNumber)
            print("page number \(pageNoToString)")
            caseNoteAPI.getCaseNotes(task.id, staff_id: sharedDataSingleton.user.id, page: pageNoToString) { (allCaseNotes, error) -> () in
                if error == nil {
                    let taskCaseNotes:[CaseNote] = (allCaseNotes as? [CaseNote])!
                    self.caseNotes += taskCaseNotes
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension CaseNoteTableViewController {
    
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
