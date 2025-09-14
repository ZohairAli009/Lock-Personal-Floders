//
//  ViewController+Ext.swift
//  Lock-Folder-App
//
//  Created by Zohair on 26/10/2024.
//

import UIKit



extension UIViewController {
    
    func showAlertAskForDelete(_ action: @escaping (IndexPath) -> Void, title: String?){
        
        let Alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        Alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
             action(IndexPath())
        }))
        cancelAction.setValue(UIColor.white, forKey: "titleTextColor")
        Alert.addAction(cancelAction)
        
        present(Alert, animated: true)
    }
}
