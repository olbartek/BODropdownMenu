//
//  BODropdownMenu.swift
//  BODropdownMenu
//
//  Created by Bartosz Olszanowski on 05.11.2015.
//  Copyright (c) 2015 Bartosz Olszanowski. All rights reserved.
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

//MARK: Constants
private struct Constants {
    static let TextMargin               : CGFloat = 10
    static let ViewInitialHeight        = 40
    static let ViewInitialWidth         = 150
}

//MARK: BODropdownMenuDelegate
public protocol BODropdownMenuDelegate {
    func menuWillShow(menu: BODropdownMenu)
    func menuDidShow(menu: BODropdownMenu)
    func menuWillHide(menu: BODropdownMenu)
    func menuDidHide(menu: BODropdownMenu)
    func menu(menu: BODropdownMenu, didSelectElementAtIndexPath indexPath: NSIndexPath)
}

//MARK: BODropdownMenu
public class BODropdownMenu: UIView {
    
    //MARK: Public Properties
    
    // Elements of menu view
    public var elements                             : [String]! {
        didSet {
            if let actionButton = actionButton, menuVC = menuVC {
                if elements.count > 0 {
                    actionButton.setTitle(self.elements.first, forState: .Normal)
                    menuVC.elements = elements
                }
                
            }
        }
    }
    
    // Delegate
    public var delegate                             : BODropdownMenuDelegate?
    
    // The color of menu background. Default: grayColor()
    public var menuViewBackgroundColor              : UIColor! {
        get {
            return self.configuration.MenuViewBackgroundColor
        }
        set(value) {
            self.configuration.MenuViewBackgroundColor = value
            self.configureActionButtonAppearance()
        }
    }
    
    // The border width of menu view. Default: 1
    public var menuViewBorderWidth                  : CGFloat! {
        get {
            return self.configuration.MenuViewBorderWidth
        }
        set(value) {
            self.configuration.MenuViewBorderWidth = value
            self.configureActionButtonAppearance()
            self.configureSeparatorViewAppearance()
        }
    }
    
    // Enable/Disable border of menu view. Default: true
    public var borderVisible                        : Bool {
        get {
            return self.configuration.MenuViewBorderVisible
        }
        set(value) {
            self.configuration.MenuViewBorderVisible = value
            self.configureActionButtonAppearance()
            self.configureSeparatorViewAppearance()
            self.menuVC?.configureTableViewAppearance()
        }
    }
    
    // Enable/Disable separator view separating title and arrow. Default: true
    public var separatorVisible                        : Bool {
        get {
            return self.configuration.MenuViewSeparatorVisible
        }
        set(value) {
            self.configuration.MenuViewSeparatorVisible = value
            self.configureSeparatorViewAppearance()
            self.menuVC?.configureTableViewAppearance()
        }
    }
    
    // The border color of menu view. Default: whiteColor()
    public var menuViewBorderColor                  : UIColor! {
        get {
            return self.configuration.MenuViewBorderColor
        }
        set(value) {
            self.configuration.MenuViewBorderColor = value
            self.configureActionButtonAppearance()
            self.configureSeparatorViewAppearance()
        }
    }
    
    // The radius of menu view. Default: 5
    public var menuViewCornerRadius                 : CGFloat! {
        get {
            return self.configuration.MenuViewCornerRadius
        }
        set(value) {
            self.configuration.MenuViewCornerRadius = value
            self.configureActionButtonAppearance()
        }
    }
    
    // The color of menu label title. Default is whiteColor()
    public var menuLabelTintColor                    : UIColor! {
        get {
            return self.configuration.MenuLabelTintColor
        }
        set(value) {
            self.configuration.MenuLabelTintColor = value
            self.configureActionButtonAppearance()
        }
    }
    
    // The color of menu label background. Default is grayColor()
    public var menuLabelBackgroundColor               : UIColor! {
        get {
            return self.configuration.MenuLabelBackgroundColor
        }
        set(value) {
            self.configuration.MenuLabelBackgroundColor = value
            self.configureActionButtonAppearance()
        }
    }
    
