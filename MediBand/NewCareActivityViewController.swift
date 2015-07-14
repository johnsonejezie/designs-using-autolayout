//
//  NewCareActivityViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/12/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit


 class NewCareActivityViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    var popCreated = false
    var dropdownloaded = false
    var dropDownFrame: CGRect!
    var pointY:CGFloat!
    
    var recognizer:UITapGestureRecognizer!

    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var addCaseNoteButton: UIButton!
    

    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func addCaseNoteAction() {
    }
    @IBAction func saveActionButton() {
    }
    
    
    @IBOutlet weak var selectSpecialistButton: UIButton!
    
    @IBOutlet weak var selectCareButton: UIButton!
    
    @IBOutlet weak var selectTypeButton: UIButton!
    
    @IBOutlet weak var selectCategoriesButton: UIButton!
    
    
    @IBOutlet weak var selectStaff: UIButton!
    
    
    @IBAction func selectActionButton(sender: UIButton!) {
        
        pointY = sender.frame.origin.y + sender.frame.size.height + self.navigationController!.navigationBar.frame.size.height + 22
        
        println(pointY)
        dropdownloaded = true
        
        
        var tag = sender.tag
        var frame = sender.frame
        
//        if tag == 1004 {
            self.performSegueWithIdentifier("popTable", sender: nil);
//        }else{
        
//            println(sender.center)
//            if !popCreated {
//                createPicker(tag)
//            }
//            picker.hidden ? openPicker(frame, center: sender.center) : closePicker()
//        }


        
    }
    
    func rotatePicker() {
        UIView.animateWithDuration(1.2, delay: 0.0, options: UIViewAnimationOptions.Repeat, animations:
            {
                // Rotate the picker here
                self.picker.transform = CGAffineTransformRotate(self.picker.transform, 6.28318530717959)
                
                // As the options are set to Repeat, there is no completion
            }, completion: nil)
    }
    
    
    let picker = UIImageView(image: UIImage(named: "picker"))
    
    struct properties {
        static let care = [
            ["title" : "the best"],
            ["title" : "really good"],
            ["title" : "okay"],
            ["title" : "meh"],
            ["title" : "not so great"],
            ["title" : "the worst"]
        ]
        
        static let specialist = [
            ["title" : "Dr Jack"],
            ["title" : "Dr Mayor Dan"],
            ["title" : "Dr Jennifer"],
            ["title" : "Mr Clark"],
            ["title" : "Fred Dapo"],
            ["title" : "Dr Who"]
        ]
        static let staff = [
            ["title" : "Mr Jack"],
            ["title" : "Mr Mayor Dan"],
            ["title" : "Mr Jennifer"],
            ["title" : "Mr Clark"],
            ["title" : "Mr Bayo Dapo"],
            ["title" : "Mr Larry"]
        ]
        static let categories = [
            ["title" : "Category1"],
            ["title" : "Category2"],
            ["title" : "Category3"],
            ["title" : "Category4"],
            ["title" : "Category5"],
            ["title" : "Category6"]
        ]
        
        static let type = [
            ["title" : "Type1"],
            ["title" : "Type2"],
            ["title" : "Type3"],
            ["title" : "Type4"],
            ["title" : "Type5"],
            ["title" : "Type6"]
        ]

    }
    
    
    func createPicker(tag:Int)
    {
        picker.frame = CGRect(x: ((self.view.frame.width / 2) - 143), y: 200, width: 286, height: 291)
        picker.alpha = 0
        picker.hidden = true
        picker.userInteractionEnabled = true
        var list = [Dictionary<String, String>()]

        
        if tag == 1000 {
            list = properties.specialist
        }else if tag == 1001 {
            list = properties.care
        }else if tag == 1002 {
            list = properties.type
        }else if tag == 1003 {
            list = properties.categories
        }else {
            list = properties.staff
        }
        
        var offset = 21
        
        for (index, feeling) in enumerate(list)
        {
            let button = UIButton()
            
            button.frame = CGRect(x: 13, y: offset, width: 260, height: 43)
            button.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.setTitle(feeling["title"], forState: .Normal)
            button.tag = index
            
            var buttonTitle = button.currentTitle
            
            button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
//            tableView.frame = picker.frame
            
            picker.addSubview(button)
            
            offset += 44
        }
        
        view.addSubview(picker)
        popCreated = true
    }
    
    
    func openPicker(frame:CGRect, center:CGPoint)
    {
        self.picker.hidden = false
        println(frame)
        
        let y = frame.origin.y + frame.size.height + self.navigationController!.navigationBar.frame.size.height + 22
        
        println(y)
        
        UIView.animateWithDuration(0.3,
            animations: {
                self.picker.frame = CGRect(x: ((self.view.frame.width / 2) - 143), y: y, width: 286, height: 291)
                self.rotatePicker()
                self.picker.alpha = 1
        })
    }
    
    func closePicker()
    {
        UIView.animateWithDuration(0.3,
            animations: {
                self.picker.frame = CGRect(x: ((self.view.frame.width / 2) - 143), y: 200, width: 286, height: 291)
                self.picker.alpha = 0
            },
            completion: { finished in
                self.picker.hidden = true
            }
        )
        popCreated = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

    func buttonPressed(sender:UIButton!) {
        
        println(sender.currentTitle)
        closePicker()
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popTable" {
            let toViewController = segue.destinationViewController as! PopUpTableViewController
            toViewController.transitioningDelegate = self
            toViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        var dropDownAnimation = AnimationPresentationController()
        
        dropDownAnimation.isPresenting = true
        dropDownAnimation.isPopUp = true
        dropDownAnimation.y = pointY
    
        
        return dropDownAnimation
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var dropDownAnimation = AnimationPresentationController()
        return dropDownAnimation
    }
    
    
}

extension UINavigationController {
    public override func supportedInterfaceOrientations() -> Int {
        if visibleViewController is NewCareActivityViewController {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        }
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }
}



