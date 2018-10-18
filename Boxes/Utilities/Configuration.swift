//
//  Configuration.swift
//  Boxes
//
//  Created by Bryan Hathaway on 17/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class Configuration {

    var font: UIFont = UIFont.preferredFont(forTextStyle: .body)
    func font(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: font.fontName, size: size) ?? .systemFont(ofSize: size)
    }

    var isTapToSpeakEnabled: Bool = false

    var defaultBoxColor: UIColor = Theme.Box.background
}
