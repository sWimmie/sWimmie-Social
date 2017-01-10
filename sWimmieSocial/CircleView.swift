//
//  CircleView.swift
//  sWimmieSocial
//
//  Created by Wim van Deursen on 05-01-17.
//  Copyright © 2017 sWimmie. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
        
    }

}
