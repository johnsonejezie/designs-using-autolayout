//
//  CaseNoteTableViewCell.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/11/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class CaseNoteTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var cardView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cardSetup() {
        cardView.alpha = 1
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 25
        cardView.layer.shadowOffset = CGSizeMake(-0.2, 0.2)
        cardView.layer.shadowRadius = 1
        
        let path:UIBezierPath = UIBezierPath(rect: self.cardView.bounds)
        cardView.layer.shadowPath = path.CGPath
        cardView.layer.shadowOpacity = 0.2
        
    }

}
