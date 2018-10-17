//
//  PersistenceHelper.swift
//  Boxes
//
//  Created by Bryan Hathaway on 5/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation

enum PersistenceHelperError: Error {
    case fileNotAccessible
}

/// A helper class that manages the saving, reading, and converting of Folder data.
class PersistenceHelper {
    /// The default PersistenceHelper that reads default example Folders packaged with the app Bundle.
    static let `default` = PersistenceHelper(fileName: Constants.defaultDataFileName,
                                             fileExtension: Constants.defaultDataFileType)

    /// A PersistenceHelper that saves and reads to a standard JSON file.
    static let userStorage = PersistenceHelper(fileNameWithExtension: Constants.savedDataFileName)

    private var fileURL: URL?

    /// Initializes a PersistenceHelper that is pointed to a file in the app's document directory.
    init(fileNameWithExtension: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        fileURL = paths.first?.appendingPathComponent(fileNameWithExtension)
    }

    /// Initializes a PersistenceHelper that is pointed to a file in the app's bundle.
    init(bundle: Bundle = Bundle.main, fileName: String, fileExtension: String) {
        guard let file = bundle.path(forResource: fileName,
                                          ofType: fileExtension) else {
                                           return
        }

        fileURL = URL(fileURLWithPath: file)
    }

    // MARK: -

    /// Saves the folders to the PersistenceHelper's JSON file.
    func save(folders: [Folder]) throws {
        guard let fileURL = fileURL else { throw PersistenceHelperError.fileNotAccessible }

        let encoded = try JSONEncoder().encode(folders)
        try encoded.write(to: fileURL)

    }

    /// Reads the folders from the PersistenceHelper's JSON file.
    func read() throws -> [Folder]  {
        guard let fileURL = fileURL else { throw PersistenceHelperError.fileNotAccessible }

        let data = try Data(contentsOf: fileURL)
        let object = try JSONDecoder().decode([Folder].self, from: data)

        return object
    }
}
