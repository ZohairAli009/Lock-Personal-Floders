//
//  SettingsViewController.swift
//  Lock-Folder-App
//
//  Created by Zohair on 28/10/2024.
//

import UIKit
import LocalAuthentication

class SettingsViewController: UIViewController {
    
    var titleLabel = UILabel()
    var tableView = UITableView()
    
    var settingImages: [String] = []
    var settingLabels: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        setupNavViews()
        setupTableView()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
    
    private func setupViewController(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadTableView),
            name: NSNotification.Name("dismissWithoutSetPassC"), object: nil
        )
        view.backgroundColor = .init(red: 195/255, green: 251/255, blue: 255/255, alpha: 1)
        settingImages = ["faceid", "lock", "xmark.bin"]
        settingLabels = ["Use FaceID", "Set Passcode", "Delete after Import"]
    }
    
    
    @objc func reloadTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setupNavViews(){
        
        let doneBtn = CustomBtn(frame: CGRect(x: 0, y: 0, width: 60, height: 23), title: "Done", color: .black)
        
        view.addSubview(titleLabel)
        view.addSubview(doneBtn)
        
        titleLabel.text = "Settings"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        doneBtn.addTarget(self, action: #selector(doneBtnTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 90),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            doneBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            doneBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
        
    }
    
    
    @objc func doneBtnTapped(){
        dismiss(animated: true)
    }
    
    
    func setupTableView(){
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        
        tableView.register(ToggleTableViewCell.self, forCellReuseIdentifier: "ToggleSettingCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    
    @objc func settingsSwitchBtnTapped(_ sender: UISwitch){
        switch sender.tag {
        case 0:
            // FaceID settings
            let isPasscodeSet = UserDefaults.standard.bool(forKey: "passcode")
            if isPasscodeSet {
                if sender.isOn == true {
                    CodeHelper.authenticateWithFaceID { authenticate in
                        if authenticate {
                            UserDefaults.standard.setValue(true, forKey: "faceid")
                            UserDefaults.standard.setValue(true, forKey: "0")
                        }else{
                            sender.isOn = false
                        }
                    }
                }else{
                    CodeHelper.authenticateWithFaceID { authenticate in
                        if authenticate {
                            UserDefaults.standard.setValue(false, forKey: "faceid")
                            UserDefaults.standard.setValue(false, forKey: "0")
                        }else{
                            sender.isOn = true
                        }
                    }
                }
            }else{
                sender.isOn = false
                let ac = UIAlertController(title: "Set Passcode", message: "You have to set Passcode first.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                present(ac, animated: true)
            }
            
        case 1:
            // Password settings
            var passcodeVC = UIViewController()
            if sender.isOn == true {
                passcodeVC = PasscodeViewController(labelText: "Enter 4 digit Passcode", purpose: .SetNew)
            }else{
                passcodeVC = PasscodeViewController(labelText: "Enter Passcode to turn it off", purpose: .TurnOff)
            }
            passcodeVC.modalPresentationStyle = .fullScreen
            passcodeVC.modalTransitionStyle = .crossDissolve
            present(passcodeVC, animated: true)
            
        case 2:
            // Delete after import settings
            if sender.isOn == true {
                UserDefaults.standard.setValue(true, forKey: "2")
            }else{
                UserDefaults.standard.setValue(false, forKey: "2")
            }
            
        default:
            print("Default")
        }
        
    }

}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleSettingCell", for: indexPath)
        as? ToggleTableViewCell

        cell?.iconView.image = UIImage(systemName: settingImages[indexPath.row])
        cell?.settingLabel.text = settingLabels[indexPath.row]
        if let switchButton = cell?.switchBtn {
            switchButton.tag = indexPath.row
            switchButton.addTarget(self, action: #selector(settingsSwitchBtnTapped), for: .valueChanged)
            let key = UserDefaults.standard.bool(forKey: "\(indexPath.row)")
            if key {
                switchButton.isOn = true
            }else{
                switchButton.isOn = false
            }
        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
