//
//  Views.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import UIKit

class ViewsManager {
    static func createStackView(axis: NSLayoutConstraint.Axis = .vertical, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, spacing: CGFloat = 0) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.distribution = distribution
        stack.alignment = alignment
        stack.spacing = spacing
        return stack
    }
    
    static func createLabel(numberOfLines: Int = 1, font: UIFont, textAlignment: NSTextAlignment = .left, textColor: UIColor = AppColor.bitcoinGrey.color()) -> UILabel {
        let label = UILabel()
        label.numberOfLines = numberOfLines
        label.font = font
        label.textAlignment = textAlignment
        label.textColor = textColor
        return label
    }
}

class CornerTopView: UIView {
    
    var corner: CGFloat = 32.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var color: UIColor = .white {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.clipsToBounds = true
        self.layer.cornerRadius = corner
        self.layer.backgroundColor = color.cgColor
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isOpaque = false
    }
}