    // The color of menu label background. Default is system font, size: 17
    public var menuLabelFont                        : UIFont! {
        get {
            return self.configuration.MenuLabelFont
        }
        set(value) {
            self.configuration.MenuLabelFont = value
            self.configureActionButtonAppearance()
        }
    }
    
    // Enable/Disable menu view shadow. Default: true
    public var shadowVisible                        : Bool {
        get {
            return self.configuration.MenuViewShadowVisible
        }
        set(value) {
            self.configuration.MenuViewShadowVisible = value
            menuVC?.configureTableViewAppearance()
        }
    }
    
    // The shadow offset of menu view. Default: (-5,5)
    public var menuViewShadowOffset                 : CGSize! {
        get {
            return self.configuration.MenuViewShadowOffset
        }
        set(value) {
            self.configuration.MenuViewShadowOffset = value
            menuVC?.configureTableViewAppearance()
        }
    }
    
    // The shadow radius of menu view. Default: 5
    public var menuViewShadowRadius                 : CGFloat! {
        get {
            return self.configuration.MenuViewShadowRadius
        }
        set(value) {
            self.configuration.MenuViewShadowRadius = value
            menuVC?.configureTableViewAppearance()
        }
    }
    
    // The shadow opacity of menu view. Default: 0.5
    public var menuViewShadowOpacity                 : Float! {
        get {
            return self.configuration.MenuViewShadowOpacity
        }
        set(value) {
            self.configuration.MenuViewShadowOpacity = value
            menuVC?.configureTableViewAppearance()
        }
    }
    
    // Enable/Disable damping animation
    public var animateWithDamping                   : Bool {
        get {
            return self.configuration.AnimateWithDamping
        }
        set(value) {
            self.configuration.AnimateWithDamping = value
        }
    }
    
    // Menu view animation duration, Default: 0.5
    public var animationDuration                   : NSTimeInterval! {
        get {
            return self.configuration.AnimationDuration
        }
        set(value) {
            self.configuration.AnimationDuration = value
        }
    }
    
    // Menu view damping, Default: 0.6
    public var animationDamping                   : CGFloat! {
        get {
            return self.configuration.Damping
        }
        set(value) {
            self.configuration.Damping = value
        }
    }
    
    // Menu view velocity, Default: 0.5
    public var animationVelocity                  : CGFloat! {
        get {
            return self.configuration.Velocity
        }
        set(value) {
            self.configuration.Velocity = value
        }
    }
    
    // The cell hieght of menu view. Default: height of dropdown menu frame
    public var menuViewCellHeight                 : CGFloat! {
        get {
            return self.configuration.CellHeight
        }
        set(value) {
            self.configuration.CellHeight = value
            self.menuVC?.tableView.endUpdates()
            self.menuVC?.tableView.reloadData()
        }
    }
    
    // The cell separator color. Default: blackColor()
    public var menuViewCellSeparatorColor         : UIColor! {
        get {
            return self.configuration.CellSeparatorColor
        }
        set(value) {
            self.configuration.CellSeparatorColor = value
            self.configureSeparatorViewAppearance()
        }
    }
    
    // The cell text color. Default: whiteColor()
    public var menuViewCellTextColor              : UIColor! {
        get {
            return self.configuration.CellTextLabelColor
        }
        set(value) {
            self.configuration.CellTextLabelColor = value
            self.menuVC?.tableView.endUpdates()
            self.menuVC?.tableView.reloadData()
        }
    }
    
    // The cell text font. Default: system font, size: 15
    public var menuViewCellFont                   : UIFont! {
        get {
            return self.configuration.CellTextLabelFont
        }
        set(value) {
            self.configuration.CellTextLabelFont = value
            self.menuVC?.tableView.endUpdates()
            self.menuVC?.tableView.reloadData()
        }
    }
    
    // The cell selection color. Default: clearColor()
    public var menuViewCellSelectionColor         : UIColor! {
        get {
            return self.configuration.CellSelectionColor
        }
        set(value) {
            self.configuration.CellSelectionColor = value
            self.menuVC?.tableView.endUpdates()
            self.menuVC?.tableView.reloadData()
        }
    }
    
