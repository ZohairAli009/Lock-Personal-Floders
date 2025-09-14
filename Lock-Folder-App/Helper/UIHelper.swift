//
//  UIHelper.swift
//  Lock-Folder-App
//
//  Created by Zohair on 24/10/2024.
//

import Foundation
import LocalAuthentication

struct CodeHelper {
    
    func getCurrentDate() -> String{
        let formetter = DateFormatter()
        formetter.timeStyle = .none
        formetter.dateStyle = .full
        
        return formetter.string(from: Date())
    }
    
    
    static func authenticateWithFaceID(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Authenticate.") { success, error in
                DispatchQueue.main.async {
                    if success {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        } else {
            print("Face ID not available. Error: \(error?.localizedDescription ?? "Unknown error")")
            completion(false)
        }
    }

    
}
