//
//  ActivitySegmentControl.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/27/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class ActivitySegmentControl: UISegmentedControl {

    @IBInspectable var allowReselection: Bool = true
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let previousSelectedSegmentIndex = self.selectedSegmentIndex
        super.touchesEnded(touches, withEvent: event)
        if allowReselection && previousSelectedSegmentIndex == self.selectedSegmentIndex {
            if let touch = touches.first {
                let touchLocation = touch.locationInView(self)
                if CGRectContainsPoint(bounds, touchLocation) {
                    self.sendActionsForControlEvents(.ValueChanged)
                }
            }
        }
    }

}