    // The arrow image. Default: default arrow image from bundle
    public var arrowImage                         : UIImage! {
        get {
            return self.configuration.ArrowImage
        }
        set(value) {
            self.configuration.ArrowImage = value
            self.configureMenuArrowAppearance()
        }
    }
    
    // The arrow visibility. Default: true
    public var arrowVisible                       : Bool {
        get {
            return self.configuration.ArrowVisible
        }
        set(value) {
            self.configuration.ArrowVisible = value
            self.configureMenuArrowAppearance()
        }
    }
    
    // Mask background color. Default: blackColor()
    public var maskBackgroundColor                 : UIColor! {
        get {
            return self.configuration.MaskBackgroundColor
        }
        set(value) {
            self.configuration.MaskBackgroundColor = value
            
        }
    }
    
    // Mask background opacity. Default: 0.3
    public var maskBackgroundOpacity               : CGFloat! {
        get {
            return self.configuration.MaskBackgroundOpacity
        }
        set(value) {
            self.configuration.MaskBackgroundOpacity = value
        }
    }
    
    //MARK: Private Properties
    private var menuVC                              : BOMenuViewController?
    private var actionButton                        : UIButton!
    private var menuHidden                          = true
    private var currentSelectedIndexPath            = NSIndexPath(forRow: 0, inSection: 0)
    private var menuArrow                           : UIImageView!
    private var configuration                       = BOConfiguration()
    private var separatorView                       : UIView?
    
