//
//  AddFolderViewController.swift
//  Lock-Folder-App
//
//  Created by Zohair on 20/10/2024.
//

import UIKit

class AddFolderViewController: UIViewController, UITextFieldDelegate {
    
    
    let topView = UIView()
    let doneBtn = UIButton()
    let cancelBtn = UIButton()
    let titleLbl = UILabel()
    let imageView = UIImageView()
    let textFeild = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupElements()
    }
    
    
    private func configureUI(){
        view.addSubview(topView)
        topView.addSubview(doneBtn)
        topView.addSubview(cancelBtn)
        topView.addSubview(titleLbl)
        view.addSubview(imageView)
        view.addSubview(textFeild)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textFeild.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .init(red: 195/255, green: 251/255, blue: 255/255, alpha: 1)
        topView.backgroundColor = .lightText.withAlphaComponent(0.5)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 70),
            
            doneBtn.topAnchor.constraint(equalTo: topView.topAnchor, constant: 17),
            doneBtn.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -17),
            doneBtn.widthAnchor.constraint(equalToConstant: 80),
            doneBtn.heightAnchor.constraint(equalToConstant: 36),
            
            cancelBtn.topAnchor.constraint(equalTo: topView.topAnchor, constant: 17),
            cancelBtn.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 17),
            cancelBtn.widthAnchor.constraint(equalToConstant: 80),
            cancelBtn.heightAnchor.constraint(equalToConstant: 36),
            
            titleLbl.topAnchor.constraint(equalTo: topView.topAnchor, constant: 17),
            titleLbl.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -17),
            titleLbl.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 150),
            titleLbl.widthAnchor.constraint(equalToConstant: 100),
            
            imageView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 40),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 180),
            imageView.heightAnchor.constraint(equalToConstant: 180),
            
            textFeild.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 13),
            textFeild.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFeild.widthAnchor.constraint(equalToConstant: 300),
            textFeild.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    
    func setupElements(){
        // done button
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.addTarget(self, action: #selector(doneBtnTapped), for: .touchUpInside)
        doneBtn.setTitleColor(.black, for: .normal)
        
        // cancel button
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnTapped), for: .touchUpInside)
        cancelBtn.setTitleColor(.black, for: .normal)
        
        // title
        titleLbl.text = "Add Folder"
        titleLbl.font = UIFont.boldSystemFont(ofSize: 20)
        titleLbl.textColor = .black
        titleLbl.textAlignment = .center
        
        // image view
        imageView.image = UIImage(named: "Folder-icon")
        
        // text field
        textFeild.layer.cornerRadius = 22
        textFeild.backgroundColor = .lightText.withAlphaComponent(0.8)
        textFeild.textColor = .black
        textFeild.font = UIFont.systemFont(ofSize: 23)
        textFeild.textAlignment = .center
        textFeild.becomeFirstResponder()
        textFeild.returnKeyType = .done
        textFeild.delegate = self
        textFeild.attributedPlaceholder = NSAttributedString(
            string: "Enter Folder Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemIndigo]
        )
    }
    
    
    func sendAlert(){
        if !textFeild.text!.isEmpty {
            if let folderName = textFeild.text {
                NotificationCenter.default.post(name: NSNotification.Name("FolderName"), object: folderName)
                dismiss(animated: true)
            }
        }
    }
    
    
    @objc func doneBtnTapped(){
        sendAlert()
    }
    
    
    @objc func cancelBtnTapped(){
        dismiss(animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendAlert()
        return true
    }
    
}
