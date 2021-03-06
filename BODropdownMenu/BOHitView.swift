//
//  BOHitView.swift
//  BODropdownMenu
//
//  Created by Bartosz Olszanowski on 26.11.2015.
//
//

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
