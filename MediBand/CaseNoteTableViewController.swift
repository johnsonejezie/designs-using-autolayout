//
//  CaseNoteTableViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/11/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class CaseNoteTableViewController: UITableViewController, UIViewControllerTransitioningDelegate {

    
    @IBAction func addCaseNote(sender: AnyObject) {
        
        performSegueWithIdentifier("caseDetail", sender: nil)
        
        println("add new note")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 120
    
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CaseCardCell", forIndexPath: indexPath) as! CaseNoteTableViewCell
        
        cell.nameLabel.text = "Johnson"


        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "caseDetail" {
            let toViewController = segue.destinationViewController as! CaseDetailViewController
            toViewController.transitioningDelegate = self
            toViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        }
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
