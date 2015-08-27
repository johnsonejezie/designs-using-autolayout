//
//  ViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/5/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate {
    
    var isExistingPatient:Bool = false
    var isStartingSession:Bool = false

    let session:AVCaptureSession = AVCaptureSession()
    var previewLayer:AVCaptureVideoPreviewLayer!
    var highlightView:UIView = UIView()
    var patientID: String = ""
    
    @IBAction func slideMenuToggle(sender: UIBarButtonItem) {
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //resizable view
        self.highlightView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
        
        //Border Colour for completed scan reticle
        self.highlightView.layer.borderColor = UIColor.redColor().CGColor
        self.highlightView.layer.borderWidth = 2
        self.view.addSubview(self.highlightView)
        
        // For the sake of discussion this is the camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Create a nilable NSError to hand off to the AVCaptureDeviceInput.deviceInputWithDevice method below.
        var error : NSError? = nil
        
        
        let input : AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as? AVCaptureDeviceInput
        
        if input != nil {
            session.addInput(input)
        }else {
            println(error)
        }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as! AVCaptureVideoPreviewLayer
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        //start scan
//        session.startRunning()
        
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
            let message:String = "Patient ID is \(detectionString)"
            
            let alertView: UIAlertView = UIAlertView(title:"Alert", message: message, delegate: self, cancelButtonTitle:"Scan Again")
            alertView.addButtonWithTitle("Continue")
            alertView.delegate = self
            alertView.show()
        }
    }
    
    func showAlertForPatientScan() {

        let alertView = SCLAlertView()
        alertView.addButton("EXISTING PATIENT", actionBlock: { () -> Void in
            println("existing")
            self.isExistingPatient = true
            self.isStartingSession = true
            self.session.startRunning()
        })
        alertView.addButton("NEW PATIENT", actionBlock: { () -> Void in
            println("new")
            self.isExistingPatient = false
            self.isStartingSession = true
            self.session.startRunning()
        })
        alertView.showEdit(self, title: "Patient", subTitle: "Existing or New Patient?", closeButtonTitle: "CANCEL", duration: 2000)
        
        alertView.alertIsDismissed { () -> Void in
            if self.isStartingSession == true {
            }else{
                self.isExistingPatient = false
               self.performSegueWithIdentifier("ExistingPatient", sender: self.isExistingPatient)
            }
            
        }
        
        
        
    }
    
    
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        println("scan again button clicked")
        if buttonIndex == 1 {
            if isExistingPatient == false {
                 sharedDataSingleton.selectedPatient = nil
                self.performSegueWithIdentifier("patientSegue", sender: patientID)
            }else {
                self.performSegueWithIdentifier("ExistingPatient", sender: isExistingPatient)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "patientSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! AddPatientViewController
            controller.patientID = sender as! String
        }else if segue.identifier == "ExistingPatient" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! PatientsViewController
            controller.isExistingPatient = sender as! Bool
            controller.patientID = patientID
        }
    }




}

