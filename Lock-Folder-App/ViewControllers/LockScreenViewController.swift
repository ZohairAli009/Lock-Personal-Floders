//
//  LockScreenViewController.swift
//  Lock-Folder-App
//
//  Created by Zohair on 27/10/2024.
//

import UIKit

class LockScreenViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(dismissViewController), name: NSNotification.Name("pass"), object: nil)
    }

    
    @objc func dismissViewController(){
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pass"), object: nil)
    }
    
    
    @IBAction func passcodeBtnTapped(_ sender: UIButton) {
        let vc = PasscodeViewController(labelText: "Enter Passcode", purpose: .Authenticate)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func faceidBtnTapped(_ sender: UIButton) {
        let isEnable = UserDefaults.standard.bool(forKey: "faceid")
        if isEnable{
            CodeHelper.authenticateWithFaceID { pass in
                if pass {
                    self.dismiss(animated: true)
                }
            }
        }else{
            let ac = UIAlertController(title: "FaceID not Enabled", message: "Enable FaceID from app settings.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
}
