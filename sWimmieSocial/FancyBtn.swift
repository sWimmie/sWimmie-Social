//
//  FancyBtn.swift
//  sWimmieSocial
//
//  Created by Wim van Deursen on 03-01-17.
//  Copyright © 2017 sWimmie. All rights reserved.
//

import UIKit

class FancyBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSize(width: 1.0, height: 0.5)
        layer.cornerRadius = 2.0
        
    }

}
