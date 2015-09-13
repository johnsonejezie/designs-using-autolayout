//
//  CaseNoteTableViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/11/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import SwiftSpinner

class CaseNoteTableViewController: UITableViewController, UIViewControllerTransitioningDelegate, caseDetailsControllerDelegate {

    
    @IBOutlet var navBar: UIBarButtonItem!
    var caseNoteDetails = ""
    var task: Task!
    var caseNotes = [CaseNote]()
    @IBAction func addCaseNote(sender: AnyObject) {
        
        performSegueWithIdentifier("caseDetail", sender: nil)
        
        println("add new note")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 120
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setScreeName("Case Notes View")
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
            cell.dateLabel.text = caseNote.created
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
        let alertView = SCLAlertView()
        alertView.showEdit(self, title: "Case Note Detail", subTitle: detail, closeButtonTitle: "CANCEL", duration: 20000)
    }
    
    
    func createCaseNote(task_id:String) {
        SwiftSpinner.show("Creating Case Note", animated: true)
        let caseNote = CaseNote()
        caseNote.task_id = task_id
        caseNote.staff_id = sharedDataSingleton.user.id
        caseNote.details = self.caseNoteDetails
        let caseNoteAPI = CaseNoteAPI()
        caseNoteAPI.createCaseNote(caseNote, callback: { (createdCaseNote, error) -> () in
            if error == nil {
                let newCaseNote:CaseNote = (createdCaseNote as? CaseNote)!
                self.caseNotes.append(newCaseNote)
                self.tableView.reloadData()
                SwiftSpinner.hide(completion: { () -> Void in
                })
            }else {
                
            }
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "caseDetail" {
            let toViewController = segue.destinationViewController as! CaseDetailViewController
            toViewController.transitioningDelegate = self
            toViewController.delegate = self
            toViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        }
    }
    
    func caseDetailsController(controller: CaseDetailViewController, filledInDetails details: String) {
        self.caseNoteDetails = details
        self.createCaseNote(self.task.id)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        var animationPresentationController = AnimationPresentationController()
        
        animationPresentationController.isPresenting = true
        
        return animationPresentationController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var animationPresentationController = AnimationPresentationController()
        return animationPresentationController
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
