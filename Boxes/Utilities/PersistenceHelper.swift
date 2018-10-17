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
    static let shared = PersistenceHelper(fileName: Constants.savedDataFileName)

    private var fileURL: URL?

    init(fileName: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        fileURL = paths.first?.appendingPathComponent(fileName)
    }

    func save(folders: [Folder]) throws {
        guard let fileURL = fileURL else { throw PersistenceHelperError.fileNotAccessible }

        let encoded = try JSONEncoder().encode(folders)
        try encoded.write(to: fileURL)

    }

    func readFolders() throws -> [Folder]  {
        guard let fileURL = fileURL else { throw PersistenceHelperError.fileNotAccessible }

        let data = try Data(contentsOf: fileURL)
        let object = try JSONDecoder().decode([Folder].self, from: data)

        return object
    }

    func readDefaultFolders() throws -> [Folder] {
        guard let file = Bundle.main.path(forResource: Constants.defaultDataFileName,
                                          ofType: Constants.defaultDataFileType) else {
                                            return []
        }

        let path = URL(fileURLWithPath: file)
        let data = try Data(contentsOf: path)
        let folders = try JSONDecoder().decode([Folder].self, from: data)

        return folders
    }

    func json(from folders: [Folder]) -> Data? {
        return nil
    }
}
