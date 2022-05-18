//
//  GCDManager.swift
//  Chatik
//
//  Created by Vladislav Smetanin on 23.03.2022.
//

import Foundation
import UIKit

class MainFileManager {
    
    private static let jsonDecoder = JSONDecoder()
    private static let jsonEncoder = JSONEncoder()
    
    private static let nameKey = "name"
    private static let infoKey = "info"
    private static let imageKey = "image"
    
    private static let fileManager = FileManager.default
    
    private static var documentDirectory: URL? = {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }()
    
    private static var savingFileURL: URL? = {
        guard let documentDirectory = documentDirectory else {return nil}
        let fileUrl = documentDirectory.appendingPathComponent("userProfile.json")
        return fileUrl
    }()
    
    static func saveUserProfile(userName: String, userInfo: String, userProfileImage: UIImage) {
        
        guard let savingFileURL = savingFileURL else {return}
        
        guard let nameData = userName.data(using: .utf8),
              let infoData = userInfo.data(using: .utf8),
              let imageData = userProfileImage.pngData() else {return}
        
        let savingData = [nameKey: nameData, infoKey: infoData, imageKey: imageData]
        
        do {
            let encodedData = try jsonEncoder.encode(savingData)
            fileManager.createFile(atPath: savingFileURL.path, contents: encodedData)
        } catch {
            print(error)
        }
    }
    
    static func loadUserProfile() -> (userName: String, userInfo: String, userProfileImage: UIImage)? {
        
        guard let savingFileURL = savingFileURL else {return nil}
        
        var savedData: Data? = nil
        var decodedData: [String: Data]? = nil
        
        do {
            savedData = try Data(contentsOf: savingFileURL)
        } catch {
            print(error)
        }
        
        guard let savedData = savedData else {return nil}
        
        do {
            decodedData = try jsonDecoder.decode([String: Data].self, from: savedData)
        } catch {
            print(error)
        }
        
        guard let decodedData = decodedData,
              let imageData = decodedData[imageKey],
              let nameData = decodedData[nameKey],
              let infoData = decodedData[infoKey],
              let name = String(data: nameData, encoding: .utf8),
              let info = String(data: infoData, encoding: .utf8),
              let image = UIImage(data: imageData)
        else { return nil }
        
        return (name, info, image)
    }
}
