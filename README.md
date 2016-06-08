# BODropdownMenu

Custom drop down menu for iOS Applications.

![alt tag](https://raw.githubusercontent.com/olbartek/BODropdownMenu/master/BODropdownMenu/dropdown.gif)

## 1.1 Configuration

```
dropDownMenu.elements = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7"]
dropDownMenu.delegate = self
```

## 1.2 Customization

```
// Colors & Border
dropDownMenu.menuViewBackgroundColor        = UIColor.grayColor()
dropDownMenu.borderVisible                  = true
dropDownMenu.separatorVisible               = true
dropDownMenu.menuViewBorderWidth            = 1
dropDownMenu.menuViewBorderColor            = UIColor.whiteColor()
dropDownMenu.menuViewCornerRadius           = 5
dropDownMenu.menuLabelTintColor             = UIColor.whiteColor()
dropDownMenu.menuLabelBackgroundColor       = UIColor.clearColor()
dropDownMenu.menuLabelFont                  = UIFont.systemFontOfSize(17)
        
// Shadow
dropDownMenu.shadowVisible                  = true
dropDownMenu.menuViewShadowOffset           = CGSize(width: -5, height: 5)
dropDownMenu.menuViewShadowRadius           = 5
dropDownMenu.menuViewShadowOpacity          = 0.5
        
// Animation
dropDownMenu.animateWithDamping             = true
dropDownMenu.animationDuration              = 0.5
dropDownMenu.animationDamping               = 0.6
dropDownMenu.animationVelocity              = 0.5
        
// Cells' configuration
dropDownMenu.menuViewCellHeight             = 40
dropDownMenu.menuViewCellSeparatorColor     = UIColor.whiteColor()
dropDownMenu.menuViewCellTextColor          = UIColor.whiteColor()
dropDownMenu.menuViewCellFont               = UIFont(name: "HelveticaNeue", size: 15)!
dropDownMenu.menuViewCellSelectionColor     = UIColor.clearColor()
            
// Arrow Image
//dropDownMenu.arrowImage =
dropDownMenu.arrowVisible                   = true

```
