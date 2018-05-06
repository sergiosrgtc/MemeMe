//
//  MemeHandler.swift
//  MemeMe
//
//  Created by Sergio Costa on 06/05/18.
//  Copyright © 2018 Sergio Costa. All rights reserved.
//

import Foundation
import UIKit

class MemeHandler{
    static let sharedInstance = MemeHandler()
    let fileManager = FileManager.default
    var memes = [Meme]()
    
    init() {
        getSavedMemes()
    }
    
    func saveMeme(_ meme: Meme){
        saveImageToDocumentDirectory(imageToSave: meme.memedImage, imageName: meme.topText.appending("¬").appending(meme.bottomtext))
    }
    
    func deleteMeme(_ meme: Meme, indexPath: Int){
        deleteImageFromDirectory(path: meme.path)
        MemeHandler.sharedInstance.memes.remove(at: indexPath)
    }
    
    func getSavedMemes(){
        let properties = [URLResourceKey.localizedNameKey,
                          URLResourceKey.creationDateKey,
                          URLResourceKey.localizedTypeDescriptionKey]
        
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("MemedImages")
        do {
            let imageURLs = try fileManager.contentsOfDirectory(at: URL.init(string: path)!, includingPropertiesForKeys: properties, options:FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            for item in imageURLs {
                let name = item.lastPathComponent.split(separator: "¬")
                let loadedImage = loadImage(path: item)
                if let memedImage = loadedImage{
                    let meme = Meme(topText: String(name[0]), bottomtext: String(name[1]), originalImage: memedImage, memedImage: memedImage, path: item)
                    memes.append(meme)
                }
            }
        } catch  {
            print("Error to get saved meme...")
        }
    }
    
    private func deleteImageFromDirectory(path: URL){
        do {
            try fileManager.removeItem(at: path)
        } catch {
            print("Error: \(error)")
        }
    }
    
    private func saveImageToDocumentDirectory(imageToSave: UIImage, imageName: String){
        let path = (getOrCreateMemeDirectory() as NSString).appendingPathComponent(imageName)
        let imageData = UIImageJPEGRepresentation(imageToSave, 1.0)
        fileManager.createFile(atPath: path as String, contents: imageData, attributes: nil)
    }

    private func getOrCreateMemeDirectory() -> String{
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("MemedImages")
        if !fileManager.fileExists(atPath: path){
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Already dictionary created.")
        }
        return path
    }
    
    private func loadImage(path: URL) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: path)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
}
