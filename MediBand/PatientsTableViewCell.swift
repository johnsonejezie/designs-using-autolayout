//
//  PatientsTableViewCell.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/15/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit


class PatientsTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet var patientImageView: UIImageView!
    @IBOutlet weak var patientNameLabel: UILabel!

    @IBOutlet weak var patientIDLabel: UILabel!
    
    @IBOutlet var emptyLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var generalPhysicianLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        cardSetup()
    }
    
    func cardSetup() {
        patientImageView.layer.cornerRadius = patientImageView.frame.size.height/2
        patientImageView.clipsToBounds = true
        cardView.alpha = 1
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 10
        
    }
    

}
