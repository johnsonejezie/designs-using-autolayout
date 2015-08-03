//
//  LoginViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/14/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    var tap:UITapGestureRecognizer!

    
    @IBOutlet weak var userNameTextfield: UITextField!
    

    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextfield.layer.cornerRadius = 5
        passwordTextfield.layer.cornerRadius = 5
        loginButton.layer.cornerRadius = 4
        
        tap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        setScreeName("LoginView")
        
    }
    
    func handleSingleTap(sender:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }


    @IBAction func loginActionButton() {
        
        let parameters = [
           "email": userNameTextfield.text,
            "password": passwordTextfield.text,
            "medical_facility_id": 4
        ]
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let url = "http://www.iconglobalnetwork.com/mediband/api/login"
        
        Alamofire.request(.POST, url, parameters: (parameters as! [String : AnyObject]), encoding: .JSON, headers: headers).responseJSON { request, response, json, error in
           
            
            if (error != nil) {
                println(error)
            }else {
                var jsonObject: JSON = JSON(json!)
                println(jsonObject)
                let message = jsonObject["message"].stringValue
                if message == "Invalid email or password" {
                    let alertView = UIAlertView(title: "Login Error", message: "Invalid email or password", delegate: self, cancelButtonTitle: "Cancel")
                        alertView.delegate = self
                        alertView.show()
                    
                    println(message)
                }
            }
            
//            if let message:String = (JSON as! NSDictionary).valueForKey("message") as? String {
//                let alertView = UIAlertView(title: "Login Error", message: "Invalid email or password", delegate: self, cancelButtonTitle: "Cancel")
//                alertView.delegate = self
//                alertView.show()
//            }
        }
        println(parameters)
//        self.performSegueWithIdentifier("showActivities", sender: nil)
        
    }
    
    
    @IBAction func forgotPasswordActionButton() {
        
        let alertController = UIAlertController(title: "Reset Password", message: "Enter your email", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "RESET", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)

        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Email"
            textField.keyboardType = .EmailAddress
        }
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    

}

extension LoginViewController {
    
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
//        tracker.send(trackDictionary)
    }
    
}


