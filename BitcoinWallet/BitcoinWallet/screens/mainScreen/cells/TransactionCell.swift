//
//  TransactionCell.swift
//  BitcoinWallet
//
//  Created by admin on 17.03.2021.
//

import UIKit
import Stevia

class TransactionCell: UITableViewCell {
    
    static let reusableIdentifier = "TransactionCell"
    private let imageContainerSize: CGFloat = 40
    
    let transactionImage = UIImageView()
    let transactionTitle = ViewsManager.createLabel(numberOfLines: 2, font: .systemFont(ofSize: 16, weight: .medium), textAlignment: .left, textColor: AppColor.bitcoinGrey.color())
    let amountTitle = ViewsManager.createLabel(font: .systemFont(ofSize: 16, weight: .medium), textAlignment: .right)
    
    private func createMainStack() -> UIStackView {
        let mainStackView = ViewsManager.createStackView(axis: .horizontal, alignment: .top, spacing: 8)
        contentView.sv(mainStackView)
        mainStackView.fillHorizontally().fillVertically(m: 6)
        return mainStackView
    }
    
    private func createImageContainer() -> UIView {
        let imageContainerView = UIView()
        imageContainerView.size(imageContainerSize)
        imageContainerView.layer.cornerRadius = imageContainerSize / 2
        imageContainerView.backgroundColor = AppColor.greyLight.color()
        return imageContainerView
    }
    
    var transaction: Transaction? {
        didSet{
            selectionStyle = .none
            
            transactionTitle.text = transaction?.transactionCategory.rawValue
            transactionImage.image = transaction?.transactionCategory.image
            amountTitle.text = transaction?.transactionAmount
            
            switch transaction?.transactionCategory {
            case .replenishment:
                amountTitle.textColor = AppColor.green.color()
            default:
                amountTitle.textColor = AppColor.red.color()
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let mainStackView = createMainStack()
        
        let imageContainerView = createImageContainer()
        imageContainerView.sv(transactionImage)
        transactionImage.fillContainer(8)
        
        mainStackView.addArrangedSubview(imageContainerView)
        mainStackView.addArrangedSubview(transactionTitle)
        mainStackView.addArrangedSubview(amountTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
