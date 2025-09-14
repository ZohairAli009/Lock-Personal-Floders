//
//  PasscodeViewController.swift
//  Lock-Folder-App
//
//  Created by Zohair on 07/11/2024.
//

import UIKit


enum PasscodePurpose: String{
    case Authenticate, SetNew, TurnOff
}

class PasscodeViewController: UIViewController {
    
    var textField = UITextField()
    var textLabel = UILabel()
    var purpose: PasscodePurpose!
    var labelText: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .black.withAlphaComponent(0.95)
        
        setupTextField()
        setupLabel()
    }
    
    
    init(labelText: String, purpose: PasscodePurpose){
        super.init(nibName: nil, bundle: nil)
        self.labelText = labelText
        self.purpose = purpose
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func dismissView(){
        dismiss(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("dismissWithoutSetPassC"), object: nil)
    }
    
    
    func setupTextField(){
        view.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 27)
        textField.layer.borderWidth = 0.8
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.white.cgColor
        textField.isSecureTextEntry = true
        textField.becomeFirstResponder()
        textField.addTarget(self, action: #selector(setCharLimit), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 490),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    func setupLabel(){
        
        view.addSubview(textLabel)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.font = UIFont.boldSystemFont(ofSize: 22)
        textLabel.textColor = .white
        textLabel.text = labelText
        
        NSLayoutConstraint.activate([
            textLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -15),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    
    @objc func setCharLimit(_ textField: UITextField){
        if let text = textField.text {
            if text.count < 4{
                textLabel.text = labelText
            }
            else if text.count > 4{
                textField.text = String(text.prefix(4))
            }
            else if text.count == 4 {
                switch purpose {
                case .SetNew:
                    UserDefaults.standard.setValue(text, forKey: "PaSSwoRD")
                    UserDefaults.standard.setValue(true, forKey: "passcode")
                    UserDefaults.standard.setValue(true, forKey: "1")
                    self.dismiss(animated: true)
                    
                case .TurnOff:
                    if let passCode = UserDefaults.standard.string(forKey: "PaSSwoRD"){
                        if text == passCode{
                            UserDefaults.standard.removeObject(forKey: "PaSSwoRD")
                            UserDefaults.standard.setValue(false, forKey: "passcode")
                            UserDefaults.standard.setValue(false, forKey: "1")
                            self.dismiss(animated: true)
                        }else{
                            textLabel.text = "Worng Passcode"
                        }
                    }
                    
                case .Authenticate:
                    if let passCode = UserDefaults.standard.string(forKey: "PaSSwoRD"){
                        if text == passCode{
                            NotificationCenter.default.post(name: NSNotification.Name("pass"), object: nil)
                            self.dismiss(animated: false)
                        }else{
                            textLabel.text = "Worng Passcode"
                        }
                    }
                    
                case .none:
                    print("passcodeViewCon Defualt")
                }
            }
        }
    }

}
