//
//  FileManagerExtensions.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

extension FileManager {
    
    func getImagePath(in folder: FMPaths, imageName: String) -> String {
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return "" }
        let folderURL = docDirURL.appendingPathComponent(folder.folderSubpath, isDirectory: true)
        let imagePath = folderURL.appendingPathComponent(imageName).path
        return imagePath
    }
    
}

extension FileManager {
    
    func createNewFolder(folderName: String) {
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let newFolderURL = docDirURL.appendingPathComponent(folderName, isDirectory: true)
        let newFolderPath = newFolderURL.path
        
        guard !FileManager.default.fileExists(atPath: newFolderPath) else {
            return
        }
        try? FileManager.default.createDirectory(atPath: newFolderPath, withIntermediateDirectories: true, attributes: nil)
    }
    
    func createNewImageFile(in folder: FMPaths, image: UIImage, imageName: String) {
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let folderURL = docDirURL.appendingPathComponent(folder.folderSubpath, isDirectory: true)
        let imagePath = folderURL.appendingPathComponent(imageName).path
        guard let imageData = image.pngData() else { return }
        FileManager.default.createFile(atPath: imagePath, contents: imageData, attributes: nil)
    }
    
}

extension FileManager {
    
    func createFoldersForImages() {
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let brandsPath = docDirURL.appendingPathComponent(FMPaths.brands.folderSubpath, isDirectory: true).path
        let bikesPath = docDirURL.appendingPathComponent(FMPaths.bikes.folderSubpath, isDirectory: true).path
        guard !FileManager.default.fileExists(atPath: brandsPath),
              !FileManager.default.fileExists(atPath: bikesPath) else { return }
        try? FileManager.default.createDirectory(atPath: brandsPath, withIntermediateDirectories: true, attributes: nil)
        try? FileManager.default.createDirectory(atPath: bikesPath, withIntermediateDirectories: true, attributes: nil)
    }
    
}

extension FileManager {
    
    func deleteImageFile(in folder: FMPaths, imageName: String ) {
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let folderURL = docDirURL.appendingPathComponent(folder.folderSubpath, isDirectory: true)
        let imagePath = folderURL.appendingPathComponent(imageName).path
        try? FileManager.default.removeItem(atPath: imagePath)
    }
    
    func clearTmpFolder() {
        let tmpDirURL = FileManager.default.temporaryDirectory
        guard let tmpDirContent = try? FileManager.default.contentsOfDirectory(atPath: tmpDirURL.path) else { return }
        for file in tmpDirContent {
            let filePath = tmpDirURL.appendingPathComponent(file).path
            try? FileManager.default.removeItem(atPath: filePath)
        }
    }
    
}
