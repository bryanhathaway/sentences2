//
//  PersistenceHelper.swift
//  Boxes
//
//  Created by Bryan Hathaway on 5/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation

// This is just do allow us to use these static properties as they can't be attached to the generic class.
struct Persistence {
    /// The default PersistenceHelper that reads default example Folders packaged with the app Bundle.
    static let `default` = PersistenceHelper<[Folder]>(fileName: Constants.defaultDataFileName,
                                             fileExtension: Constants.defaultDataFileType)

    /// A PersistenceHelper that saves and reads Folders to a standard JSON file.
    static let userStorage = PersistenceHelper<[Folder]>(fileNameWithExtension: Constants.savedDataFileName)

    /// A PersistenceHelper that saves and reads Config to a standard JSON File
    /// This data is separate from userStorage as that data may be quite large and isn't required at app launch.
    static let configStorage = PersistenceHelper<Configuration>(fileNameWithExtension: Constants.savedConfigurationFileName)
}

enum PersistenceHelperError: Error {
    case fileNotAccessible
}

/// A helper class that manages the saving, reading, and converting of Folder data.
class PersistenceHelper<T: Codable> {

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
    func save(data: T) throws {
        guard let fileURL = fileURL else { throw PersistenceHelperError.fileNotAccessible }

        let encoded = try JSONEncoder().encode(data)
        try encoded.write(to: fileURL)

    }

    /// Reads the folders from the PersistenceHelper's JSON file.
    func read() throws -> T  {
        guard let fileURL = fileURL else { throw PersistenceHelperError.fileNotAccessible }

        let data = try Data(contentsOf: fileURL)
        let object = try JSONDecoder().decode(T.self, from: data)

        return object
    }

    /// Deletes the PersistenceHelper's file
    func delete() throws {
        guard let fileURL = fileURL else { throw PersistenceHelperError.fileNotAccessible }

        try FileManager.default.removeItem(at: fileURL)
    }
}