    //MARK: Initialization
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.elements = []
        defaultSetup()
    }
    
    public init(elements: [String]) {
        super.init(frame: CGRect(x: 0, y: 0, width: Constants.ViewInitialWidth, height: Constants.ViewInitialHeight))
        if let superview = superview {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.constrain(.CenterX, .Equal, superview, .CenterX, constant: 0, multiplier: 1)?.constrain(.CenterY, .Equal, superview, .CenterY, constant: 0, multiplier: 1)
        }
        self.elements = elements
        defaultSetup()
    }
    
    //MARK: Appearance
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: Actions
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if let menuVC = menuVC {
            var pointForTargetView = point
            if !menuHidden { pointForTargetView.y += self.bounds.size.height }
            print("\(pointForTargetView)")
            if CGRectContainsPoint(menuVC.tableView.bounds, pointForTargetView) {
                if (pointForTargetView.y <= self.bounds.size.height) {
                    return actionButton.hitTest(pointForTargetView, withEvent: event)
                } else {
                    return menuVC.tableView.hitTest(point, withEvent: event)
                }
            } else if CGRectContainsPoint(menuVC.tableView.bounds, point) {
                return menuVC.tableView.hitTest(point, withEvent: event)
            }
        }
        return super.hitTest(point, withEvent: event)
    }
    
    //MARK: Configuration
    private func defaultSetup() {
        self.configuration.CellHeight = self.frame.size.height
        
        configureActionButton()
        configureMenuArrow()
        configureMenuVC()
    }
    
    //MARK: Private functions
    private func configureActionButton() {
        actionButton = UIButton(frame: CGRectZero)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionButton)
        guard let superview                                 = actionButton.superview else {
            assert(false, "ActionButton adding to superview failed.")
            return
        }
        // Constraints
        actionButton.constrain(.Leading, .Equal, superview, .Leading, constant: 0, multiplier: 1)?.constrain(.Trailing, .Equal, superview, .Trailing, constant: 0, multiplier: 1)?.constrain(.Top, .Equal, superview, .Top, constant: 0, multiplier: 1)?.constrain(.Bottom, .Equal, superview, .Bottom, constant: 0, multiplier: 1)
        // Appearance
        configureActionButtonAppearance()
        // Actions
        actionButton.addTarget(self, action: #selector(BODropdownMenu.menuAction(_:)), forControlEvents: .TouchUpInside)
    }
    
    private func configureActionButtonAppearance() {
        actionButton.setTitleColor(configuration.MenuLabelTintColor, forState: .Normal)
        actionButton.titleLabel?.font                       = configuration.MenuLabelFont
        actionButton.backgroundColor                        = configuration.MenuLabelBackgroundColor
        actionButton.opaque                                 = false
        actionButton.contentHorizontalAlignment             = .Left
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: Constants.TextMargin, bottom: 0, right: 0)
        if configuration.MenuViewBorderVisible {
            actionButton.layer.cornerRadius                 = configuration.MenuViewCornerRadius
            actionButton.layer.borderColor                  = configuration.MenuViewBorderColor.CGColor
            actionButton.layer.borderWidth                  = configuration.MenuViewBorderWidth
            actionButton.clipsToBounds                      = true
        } else {
            actionButton.layer.cornerRadius                 = configuration.MenuViewCornerRadius
            actionButton.layer.borderColor                  = UIColor.clearColor().CGColor
            actionButton.layer.borderWidth                  = 0
            actionButton.clipsToBounds                      = true
        }
    }
    
    private func configureMenuArrow() {
        menuArrow                                           = UIImageView(frame: CGRectZero)
        menuArrow.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addSubview(menuArrow)
        guard let superview = actionButton.superview else {
            assert(false, "MenuArrow adding to superview failed.")
            return
        }
        // Constraints
        menuArrow.constrain(.Trailing, .Equal, superview, .Trailing, constant: 0, multiplier: 1)?.constrain(.Top, .Equal, superview, .Top, constant: 0, multiplier: 1)?.constrain(.Bottom, .Equal, superview, .Bottom, constant: 0, multiplier: 1)?.constrain(.Width, .Equal, menuArrow, .Height, constant: 0, multiplier: 1)
        // Appearance
        configureMenuArrowAppearance()
    }
    
    private func configureMenuArrowAppearance() {
        if configuration.ArrowVisible && menuArrow != nil {
            menuArrow.image                                     = self.configuration.ArrowImage
            if configuration.MenuViewBorderVisible {
                configureSeparatorView()
            }
        } else {
            menuArrow.removeFromSuperview()
            menuArrow = nil
        }
        
    }
    
    private func configureSeparatorView() {
        if separatorView == nil {
            separatorView = UIView(frame: CGRectZero)
            guard let separatorView = separatorView else {
                return
            }
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            actionButton.addSubview(separatorView)
            guard let separatorSuperview = separatorView.superview else {
                assert(false, "SeparatorView adding to superview failed.")
                return
            }
            // Constraints
            separatorView.constrain(.Top, .Equal, separatorSuperview, .Top, constant: 0, multiplier: 1)?.constrain(.Bottom, .Equal, separatorSuperview, .Bottom, constant: 0, multiplier: 1)?.constrain(.Width, .Equal, constant: 1)
            if let menuArrowView = menuArrow {
                let relationConstraint = NSLayoutConstraint(item: separatorView, attribute: .Trailing, relatedBy: .Equal, toItem: menuArrowView, attribute: .Leading, multiplier: 1, constant: 0)
                actionButton.addConstraint(relationConstraint)
            }
            // Appearance
            configureSeparatorViewAppearance()
        }
    }
    
    private func configureSeparatorViewAppearance() {
        
        if let separatorView = separatorView {
            if configuration.MenuViewBorderVisible {
                if configuration.MenuViewSeparatorVisible {
                    separatorView.backgroundColor                           = self.configuration.MenuViewBorderColor
                } else {
                    separatorView.removeFromSuperview()
                    self.separatorView = nil
                }
                
            } else {
                separatorView.removeFromSuperview()
                self.separatorView = nil
            }
        }
    }
    
    private func configureMenuVC() {
        menuVC = BOMenuViewController(elements: elements, configuration: configuration)
        guard let menuVC = menuVC else {
            return
        }
        menuVC.delegate                                         = self
        menuVC.view.translatesAutoresizingMaskIntoConstraints   = false
        
        addSubview(menuVC.view)
        guard let menuViewSuperview = menuVC.view.superview else {
            assert(false, "MenuView adding to superview failed.")
            return
        }
        // Constraints
        menuVC.view.constrain(.Trailing, .Equal, menuViewSuperview, .Trailing, constant: 0, multiplier: 1)?.constrain(.Top, .Equal, menuViewSuperview, .Bottom, constant: 0, multiplier: 1)?.constrain(.Leading, .Equal, menuViewSuperview, .Leading, constant: 0, multiplier: 1)
        menuVC.tvHeightConstraint = NSLayoutConstraint(item: menuVC.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0)
        menuVC.view.addConstraint(menuVC.tvHeightConstraint)
    }
    
    //MARK: Public functions
    public func setMenuTitle(title: String) {
        actionButton.setTitle(title, forState: .Normal)
    }
    
    public func showMenu() {
        menuAction(nil)
    }
    
    public func hideMenu() {
        menuAction(nil)
    }
    
    public func showOrHideMenu() {
        menuAction(nil)
    }
    
    public func isMenuHidden() -> Bool {
        return menuHidden
    }
    
    public func isPoint(point: CGPoint, withinTableViewBoundsFromReferencingView view: UIView) -> (isPoint: Bool, pointForTargetView: CGPoint?) {
        if let menuVC = menuVC {
            if !self.isMenuHidden() {
                let pointForTargetView = menuVC.tableView.convertPoint(point, fromView: view)
                let wrapperFrame = CGRect(origin: CGPoint(x: 0, y: -self.bounds.size.height), size: CGSize(width: menuVC.tableView.bounds.size.width, height: menuVC.tableView.bounds.size.height + self.bounds.size.height))
                return (CGRectContainsPoint(wrapperFrame, pointForTargetView), pointForTargetView)
            }
        }
        return (false, nil)
    }
    
    //MARK: Animations
    @IBAction public func menuAction(sender: UIButton?) {
        guard let menuVC = menuVC else {
            return
        }
        if menuHidden {
            menuVC.tableView.reloadData()
            rotateArrow()
            showMenuWithCompletionBlock() { (succeeded: Bool) -> Void in
                if succeeded {
                    self.delegate?.menuDidShow(self)
                    self.menuHidden = false
                }
            }
        } else {
            rotateArrow()
            hideMenuWithCompletionBlock() { (succeeded: Bool) -> Void in
                if succeeded {
                    self.delegate?.menuDidHide(self)
                    self.menuHidden = true
                }
            }
        }
    }
    
    private func showMenuWithCompletionBlock(completion: (succeeded: Bool) -> Void) {
        guard let menuVC = menuVC else {
            completion(succeeded: false)
            return
        }
        delegate?.menuWillShow(self)
        let tvHeight                                   = configuration.CellHeight * CGFloat(elements.count)
        menuVC.tvHeightConstraint.constant             = tvHeight
        
        if animateWithDamping {
            UIView.animateWithDuration(configuration.AnimationDuration, delay: 0, usingSpringWithDamping: configuration.Damping, initialSpringVelocity: configuration.Velocity, options: .CurveEaseInOut, animations: { () -> Void in
                menuVC.view.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    if finished {
                        completion(succeeded: true)
                        
                    }
            })
        } else {
            UIView.animateWithDuration(configuration.AnimationDuration, animations: { () -> Void in
                menuVC.view.layoutIfNeeded()
                }) { (finished) -> Void in
                    if finished {
                        completion(succeeded: true)
                    }
            }
        }
    }
    
    private func hideMenuWithCompletionBlock(completion: (succeeded: Bool) -> Void) {
        guard let menuVC = menuVC else {
            completion(succeeded: false)
            return
        }
        delegate?.menuWillHide(self)
        menuVC.tvHeightConstraint.constant          = 0
        
        if animateWithDamping {
            UIView.animateWithDuration(configuration.AnimationDuration, delay: 0, usingSpringWithDamping: configuration.Damping, initialSpringVelocity: configuration.Velocity, options: .CurveEaseInOut, animations: { () -> Void in
                menuVC.view.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    if finished {
                        completion(succeeded: true)
                    }
            })
        } else {
            UIView.animateWithDuration(configuration.AnimationDuration, animations: { () -> Void in
                menuVC.view.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    if finished {
                        completion(succeeded: true)
                    }
            })
        }
    }
    
    private func performRowSelectionForIndexPath(indexPath: NSIndexPath) {
        currentSelectedIndexPath = indexPath
        actionButton.setTitle(elements[indexPath.row], forState: .Normal)
        rotateArrow()
        hideMenuWithCompletionBlock { [weak self] (succeeded: Bool) -> Void in
            if succeeded {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.delegate?.menuDidHide(strongSelf)
                strongSelf.menuHidden = true
            }
        }
    }
    
    private func rotateArrow() {
        if configuration.ArrowVisible && menuArrow != nil {
            UIView.animateWithDuration(self.configuration.AnimationDuration) { [weak self] () -> () in
                if let strongSelf = self {
                    strongSelf.menuArrow.transform = CGAffineTransformRotate(strongSelf.menuArrow.transform, 180 * CGFloat(M_PI / 180))
                }
            }
        }
    }
    
}

