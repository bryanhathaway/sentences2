//
//  UIFont+AppFonts.swift
//  Boxes
//
//  Created by Bryan Hathaway on 18/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    class var openDyslexic: UIFont {
        let size = Box.compactFontSize
        return UIFont(name: "OpenDyslexic-Regular", size: size) ?? UIFont.defaultFont
    }

    class var defaultFont: UIFont {
        return .systemFont(ofSize: Box.compactFontSize)
    }
}
