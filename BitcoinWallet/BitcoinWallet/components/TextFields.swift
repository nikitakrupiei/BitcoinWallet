//
//  TextFields.swift
//  BitcoinWallet
//
//  Created by admin on 17.03.2021.
//

import Foundation
import UIKit

class AmountValidationTextField: UITextField, UITextFieldDelegate {
    
    var currentBitcoinAmount: Int64 = 0
    var purpose: AmountTextFieldPurpose = .replenish
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        keyboardType = .numberPad
        borderStyle = .roundedRect
        font = .systemFont(ofSize: 20, weight: .semibold)
        textColor = AppColor.bitcoinGrey.color()
        height(50)
        
        self.delegate = self
    }
    
    //minimum validation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard !string.isEmpty, let text = textField.text else {
            return true
        }
        
        /// check number is postive and less then total amount of bitcoins in the world
        let formatter = NumberFormatter()
        let finalString = (text as NSString).replacingCharacters(in: range, with: string)
        let number = formatter.number(from: finalString)
        
        guard let enteredNumber  = number?.int64Value else {
            return false
        }
        
        var maxValue: Int64
        var errorTitle: String
        
        switch purpose {
        case .replenish:
            maxValue = BitcoinConfiguration.maximumBitcoinAmountInTheWorld - currentBitcoinAmount
            errorTitle = "You can't get as much bitcoins"
        case .transaction:
            maxValue = currentBitcoinAmount
            errorTitle = "You don't have enough bitcoins on your account"
        }
        
        if maxValue < enteredNumber {
            Application.shared.topViewController?.showError(message: errorTitle)
        }
        
        return (0 ... maxValue) ~= enteredNumber
    }
}

enum AmountTextFieldPurpose {
    case replenish
    case transaction
}
