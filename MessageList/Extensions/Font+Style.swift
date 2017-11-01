//
//  Font+Style.swift
//  MessageList
//
//  Created by Richard Adem on 31/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit

extension UIFont {
    class func headingFont() -> UIFont {
        return mediumFont(ofSize: 14)
    }
    
    class func subTitleFont() -> UIFont {
        return regularFont(ofSize: 12)

    }
    
    class func contentFont() -> UIFont {
        return regularFont(ofSize: 14)
    }
    
    private class func mediumFont(ofSize fontSize: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Roboto-Medium", size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize, weight: .medium)
        }
        return font
    }
    private class func regularFont(ofSize fontSize: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Roboto-Regular", size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize, weight: .regular)
        }
        return font
    }
}
