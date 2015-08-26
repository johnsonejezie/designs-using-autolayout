//
//  StaffTableViewCell.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/26/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class StaffTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var staffImageView: UIImageView!
    @IBOutlet weak var staffNameLabel: UILabel!

    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var staffIDLabel: UILabel!
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
        
        cardView.alpha = 1
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 5
        
        staffImageView.clipsToBounds = true
        staffImageView.layer.cornerRadius = staffImageView.frame.size.height/2
        
    }

}
