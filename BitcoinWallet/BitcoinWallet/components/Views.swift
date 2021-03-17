//
//  Views.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import UIKit

//Manager for creating base UI elements
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
    
    static func createTextField(font: UIFont, textColor: UIColor = AppColor.bitcoinGrey.color(), keyboardType: UIKeyboardType = .default, borderStyle:  UITextField.BorderStyle = .roundedRect) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = keyboardType
        textField.borderStyle = borderStyle
        textField.font = .systemFont(ofSize: 20, weight: .semibold)
        textField.textColor = textColor
        textField.height(50)
        return textField
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