extension BODropdownMenu: BOMenuViewControllerDelegate {
    private func tableView(tableView: UITableView, didSelectElementAtIndexPath indexPath: NSIndexPath) {
        delegate?.menu(self, didSelectElementAtIndexPath: indexPath)
        performRowSelectionForIndexPath(indexPath)
    }
}

//MARK: BODropdownMenuDelegate
private protocol BOMenuViewControllerDelegate {
    func tableView(tableView: UITableView, didSelectElementAtIndexPath indexPath: NSIndexPath)
}

private class BOMenuViewController: UIViewController {
    
    //MARK: Properties
    var tableView               : BOTableView!
    var configuration           : BOConfiguration
    var tvHeightConstraint      : NSLayoutConstraint!
    var elements                : [String] {
        didSet {
            if elements.count > 0 {
                tableView.reloadData()
            }
        }
    }
    var delegate                : BOMenuViewControllerDelegate?
    
    //MARK: Initialization
    required init(elements: [String], configuration: BOConfiguration) {
        self.elements = elements
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: VC's Lifecycle
    private override func viewDidLoad() {
        configureTableView()
    }
    
    //MARK: Configuration
    private func configureTableView() {
        
        // Create tableView
        tableView                                           = BOTableView(frame: CGRectZero, items: elements, configuration: configuration)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate                                  = self
        tableView.dataSource                                = self
        view.addSubview(tableView)
        
        // Appearance
        if let _ = tableView {
            configureTableViewAppearance()
        }

        //Constraints
        guard let tableViewSuperview = tableView.superview else {
            assert(false, "TableView adding to superview failed.")
            return
        }
        tableView.constrain(.Trailing, .Equal, tableViewSuperview, .Trailing)?.constrain(.Top, .Equal, tableViewSuperview, .Top)?.constrain(.Leading, .Equal, tableViewSuperview, .Leading)?.constrain(.Bottom, .Equal, tableViewSuperview, .Bottom)
    }
    
    private func configureTableViewAppearance() {
        if configuration.MenuViewShadowVisible {
            view.layer.shadowOffset         = configuration.MenuViewShadowOffset
            view.layer.shadowRadius         = configuration.MenuViewShadowRadius
            view.layer.shadowOpacity        = configuration.MenuViewShadowOpacity
        } else {
            view.layer.shadowOffset         = CGSize(width: 0, height: -3)
            view.layer.shadowRadius         = 3
            view.layer.shadowOpacity        = 0
        }
        if configuration.MenuViewBorderVisible {
            tableView.layer.cornerRadius             = configuration.MenuViewCornerRadius
            tableView.layer.borderColor              = configuration.MenuViewBorderColor.CGColor
            tableView.layer.borderWidth              = configuration.MenuViewBorderWidth
        } else {
            tableView.layer.cornerRadius             = configuration.MenuViewCornerRadius
            tableView.layer.borderColor              = UIColor.clearColor().CGColor
            tableView.layer.borderWidth              = 0
        }
    }
    
}

//MARK: UITableView delegate & datasource
extension BOMenuViewController: UITableViewDelegate, UITableViewDataSource {
    @objc private func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    @objc private func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = BODropdownMenuCell(style: .Default, reuseIdentifier: BODropdownMenuCell.boCellIdentifier(), configuration: self.configuration)
        
