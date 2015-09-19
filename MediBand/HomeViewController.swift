//
//  HomeViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 9/17/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import Haneke

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var adminContent = [
        ["title":"Task", "image":"task"],
        ["title":"Patients", "image":"patient"],
        ["title":"New Patients", "image":"newPatient"],
        ["title":"Staff", "image":"staff"],
        ["title":"Profile", "image":"profile"],
        ["title":"Settings", "image":"setting"],
        ["title":"Outbox", "image":"outbox"]
    ]
    
    var nonAdminContent = [
        ["title":"Task", "image":"task"],
        ["title":"Patients", "image":"patient"],
        ["title":"New Patients", "image":"newPatient"],
        ["title":"Profile", "image":"profile"],
        ["title":"Settings", "image":"setting"],
        ["title":"Outbox", "image":"outbox"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if sharedDataSingleton.user.isAdmin == true {
            return adminContent.count
//        }else {
//            return nonAdminContent.count
//        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cellTitle: String = ""
        let content = adminContent[indexPath.row]
//        if sharedDataSingleton.user.isAdmin == true {
            cellTitle = content["title"]!
//        }else {
//            cellTitle = nonAdminContent[indexPath.row]
//        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("homeCollectionCell", forIndexPath: indexPath) as! HomeCollectionViewCell
//        cell.view.backgroundColor = UIColor.greenColor()
        cell.titleLabel.text = cellTitle
        
        cell.iconImageView.image = UIImage(named: content["image"]!)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(120, 130)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0;
    }


}
