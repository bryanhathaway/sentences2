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
        return UIFont(name: "OpenDyslexic-Regular", size: 16.0) ?? .systemFont(ofSize: 16.0)
    }
}
