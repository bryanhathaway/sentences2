//
//  Theme.swift
//  Boxes
//
//  Created by Bryan Hathaway on 4/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    static let background: UIColor = #colorLiteral(red: 0.1254901961, green: 0.1411764706, blue: 0.1529411765, alpha: 1)

    static let accent: UIColor = #colorLiteral(red: 0.3333333333, green: 0.9019607843, blue: 0.7568627451, alpha: 1)

    struct TextField {
        static let background: UIColor = #colorLiteral(red: 0.7939800127, green: 0.7939800127, blue: 0.7939800127, alpha: 0.2516855736)
        static let placeholder: UIColor = #colorLiteral(red: 0.6612400944, green: 0.6627302902, blue: 0.6854704763, alpha: 1)
    }

    struct Text {
        static let main: UIColor = #colorLiteral(red: 0.156783149, green: 0.156783149, blue: 0.156783149, alpha: 1)
        static let subtitle: UIColor = #colorLiteral(red: 0.3546733774, green: 0.3546733774, blue: 0.3546733774, alpha: 1)
    }

    struct Box {
        static let background: UIColor = #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.6, alpha: 1)
        static let text: UIColor = .white
        static let blurStyle: UIBlurEffect.Style = .dark
    }
}
