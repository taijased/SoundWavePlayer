//
//  LocalFileFetcher.swift
//  SoundWavePlayer
//
//  Created by Максим Спиридонов on 06.06.2020.
//  Copyright © 2020 Максим Спиридонов. All rights reserved.
//


import UIKit
import AVFoundation
import Accelerate


class LocalFileFetcher {
    
    
    var fileManager: FileManager
    
    
    lazy fileprivate var defaultsPath: URL = {
        let fileManager = FileManager.default
        let documentsURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL.appendingPathComponent("call-recordings", isDirectory: true)
    }()
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        self.initDefaultDirectory()
    }
    
    fileprivate func initDefaultDirectory() {
        
        if !defaultsPath.checkFileExist() {
            do {
                try fileManager.createDirectory(atPath: defaultsPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        }
        
    }
    
    
    
    func createFile(_ data: Data, completion: @escaping (URL?) -> Void) {
        
        
        let filePath = self.defaultsPath.appendingPathComponent("\(UUID().uuidString)").appendingPathExtension("aiff")

        do {
            
            print(defaultsPath.checkFileExist())
            
            self.fileManager.createFile(atPath: filePath.relativeString, contents: data, attributes: nil)
            try data.write(to: filePath)
           
            let urls = try fileManager.contentsOfDirectory(at: defaultsPath, includingPropertiesForKeys:[], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)

            if filePath.checkFileExist() {
                print(urls)
                completion(filePath)
            } else {
                print("idi nahiu")
                completion(nil)
            }
        } catch let error as NSError {
            print("copyFile \(error.debugDescription)")
            completion(nil)
        }
    }
    
    func removeItem(_ url: URL) {
        do {
            try fileManager.removeItem(at: url)
        } catch let error as NSError {
            print("Unable to delete directory \(error.debugDescription)")
        }
    }
    
    
    
    
    
    
    
    
    func clearRecordingsCashe() {
       
        do {
            let urls = try fileManager.contentsOfDirectory(at: defaultsPath, includingPropertiesForKeys:[], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            for item in urls {
                try fileManager.removeItem(at: item)
            }
        } catch let error as NSError {
            print("Unable to delete defaultsPath \(error.debugDescription)")
        }
        
    }
    
    
    func removeFolder(_ guid: String) {
        let directoryPath = defaultsPath.appendingPathComponent(guid)
        if directoryPath.hasDirectoryPath {
            do {
                try fileManager.removeItem(at: directoryPath)
                print(#function)
            } catch let error as NSError {
                print("Unable to delete directory \(error.debugDescription)")
            }
        }
        
    }
    
    
}





extension URL    {
    func checkFileExist() -> Bool {
        if (FileManager.default.fileExists(atPath: self.path))   {
            return true
        }else        {
            return false
        }
    }
}




