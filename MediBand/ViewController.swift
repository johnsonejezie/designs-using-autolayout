//
//  ViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/5/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import SwiftSpinner
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate {
    
    var isExistingPatient:Bool = false
    var isStartingSession:Bool = false

    let session:AVCaptureSession = AVCaptureSession()
    var previewLayer:AVCaptureVideoPreviewLayer!
    var highlightView:UIView = UIView()
    var patientID: String = ""
    
    @IBOutlet var navBar: UIBarButtonItem!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ((self.revealViewController()) != nil){
            self.navBar.target = self.revealViewController()
            self.navBar.action = "revealToggle:"
        }
        
        //resizable view
        self.highlightView.autoresizingMask = [UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
        
        //Border Colour for completed scan reticle
        self.highlightView.layer.borderColor = UIColor.redColor().CGColor
        self.highlightView.layer.borderWidth = 2
        self.view.addSubview(self.highlightView)
        
        // For the sake of discussion this is the camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Create a nilable NSError to hand off to the AVCaptureDeviceInput.deviceInputWithDevice method below.
        let error : NSError? = nil
        
        
//        let input : AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(device) as? AVCaptureDeviceInput
        let input : AVCaptureDeviceInput? = try! AVCaptureDeviceInput(device: device)
        
        if input != nil {
            session.addInput(input)
        }else {
            print(error)
        }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer)        
        self.showAlertForPatientScan()
        
        
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        var highlighViewRect = CGRectZero
        var barCodeObject: AVMetadataObject!
        var detectionString: String!
        
        let barcodeTypes = [AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode93Code,
            AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code,
            AVMetadataObjectTypeQRCode,
            AVMetadataObjectTypeAztecCode
        ]
        
        for metadataObject in metadataObjects {
            for barcodeType in barcodeTypes {
                if metadataObject.type == barcodeType {
                    
                    barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadataObject as! AVMetadataMachineReadableCodeObject)
                    highlighViewRect = barCodeObject.bounds
                    
                    detectionString = (metadataObject as! AVMetadataMachineReadableCodeObject).stringValue
                    self.session.stopRunning()
                    break
                    
                }
            }
        }
        
        self.highlightView.frame = highlighViewRect
        self.view.bringSubviewToFront(self.highlightView)
        if detectionString != nil {
            patientID = detectionString
            sharedDataSingleton.patientID = self.patientID
            let message:String = "Patient ID is \(detectionString)"
            
            let alertView = SCLAlertView()
            alertView.addButton("CONTINUE", actionBlock: { () -> Void in
                if self.isExistingPatient == false {
                    sharedDataSingleton.selectedPatient = nil
                    self.performSegueWithIdentifier("patientSegue", sender: self.patientID)
                }else {
                    SwiftSpinner.show("Searching for patient", animated: true)
                    let patientAPI = PatientAPI()
                    patientAPI.getPatient(self.patientID, fromMedicalFacility: sharedDataSingleton.user.clinic_id, completionHandler: { (scannedPatient:Patient?, error:NSError?) -> () in
                            if let aPatient:Patient = scannedPatient {
                                 SwiftSpinner.hide()
                                sharedDataSingleton.selectedPatient = aPatient
                                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("PatientProfileViewController") as! PatientProfileViewController
                                controller.patient = sharedDataSingleton.selectedPatient
                                self.navigationController?.pushViewController(controller, animated: true)
                            }
                           else {
                             SwiftSpinner.hide()
                           let alertView1 = SCLAlertView()
                            alertView1.showEdit(self, title: "Notice", subTitle: "Patient doesn't exist", closeButtonTitle: "Cancel", duration: 20000)
                                alertView1.alertIsDismissed({ () -> Void in
                                    self.performSegueWithIdentifier("GoToHomeView", sender: nil)
                                })                        }
                        
                    })
                    
                }
            })
            alertView.addButton("CANCEL", actionBlock: { () -> Void in
                self.performSegueWithIdentifier("GoToHomeView", sender: nil)
            })
            alertView.showEdit(self, title: "Scan Completed", subTitle: message, closeButtonTitle: nil, duration: 2000)
        }
    }
    
    func showAlertForPatientScan() {

        let alertView = SCLAlertView()

        
        alertView.addButton("EXISTING PATIENT", actionBlock: { () -> Void in
            print("existing")
            self.isExistingPatient = true
            self.isStartingSession = true
            self.session.startRunning()
        })
        alertView.addButton("NEW PATIENT", actionBlock: { () -> Void in
            print("new")
            self.isExistingPatient = false
            self.isStartingSession = true
            self.session.startRunning()
        })
        alertView.addButton("CANCEL", actionBlock: { () -> Void in
            self.performSegueWithIdentifier("GoToHomeView", sender: nil)
        })
        alertView.showEdit(self, title: "Patient", subTitle: "Existing or New Patient?", closeButtonTitle: nil, duration: 2000)
        
        alertView.alertIsDismissed { () -> Void in
//                self.isExistingPatient = false
        }
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        print("scan again button clicked")
        if buttonIndex == 1 {
            if isExistingPatient == false {
                 sharedDataSingleton.selectedPatient = nil
                self.performSegueWithIdentifier("patientSegue", sender: patientID)
            }else {
                self.performSegueWithIdentifier("patientSegue", sender: isExistingPatient)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "patientSegue" {
           SwiftSpinner.hide(nil)
            let navigationController = segue.destinationViewController as! UINavigationController
           
            let controller = navigationController.topViewController as! NewPatientViewController
            controller.patientID = self.patientID
            
        }
//            else if segue.identifier == "ExistingPatient" {
//            let navigationController = segue.destinationViewController as! UINavigationController
//            let controller = navigationController.topViewController as! PatientsViewController
//            controller.isExistingPatient = sender as! Bool
//            controller.patientID = patientID
//        }
    }




}

