//
//  CaseNoteTableViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/11/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class CaseNoteTableViewController: UITableViewController, UIViewControllerTransitioningDelegate {

    
    @IBOutlet var navBar: UIBarButtonItem!
    @IBAction func addCaseNote(sender: AnyObject) {
        
        performSegueWithIdentifier("caseDetail", sender: nil)
        
        println("add new note")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 120
        
        navBar.target = self.revealViewController()
        navBar.action = Selector("revealToggle:")
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
