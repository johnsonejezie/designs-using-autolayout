//
//  LoginViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/14/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftSpinner
import SwiftKeychainWrapper
import SwiftValidator


class LoginViewController: UIViewController, UITextFieldDelegate, ValidationDelegate {
    
    var tap:UITapGestureRecognizer!
    let validator = Validator()
    var resetKeychain:Bool = false;
    var keyboardPresented = false;
    
    @IBOutlet weak var userNameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emailString: String? = KeychainWrapper.stringForKey("email")
        let passwordString: String? = KeychainWrapper.stringForKey("password")
        
        if (emailString != nil && passwordString != nil) {
           login(emailString!, password: passwordString!)
        }
            
        userNameTextfield.layer.cornerRadius = 5
        passwordTextfield.layer.cornerRadius = 5
        loginButton.layer.cornerRadius = 4
        
        tap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        setUpValidator()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

    }
    
    override func viewWillAppear(animated: Bool) {
        setScreeName("LoginView")
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func setUpValidator(){
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
            validationRule.errorLabel?.hidden = true
            validationRule.errorLabel?.text = ""
            validationRule.textField.layer.borderColor = UIColor.greenColor().CGColor
            validationRule.textField.layer.borderWidth = 0.5
            
            }, error:{ (validationError) -> Void in
                print("error")
                validationError.errorLabel?.hidden = false
                validationError.errorLabel?.text = validationError.errorMessage
                validationError.textField.layer.borderColor = UIColor.redColor().CGColor
                validationError.textField.layer.borderWidth = 1.0
        })
        
        validator.registerField(userNameTextfield, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passwordTextfield, rules: [RequiredRule(), FullNameRule()])
    }
    
    func handleSingleTap(sender:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }


    @IBAction func loginActionButton() {
        validator.validate(self)
        trackEvent("UX", action: "login button clicked", label: "login button", value: nil)
    }
    
    func validationSuccessful() {
        resetKeychain = true
        login(userNameTextfield.text!, password: passwordTextfield.text!)
    }
    
    func login(email:String, password:String) {
        if !Reachability.connectedToNetwork() {
            let alertView = SCLAlertView()
            alertView.showEdit(self, title: "Network Failure", subTitle: "Device is not connected to any network", closeButtonTitle: "Cancel", duration: 2000)
            return
        }
        SwiftSpinner.show("Connecting...", animated: true)
        let login = Login()
        login.loginUserWith(email, andPassword: password) { (success) -> Void in
            print("successful \(success)")
            if success == true {
                if self.resetKeychain == true {
                    let saveSuccessful: Bool = KeychainWrapper.setString(self.passwordTextfield.text!, forKey: "password")
                    let saveSuccessful1: Bool = KeychainWrapper.setString(self.userNameTextfield.text!, forKey: "email")
                    print("\(saveSuccessful) and \(saveSuccessful1)")
                }
                print(sharedDataSingleton.user.is_password_set)
                if sharedDataSingleton.user.is_password_set == false {
                    SwiftSpinner.hide({ () -> Void in
                        self.loadResetPasswordAlert()
                    })
                }else {
                    SwiftSpinner.hide(nil)
                    self.performSegueWithIdentifier("LoginTOHome", sender: nil)
                }
//
            }else {
                print("error")
                let removeEmailSuccessful: Bool = KeychainWrapper.removeObjectForKey("email")
                let removePasswordSuccessful: Bool = KeychainWrapper.removeObjectForKey("password")
                SwiftSpinner.hide(nil)
                let alertView = SCLAlertView()
                alertView.showError(self, title: "Login Error", subTitle: "Invalid email or password", closeButtonTitle: "Cancel", duration: 2000)
            }
        }
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        setErrors()
    }
    
    private func setErrors(){
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.redColor().CGColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.hidden = false
        }
    }
    
    func loadResetPasswordAlert(){
        let alertView = SCLAlertView()
        let emailTextField: UITextField = alertView.addTextField("email")
        let oldPasswordTextField: UITextField = alertView.addTextField("old password")
        let newPasswordTextField: UITextField = alertView.addTextField("new password")
        alertView.addButton("Reset", validationBlock: { () -> Bool in
            let passedValidation:Bool = !emailTextField.text!.isEmpty && !oldPasswordTextField.text!.isEmpty && !newPasswordTextField.text!.isEmpty
            return passedValidation
        }) { () -> Void in
            print("validated")
            self.resetPassword(emailTextField.text!, oldPassword: oldPasswordTextField.text!, newPassword: newPasswordTextField.text!)
        }
        alertView.showEdit(self, title: "Password Reset", subTitle: "", closeButtonTitle: "Cancel", duration: 2000)
        
        alertView.alertIsDismissed { () -> Void in
//             self.performSegueWithIdentifier("LoginToPatients", sender: nil)
        }

    }
    
    func resetPassword(email: String, oldPassword: String, newPassword: String) {
        SwiftSpinner.show("Resetting Password", animated: true)
        let loginAPI = Login()
        loginAPI.resetPassword(email, oldPassword: oldPassword, newPassword: newPassword) { (success) -> Void in
            if success == true {
                SwiftSpinner.show("loading patient", animated: true)
                self.performSegueWithIdentifier("LoginToHome", sender: nil)
            }else {
                
            }
        }
    }
    

    
    
    @IBAction func forgotPasswordActionButton() {
        
        let alertController = UIAlertController(title: "Reset Password", message: "Enter your email", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "RESET", style: .Default) { (action) in
            // ...
            self.trackEvent("UX", action: "Reset password", label: "Forgot password button", value: nil)
        }
        alertController.addAction(OKAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action) -> Void in
            //....
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Email"
            textField.keyboardType = .EmailAddress
        }
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if self.keyboardPresented == true {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height/2
            self.keyboardPresented = true
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height/2
            self.keyboardPresented = false
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
        tracker.send(trackDictionary as [NSObject: AnyObject])
    }
    
}


