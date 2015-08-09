//
//  StaffProfileViewController.swift
//  MediBand
//
//  Created by Kehinde Shittu on 7/7/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class StaffProfileViewController: UIViewController, ENSideMenuDelegate {
    
    
    @IBOutlet weak var staffImageView: UIImageView!
    @IBOutlet weak var staffNameLabel: UILabel!
    
    @IBOutlet weak var staffIDLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var generlPracticeLabel: UILabel!
    @IBOutlet weak var generalPractitionerIDLabel: UILabel!
    var staff: Dictionary<String, String>!
    
    
    @IBAction func slideMenuToggle(sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.sideMenuController()?.sideMenu?.delegate = self
        
//        let imageData:NSData = NSData(base64EncodedString: staff["staffImage"]!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
//        staffImageView.image = UIImage(data: imageData)
//        staffIDLabel.text = staff["staffID"]
//        staffNameLabel.text = staff["name"]
//        generalPractitionerIDLabel.text = staff["generalPractitionerID"]
//        generlPracticeLabel.text = staff["generalPracticeID"]
//        specialityLabel.text = staff["speciality"]

    }
    
    override func viewDidLayoutSubviews() {
        staffImageView.clipsToBounds = true
        staffImageView.layer.cornerRadius = staffImageView.frame.size.height/2
    }



}
