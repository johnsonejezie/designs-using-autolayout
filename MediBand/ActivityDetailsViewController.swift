//
//  ActivityDetailsViewController.swift
//  MediBand
//
//  Created by Kehinde Shittu on 7/25/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class ActivityDetailsViewController: UIViewController , UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate, menuViewControllerDelegate, ENSideMenuDelegate{

    var currentCell : Int = 1;
    @IBOutlet var attendingProfButton: UIButton!
    @IBOutlet var updateActivityButton: UIButton!
    @IBOutlet var viewCaseNoteButton: UIButton!
    @IBOutlet var viewPatientButton: UIButton!
    @IBOutlet var patientProfilePic: UIImageView!
    @IBOutlet var attendingProfCollectionView: UICollectionView!
    var usersImage: [String] = ["HS1","HS5","HS6"]
    var usersName: [String] = ["Ben Francis","Ruth Osteen","Daniel Doug"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.sideMenuController()?.sideMenu?.delegate = self
        self.attendingProfButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.attendingProfButton.titleLabel?.numberOfLines = 1;
        self.attendingProfButton.layer.cornerRadius = 5.0;
        self.updateActivityButton.layer.cornerRadius = 5.0;
        self.viewCaseNoteButton.layer.cornerRadius = 5.0;
        self.viewPatientButton.layer.cornerRadius = 5.0;
        self.attendingProfCollectionView.dataSource = self
        self.attendingProfCollectionView.delegate = self
    }


    @IBAction func slideMenuToggle(sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    
    override func viewWillLayoutSubviews() {
        self.patientProfilePic.layer.borderWidth = 1.0;
        self.patientProfilePic.layer.borderColor = UIColor.blackColor().CGColor;
        self.patientProfilePic.layer.cornerRadius = self.patientProfilePic.layer.frame.height/2;
        //        userImageView.maskView = ;
        self.patientProfilePic.clipsToBounds = true
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: AnyObject = self.attendingProfCollectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let userImageView: UIImageView! = cell.viewWithTag(1001) as! UIImageView;
        let userLabel = cell.viewWithTag(1002 ) as! UILabel;
         var image: UIImage = UIImage(named: self.usersImage[indexPath.row])!
        userImageView.image = image
        userImageView.layer.borderWidth = 1.0;
        userImageView.layer.borderColor = UIColor.blackColor().CGColor;
        userImageView.layer.cornerRadius = userImageView.layer.frame.width/2;
        userImageView.clipsToBounds = true
        userLabel.text = self.usersName[indexPath.row]
        return cell as! UICollectionViewCell
    }
    @IBAction func update(sender: UIButton) {
        
//        var menuView: MenuViewController = MenuViewController() as! MenuViewController
//        menuView.delegate = self
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        var menuViewController: MenuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        menuViewController.delegate = self
        menuViewController.selectedCell = currentCell
        menuViewController.modalPresentationStyle = .Popover
        menuViewController.preferredContentSize = CGSizeMake(self.view.frame.height/4, self.view.frame.height/3)
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = self.view
        popoverMenuViewController?.sourceRect = CGRect(
            x: self.updateActivityButton.layer.frame.origin.x+self.updateActivityButton.layer.frame.size.width/2-(self.view.frame.height/4)/2,
            y: self.updateActivityButton.layer.frame.origin.y+self.updateActivityButton.layer.frame.size.height/2,
            width: 1,
            height: 1)
        presentViewController(
            menuViewController,
            animated: true,
            completion: nil)
    }
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
    
    
    
    @IBAction func viewPatientActionButton() {
        
        self.performSegueWithIdentifier("viewPatient", sender: nil)
    }
    
    
    @IBAction func viewCaseNote() {
        self.performSegueWithIdentifier("viewCaseNote", sender: nil)
    }
    
    func menuViewResponse(controller: MenuViewController,
        didDismissPopupView selectedCell: Int){
            currentCell = selectedCell;
            println("choice is \(currentCell)")
    }

    
}