        cell.textLabel?.text                        = self.elements[indexPath.row]
        cell.textLabel?.textAlignment               = .Left
        cell.textLabel?.textColor                   = self.configuration.CellTextLabelColor
        cell.textLabel?.font                        = self.configuration.CellTextLabelFont
        cell.contentView.backgroundColor            = self.configuration.MenuViewBackgroundColor
        
        let cellSelectionColor                      = self.configuration.CellSelectionColor
        if cellSelectionColor.isEqual(UIColor.clearColor()) {
            cell.selectionStyle = .None
        } else {
            let bgView                                  = UIView()
            bgView.backgroundColor                      = self.configuration.CellSelectionColor
            cell.selectedBackgroundView                 = bgView
        }
        cell.lineView.backgroundColor                   = self.configuration.CellSeparatorColor
        return cell
    }
   @objc private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.configuration.CellHeight
    }
   @objc private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let delegate = delegate {
            delegate.tableView(tableView, didSelectElementAtIndexPath: indexPath)
        }
    }
    @objc private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
}

// MARK: BOConfiguration
private class BOConfiguration {
    
    var MenuViewBackgroundColor             : UIColor!
    var MenuViewCornerRadius                : CGFloat!
    var MenuViewBorderVisible               : Bool
    var MenuViewSeparatorVisible            : Bool
    var MenuViewBorderWidth                 : CGFloat!
    var MenuViewBorderColor                 : UIColor!
    
