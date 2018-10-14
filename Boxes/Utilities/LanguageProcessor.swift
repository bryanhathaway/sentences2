//
//  LanguageProcessor.swift
//  Boxes
//
//  Created by Bryan Hathaway on 1/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation

class LanguageProcessor {
    static func words(from string: String) -> [String] {
        let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .lexicalClass], options: 0)
        tagger.string = string

        let range = NSRange(location: 0, length: string.utf16.count)

        // How to use tagger.tags instead?
        var words = [String]()
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: []) { (tag, tokenRange, stop) in
            let word = (string as NSString).substring(with: tokenRange)
            words.append(word)
        }

        return words
    }
}
