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
    
    let session:AVCaptureSession = AVCaptureSession()
    var previewLayer:AVCaptureVideoPreviewLayer!
    var highlightView:UIView = UIView()
    

    
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
        session.startRunning()
        
        
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
        println(detectionString)
        
        if detectionString != nil {
            
            let message:String = "Your code is \(detectionString)"
            
            let alertView: UIAlertView = UIAlertView(title:"Alert", message: message, delegate: self, cancelButtonTitle:"Scan Again")
            alertView.delegate = self
            alertView.show()
        }
        
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        println("scan again button clicked")
    }




}

