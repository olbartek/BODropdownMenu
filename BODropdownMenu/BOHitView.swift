//
//  BOHitView.swift
//  BODropdownMenu
//
//  Created by Bartosz Olszanowski on 26.11.2015.
//
//

import UIKit

class BOHitView: UIView {
    
    //MARK: Properites
    var dropdownMenu: BODropdownMenu?
    
    //MARK: Actions
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if let dropdownMenu = dropdownMenu {
            let (isPoint, pointForTargetView) = dropdownMenu.isPoint(point, withinTableViewBoundsFromReferencingView: self)
            if  isPoint {
                if let pointForTargetView = pointForTargetView {
                    return dropdownMenu.hitTest(pointForTargetView, withEvent: event)
                }
            }
        }
        return super.hitTest(point, withEvent: event)
    }
    
}
