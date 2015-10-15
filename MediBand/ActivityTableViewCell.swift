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
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var emptyLabel: UILabel!
    @IBOutlet var specialityLabel: UILabel!
    @IBOutlet var resolutionLabel: UILabel!
    @IBOutlet var activityTypeLabel: UILabel!
    @IBOutlet var careActivityLabel: UILabel!
    
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
        cardView.backgroundColor = sharedDataSingleton.theme
        
    }
    


}
