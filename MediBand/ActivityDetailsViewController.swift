//
//  ActivityDetailsViewController.swift
//  MediBand
//
//  Created by Kehinde Shittu on 7/25/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class ActivityDetailsViewController: UIViewController , UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{

    
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
      
        
        
        self.attendingProfButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.attendingProfButton.titleLabel?.numberOfLines = 1;
        self.attendingProfButton.layer.cornerRadius = 5.0;
        self.updateActivityButton.layer.cornerRadius = 5.0;
        self.viewCaseNoteButton.layer.cornerRadius = 5.0;
        self.viewPatientButton.layer.cornerRadius = 5.0;
//        self.attendingProfButton.titleLabel?.lineBreakMode = ;
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//        layout.itemSize = CGSize(width: 90, height: 120)
        
//        self.attendingProfCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.attendingProfCollectionView.dataSource = self
        self.attendingProfCollectionView.delegate = self
     
//        self.attendingProfCollectionView .registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        self.view.addSubview(self.attendingProfCollectionView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = self.attendingProfCollectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let userImageView: UIImageView! = cell.viewWithTag(1001) as! UIImageView;
        let userLabel = cell.viewWithTag(1002 ) as! UILabel;
         var image: UIImage = UIImage(named: self.usersImage[indexPath.row])!
         userImageView.image = image
        userImageView.layer.borderWidth = 1.0;
        userImageView.layer.borderColor = UIColor.blackColor().CGColor;
        userImageView.layer.cornerRadius = userImageView.layer.frame.width/2;
//        userImageView.maskView = ;
        userImageView.clipsToBounds = true
        userLabel.text = self.usersName[indexPath.row]
//        cell.backgroundColor = UIColor.orangeColor()
        return cell as! UICollectionViewCell
    }
    
    @IBAction func update(sender: UIButton) {
    }
    
    
    
    @IBAction func viewPatientActionButton() {
        
        self.performSegueWithIdentifier("viewPatient", sender: nil)
    }
    
    
    @IBAction func viewCaseNote() {
    }
}
