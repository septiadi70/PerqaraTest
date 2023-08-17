//
//  LoveButton.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 15/08/23.
//

import UIKit

class LoveButton: UIButton {
    var onImage: UIImage? { UIImage(systemName: "heart.fill") }
    var offImage: UIImage? { UIImage(systemName: "heart") }
    
    @IBInspectable var isOn: Bool = false {
        didSet {
            let image = isOn ? onImage : offImage
            setImage(image, for: .normal)
        }
    }
}