    var MenuViewShadowVisible               : Bool
    var MenuViewShadowOffset                : CGSize!
    var MenuViewShadowRadius                : CGFloat!
    var MenuViewShadowOpacity               : Float!
    
    var MenuLabelTintColor                  : UIColor!
    var MenuLabelBackgroundColor            : UIColor!
    var MenuLabelFont                       : UIFont!
    
    var CellHeight                          : CGFloat!
    var CellSeparatorColor                  : UIColor!
    var CellTextLabelColor                  : UIColor!
    var CellTextLabelFont                   : UIFont!
    var CellSelectionColor                  : UIColor!
    
    var ArrowImage                          : UIImage!
    var ArrowVisible                        : Bool
    
    var AnimateWithDamping                  : Bool
    var AnimationDuration                   : NSTimeInterval!
    var Damping                             : CGFloat!
    var Velocity                            : CGFloat!
    
    var MaskBackgroundColor                 : UIColor!
    var MaskBackgroundOpacity               : CGFloat!
    
    init() {
        MenuViewBorderVisible       = true
        MenuViewShadowVisible       = true
        AnimateWithDamping          = true
        MenuViewSeparatorVisible    = true
        ArrowVisible                = true
        
        defaultValue()
    }
    
    func defaultValue() {

        // Arrow image
        let bundle                     = NSBundle(forClass: BODropdownMenu.self)
        let url                        = bundle.URLForResource("BODropdownMenu", withExtension: "bundle")
        let imageBundle                = NSBundle(URL: url!)
        let arrowImagePath             = imageBundle?.pathForResource("arrow", ofType: "png")
        ArrowImage                     = UIImage(contentsOfFile: arrowImagePath!)
        
        // Border & Colors
        MenuViewBackgroundColor        = UIColor.grayColor()
        MenuViewCornerRadius           = 5
        MenuViewBorderWidth            = 1
        MenuViewBorderColor            = UIColor.whiteColor()
        MenuLabelTintColor             = UIColor.whiteColor()
        MenuLabelBackgroundColor       = UIColor.grayColor()
        MenuLabelFont                  = UIFont.systemFontOfSize(17)
        
        // Shadow
        MenuViewShadowOffset           = CGSize(width: -5, height: 5)
        MenuViewShadowRadius           = 5
        MenuViewShadowOpacity          = 0.5
        
        // Cells' configuration
        CellSeparatorColor             = UIColor.blackColor()
        CellTextLabelColor             = UIColor.whiteColor()
        CellTextLabelFont              = UIFont.systemFontOfSize(15)
        CellSelectionColor             = UIColor.clearColor()
        CellHeight                     = 30
        
        // Animation
        AnimationDuration              = 0.5
        Damping                        = 0.6
        Velocity                       = 0.5
        
        // Masks
        MaskBackgroundColor            = UIColor.blackColor()
        MaskBackgroundOpacity          = 0.3
    }
}

