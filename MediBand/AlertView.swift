//
//  AlertView.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/26/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class AlertView {
    let alertView = SCLAlertView()
    
    func showErrorAlertWithTitle(title:String, andMessage message:String, andCloseButtonTitle closeButton:String) {
       alertView.showError(title, subTitle: message, closeButtonTitle: closeButton, duration: 200)
    }
    
}
