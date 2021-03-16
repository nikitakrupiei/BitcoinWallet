//
//  Buttons.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import UIKit

class CornerButton: UIButton {
    
    var leftOffset: CGFloat = 15 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var rightOffset: CGFloat = 15 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var topOffset: CGFloat = 10 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var bottomOffset: CGFloat = 10 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var tintColorImage: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0){
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 0.5 * self.bounds.size.height
        self.clipsToBounds = true
        if let image = self.imageView?.image?.withRenderingMode(.alwaysTemplate), let title = self.title(for: .normal), !title.isEmpty{
            setImage(image, for: .normal)
            setImage(image, for: .highlighted)
            self.imageView?.contentMode = .scaleAspectFit
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
            self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        } else if let title = self.title(for: .normal), !title.isEmpty {
            self.contentEdgeInsets = UIEdgeInsets(top: topOffset, left: leftOffset, bottom: bottomOffset, right: rightOffset)
        }else if let image = self.imageView?.image?.withRenderingMode(.alwaysTemplate) {
            setImage(image, for: .normal)
            setImage(image, for: .highlighted)
        }
        self.tintColor = tintColorImage
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isOpaque = false
    }
}