//MARK: BODropdownMenuTVC
private class BODropdownMenuCell: UITableViewCell {
    var configuration       : BOConfiguration!
    var cellContentFrame    : CGRect!
    var lineView            : UIView!
    
    // MARK: Initialization
    init(style: UITableViewCellStyle, reuseIdentifier: String?, configuration: BOConfiguration) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configuration                          = configuration
        configureLineView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Appearance
    func configureLineView() {
        lineView = UIView(frame: CGRectZero)
        self.contentView.addSubview(lineView)
        guard let superview = lineView.superview else {
            assert(false, "LineView adding to superview failed.")
            return
        }
        // Constraints
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.constrain(.Trailing, .Equal, superview, .Trailing)?.constrain(.Leading, .Equal, superview, .Leading)?.constrain(.Bottom, .Equal, superview, .Bottom)
        let heightConstraint = NSLayoutConstraint(item: lineView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 1)
        lineView.addConstraint(heightConstraint)
    }
}

//MARK: UITableViewCell + CellIdentifier
extension UITableViewCell {
    class func boCellIdentifier() -> String! {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
}

//MARK: BOTableView
private class BOTableView: UITableView {
    
    // Public properties
    var configuration                           : BOConfiguration!
    
    // Private properties
    private var items                           : [String]!
    private var selectedIndexPath               : NSIndexPath!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(frame: CGRect, items: [String], configuration: BOConfiguration) {
        super.init(frame: frame, style: UITableViewStyle.Plain)
        
        self.items                              = items
        self.selectedIndexPath                  = NSIndexPath(forRow: 0, inSection: 0)
        self.configuration                      = configuration
        
        // Setup table view
        self.opaque                             = false
        self.backgroundView?.backgroundColor    = configuration.MenuViewBackgroundColor
        self.backgroundColor                    = configuration.MenuViewBackgroundColor
        self.scrollEnabled                      = false
        self.separatorStyle                     = .None
        
        if configuration.MenuViewBorderVisible {
            self.layer.cornerRadius             = configuration.MenuViewCornerRadius
            self.layer.borderColor              = configuration.MenuViewBorderColor.CGColor
            self.layer.borderWidth              = configuration.MenuViewBorderWidth
        }
        self.clipsToBounds                      = true
    }
}

// MARK: UIView + Constraints
extension UIView {
    /**
     :returns: true if v is in this view's super view chain
     */
    public func isSuper(v : UIView) -> Bool
    {
        var s: UIView? = self
        while (s != nil) {
            if(v == s) { return true }
            s = s?.superview
        }
        return false
    }
    
    public func constrain(attribute: NSLayoutAttribute, _ relation: NSLayoutRelation, _ otherView: UIView, _ otherAttribute: NSLayoutAttribute, constant: CGFloat = 0.0, multiplier : CGFloat = 1.0) -> UIView?
    {
        let c = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relation, toItem: otherView, attribute: otherAttribute, multiplier: multiplier, constant: constant)
        
        if isSuper(otherView) {
            otherView.addConstraint(c)
            return self
        }
        else if(otherView.isSuper(self) || otherView == self)
        {
            self.addConstraint(c)
            return self
        }
        assert(false)
        return nil
    }
    
    public func constrain(attribute: NSLayoutAttribute, _ relation: NSLayoutRelation, constant: CGFloat, multiplier : CGFloat = 1.0) -> UIView?
    {
        let c = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .NotAnAttribute, multiplier: multiplier, constant: constant)
        self.addConstraint(c)
        return self
    }
    
}