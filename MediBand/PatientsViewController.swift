//
//  PatientsViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/15/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class PatientsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, addPatientControllerDelegate {
    
    var patient = [Patient]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("patientsCell") as! PatientsTableViewCell
        
        cell.patientNameLabel.text = "Mr FRED PATRICK"
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("ViewPatient", sender: nil)
    }
    
    func addPatientViewController(controller: AddPatientViewController, didFinishedAddingPatient patient: NSDictionary) {
        println(patient)
    }
    
    @IBAction func addPatientBarButton(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("AddPatient", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddPatient" {
            let navigationController = segue.destinationViewController
                as! UINavigationController
            let controller = navigationController.topViewController
                as! AddPatientViewController
            controller.delegate = self
        }
    }

}
