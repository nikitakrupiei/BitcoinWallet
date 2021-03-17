//
//  ReplenishBalanceViewController.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import UIKit
import Stevia

protocol ReplenishBalanceViewDelegate{
    func replenishBalance(balance: Int64)
}

class ReplenishBalanceViewController: BaseViewController,  ReplenishBalancePresenterDelegate {
    
    var delegate: ReplenishBalanceViewDelegate?
    var router: ReplenishBalanceRouter?
    
    var amountTextField: AmountValidationTextField?
    var currentBitcoinAmount: Int64 = 0
    
    override func settings() {
        super.settings()
        ReplenishBalanceConfigurator.shared.configure(vc: self)
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeAnimation))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        setUI()
        showAnimation()
    }
    
    private func setUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let mainStack = createMainStack()
        
        let headerStackView = createHeaderStackView()
        
        
        let replenishDescription = ViewsManager.createLabel(numberOfLines: 3, font: .systemFont(ofSize: 16, weight: .medium), textAlignment: .center)
        replenishDescription.text = "Enter the amount to replenish your Bitcoin account"
        
        
        let confirmButton = CornerButton()
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.backgroundColor = AppColor.bitcoinOrange.color()
        confirmButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        confirmButton.setTitleColor(AppColor.bitcoinGrey.color(), for: .normal)
        confirmButton.width(>=150)
        confirmButton.addTarget(self, action: #selector(replenishWallet), for: .touchUpInside)
        
        
        let textFieldContainer = createReplenishTextField()
        
        mainStack.addArrangedSubview(headerStackView)
        headerStackView.fillHorizontally()
        mainStack.addArrangedSubview(replenishDescription)
        replenishDescription.fillHorizontally()
        
        mainStack.addArrangedSubview(textFieldContainer)
        textFieldContainer.fillHorizontally()
        
        mainStack.addArrangedSubview(confirmButton)
    }
    
    private func createMainStack() -> UIStackView {
        let mainView = UIView()
        self.view.sv(mainView)
        
        mainView.heightEqualsWidth()
        mainView.backgroundColor = .white
        mainView.fillHorizontally(m: 30).centerVertically()
        mainView.layer.cornerRadius = 24
        
        let mainStack = ViewsManager.createStackView(alignment: .center, spacing: 8)
        mainView.sv(mainStack)
        mainStack.fillContainer(16)
        
        return mainStack
    }
    
    private func createHeaderStackView() -> UIStackView {
        let additionView = UIView()
        additionView.size(24)
        
        let closeButton = UIButton()
        closeButton.setImage(#imageLiteral(resourceName: "closeIcon").withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = AppColor.bitcoinGrey.color()
        closeButton.size(24)
        closeButton.addTarget(self, action: #selector(removeAnimation), for: .touchUpInside)

        let replenishTitle = ViewsManager.createLabel(font: .systemFont(ofSize: 20, weight: .semibold), textAlignment: .center)
        replenishTitle.text = "Replenishment"
        
        let headerStackView = ViewsManager.createStackView(axis: .horizontal, spacing: 8)
        headerStackView.addArrangedSubview(additionView)
        headerStackView.addArrangedSubview(replenishTitle)
        headerStackView.addArrangedSubview(closeButton)
        
        return headerStackView
    }
    
    private func createReplenishTextField() -> UIView{
        let textFieldContainer = UIView()
        
        amountTextField = AmountValidationTextField()
        amountTextField?.currentBitcoinAmount = currentBitcoinAmount
        
        if let amountTextField = amountTextField {
            textFieldContainer.sv(amountTextField)
            amountTextField.fillHorizontally()
            amountTextField.centerVertically()
        }
        
        return textFieldContainer
    }
    
    private func close() {
        willMove(toParent: nil)
        self.view.removeFromSuperview()
        removeFromParent()
    }
    
    private func showAnimation() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    @objc private func removeAnimation() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0
        } completion: { finished in
            self.close()
        }
    }
    
    @objc private func replenishWallet() {
        guard let text = amountTextField?.text, !text.isEmpty, let newBalance = Int64(text) else {
            self.showError(message: "You must enter bitcoins amount to replenish")
            return
        }
        
        delegate?.replenishBalance(balance: newBalance)
        removeAnimation()
    }
    
    func showStartBusy() {
    }
    
    func showStopBusy() {
    }
}

extension ReplenishBalanceViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
