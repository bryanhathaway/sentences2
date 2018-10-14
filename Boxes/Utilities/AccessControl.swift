//
//  AccessControl.swift
//  Boxes
//
//  Created by Bryan Hathaway on 12/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation

class AccessControl {
    private struct Key {
        static let readOnly = "ReadOnlyKey"
    }

    static var isReadOnly: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AccessControl.Key.readOnly)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AccessControl.Key.readOnly)
        }
    }
}
