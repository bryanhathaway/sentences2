//
//  Configuration.swift
//  Boxes
//
//  Created by Bryan Hathaway on 17/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class Configuration: Codable {

    // MARK: Font
    var fontName: String? = UIFont.defaultFont.fontName

    // MARK: 
    var isTapToSpeakEnabled: Bool = false

    var isReadOnlyMode: Bool = false
}


extension Configuration {
    func font(ofSize size: CGFloat) -> UIFont {
        guard let fontName = fontName else { return .systemFont(ofSize: size) }
        return UIFont(name: fontName, size: size) ?? .systemFont(ofSize: size)
    }

    var font: UIFont? {
        get { return UIFont(name: fontName ?? "", size: 20.0) }
        set { fontName = newValue?.fontName }
    }
}
