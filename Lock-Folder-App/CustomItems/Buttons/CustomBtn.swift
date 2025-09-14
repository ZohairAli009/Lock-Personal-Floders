//
//  CustomBtn.swift
//  Lock-Folder-App
//
//  Created by Zohair on 22/10/2024.
//

import UIKit

class CustomBtn: UIButton {

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    init(frame: CGRect, title: String, color: UIColor){
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.frame = frame
    }
    
    init(frame: CGRect, image: String, color: UIColor){
        super.init(frame: .zero)
        self.setImage(UIImage(systemName: image,
                              withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)),
                              for: .normal)
        self.tintColor = color
        self.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
