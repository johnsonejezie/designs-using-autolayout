//
//  DataSingleton.swift
//  MediBand
//
//  Created by Johnson Ejezie on 8/9/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class DataSingleton {
    
    var medical_facility:String = ""
    var allStaffs = [Staff]();
}

let sharedDataSingleton = DataSingleton()