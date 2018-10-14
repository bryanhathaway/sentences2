//
//  Sentence.swift
//  Boxes
//
//  Created by Bryan Hathaway on 1/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class Sentence: Codable, HexColorable {
    var title: String

    /// This is the fully compiled sentence with punctuation and spacing as it was originally typed.
    /// This is because the conversion to Phrases loses context of these and cannot be easily joined again.
    var compiledSentence: String

    var phrases: [Phrase]

    var colorHex: String?

    init(title: String = "", compiledSentence: String = "", phrases: [Phrase] = [], color: UIColor = Theme.accent) {
        self.title = title
        self.phrases = phrases
        self.compiledSentence = compiledSentence
        colorHex = color.toHexString
    }
}

extension Sentence {
    func update(with sentence: Sentence) {
        title = sentence.title
        compiledSentence = sentence.compiledSentence
        phrases = sentence.phrases
        colorHex = sentence.colorHex
    }
}
