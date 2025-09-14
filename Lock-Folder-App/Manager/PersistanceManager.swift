//
//  PersistanceManager.swift
//  Lock-Folder-App
//
//  Created by Zohair on 20/10/2024.
//

import UIKit

let Delegate = (UIApplication.shared.delegate as? AppDelegate)

struct PersistanceManager {
    
    
    static func saveFolder(name: String){
        
        if let context = Delegate?.persistentContainer.viewContext {
            
            let newFolder = Folder(context: context)
            newFolder.folderName = name
            newFolder.items = "0"
            
            try! context.save()
        }
    }
    
    
    
    
    
}


