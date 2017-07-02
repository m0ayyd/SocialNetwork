//
//  CiricleImage.swift
//  SocialNetwork
//
//  Created by the Luckiest on 6/29/17.
//  Copyright © 2017 the Luckiest. All rights reserved.
//

import UIKit

class CiricleImage: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
