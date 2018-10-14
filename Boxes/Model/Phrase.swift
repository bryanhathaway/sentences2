//
//  Phrase.swift
//  Boxes
//
//  Created by Bryan Hathaway on 1/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class Phrase: Codable, HexColorable {
    var value: String
    var colorHex: String?

    init(value: String, color: UIColor = Theme.Box.background) {
        self.value = value
        self.colorHex = color.toHexString
    }
}
