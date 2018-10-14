//
//  Folder.swift
//  Boxes
//
//  Created by Bryan Hathaway on 1/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class Folder: Codable, HexColorable {
    var title: String?
    var sentences: [Sentence] = []

    var colorHex: String?

    init() {
        colorHex = Theme.accent.toHexString
    }

    init(title: String, sentences: [Sentence], color: UIColor) {
        self.title = title
        self.sentences = sentences
        colorHex = color.toHexString
    }
}
