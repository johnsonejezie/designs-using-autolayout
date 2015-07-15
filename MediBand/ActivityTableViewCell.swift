//
//  ActivityTableViewCell.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/15/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var cardView: UIView!
    
    
    @IBOutlet weak var exerciseLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var pharmacyLabel: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        cardSetup()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cardSetup() {
        cardView.alpha = 1
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 10
        
    }
    


}
