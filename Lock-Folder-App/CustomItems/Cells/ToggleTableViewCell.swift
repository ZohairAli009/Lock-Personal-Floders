//
//  ToggleTableViewCell.swift
//  Lock-Folder-App
//
//  Created by Zohair on 28/10/2024.
//

import UIKit

class ToggleTableViewCell: UITableViewCell {
    
    var switchBtn = UISwitch()
    var iconView = UIImageView()
    var settingLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           configure()
       }

       required init?(coder: NSCoder) {
           super.init(coder: coder)
       }

    
    private func configure(){
        contentView.addSubview(switchBtn)
        contentView.addSubview(iconView)
        contentView.addSubview(settingLabel)
        
        switchBtn.isOn = false
        switchBtn.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        settingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        iconView.tintColor = .black
        settingLabel.textColor = .black
        self.backgroundColor = .systemMint.withAlphaComponent(0.3)
        
        NSLayoutConstraint.activate([
            switchBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            switchBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            switchBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            switchBtn.widthAnchor.constraint(equalToConstant: 50),
            
            iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            iconView.widthAnchor.constraint(equalToConstant: 35),
            
            settingLabel.topAnchor.constraint(equalTo: switchBtn.topAnchor),
            settingLabel.bottomAnchor.constraint(equalTo: switchBtn.bottomAnchor),
            settingLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor,constant:8),
            settingLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    
}
