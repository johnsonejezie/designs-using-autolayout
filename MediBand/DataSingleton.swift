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
    var user:User!
    var patients:[Patient] = []
    var selectedPatient:Patient!
    var allStaffs = [Staff]()
    var selectedStaff:Staff!
    var tasks = [Task]()
    var patientHistory = [Task]()
    var staffHistory = [Task]()
    var isCheckingNewPatientID:Bool = true
    var staffTask = [Task]()
    var patientTask = [Task]()
    var patientID:String = ""
    var selectedIDs = [String]()
    var isEditingProfile = false
}

let sharedDataSingleton = DataSingleton()


