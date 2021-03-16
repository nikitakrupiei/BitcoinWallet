//
//  WalletViewController.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import UIKit
import Stevia
import CoreData

protocol WalletViewDelegate{
    func fetchedBitcoinRate() -> NSFetchedResultsController<BitcoinRate>
    func fetchedCurrentBalance() -> NSFetchedResultsController<CurrentBalance>
}

class WalletViewController: BaseViewController,  WalletPresenterDelegate{
    
    var delegate: WalletViewDelegate?
    var router: WalletRouter?
    
    private var currencyLabel: UILabel?
    private var currentBalanceLabel: UILabel?
    
    private var fetchedBitcoinRate: NSFetchedResultsController<BitcoinRate>?
    private var fetchedCurrentBalance: NSFetchedResultsController<CurrentBalance>?
    
    override func settings() {
        super.settings()
        WalletConfigurator.shared.configure(vc: self)
        setTopBarLightContentStyle()
        
        fetchedBitcoinRate = delegate?.fetchedBitcoinRate()
        fetchedBitcoinRate?.delegate = self
        
        fetchedCurrentBalance = delegate?.fetchedCurrentBalance()
        fetchedCurrentBalance?.delegate = self
        
        setUI()
    }
    
    private func setUI() {
        addBackground()
        
        let mainStackView = createMainStackView()
        let infoStack = createMainInfoStack()
        let cornerView = createCornerViews()
        
        mainStackView.addArrangedSubview(infoStack)
        infoStack.fillHorizontally(m: 20)
        
        mainStackView.addArrangedSubview(cornerView)
        cornerView.fillHorizontally()
    }
    
    private func createMainStackView() -> UIStackView {
        let mainStackView = ViewsManager.createStackView(alignment: .center, spacing: 8)
        
        self.view.sv(
            mainStackView
        )
        mainStackView.Top == view.safeAreaLayoutGuide.Top
        mainStackView.Bottom == view.safeAreaLayoutGuide.Bottom
        mainStackView.Leading == view.safeAreaLayoutGuide.Leading
        mainStackView.Trailing == view.safeAreaLayoutGuide.Trailing
        
        
        return mainStackView
    }
    
    private func addBackground() {
        self.view.backgroundColor = .white
        let backgroundView = UIView()
        backgroundView.backgroundColor = AppColor.bitcoinOrange.color()
        self.view.sv(backgroundView)
        
        backgroundView.fillHorizontally().top(0)
        backgroundView.Bottom == view.safeAreaLayoutGuide.Bottom
        
    }
    
    private func createMainInfoStack() -> UIStackView {
        let infoStack = ViewsManager.createStackView(spacing: 16)
        
        currencyLabel = ViewsManager.createLabel(font: .systemFont(ofSize: 24, weight: .semibold), textAlignment: .right)
        updateRateLabelValue()
        
        let balanceTextStack = ViewsManager.createStackView(spacing: 4)
        
        let currentBalanceTitle = ViewsManager.createLabel(font: .systemFont(ofSize: 16, weight: .medium), textAlignment: .left)
        currentBalanceTitle.text = "Current balance"
        
        currentBalanceLabel = ViewsManager.createLabel(font: .systemFont(ofSize: 24, weight: .semibold), textAlignment: .left)
        updateCurrentBalanceLabelValue()
        
        balanceTextStack.addArrangedSubview(currentBalanceTitle)
        if let currentBalanceLabel = currentBalanceLabel {
            balanceTextStack.addArrangedSubview(currentBalanceLabel)
        }
        
        let addTransactionButton = CornerButton()
        addTransactionButton.setTitle("Replenish balance", for: .normal)
        addTransactionButton.backgroundColor = .white
        addTransactionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addTransactionButton.setTitleColor(AppColor.bitcoinGrey.color(), for: .normal)
        addTransactionButton.addTarget(self, action: #selector(navigateToReplenishBalance), for: .touchUpInside)
        
        if let currencyLabel = currencyLabel {
            infoStack.addArrangedSubview(currencyLabel)
        }
        infoStack.addArrangedSubview(balanceTextStack)
        infoStack.addArrangedSubview(addTransactionButton)
        
        return infoStack
    }
    
    private func createCornerViews() -> CornerTopView {
        let cornerView = CornerTopView()
        
        let transactionStack = createTransactionStack()
        cornerView.sv(transactionStack)
        transactionStack.fillHorizontally().top(8).bottom(8)
        
        return cornerView
    }
    
    private func createTransactionStack() -> UIStackView {
        let transactionStack = ViewsManager.createStackView(alignment: .center)
        
        let titleStack = ViewsManager.createStackView(spacing: 8)
        let transactionTitle = ViewsManager.createLabel(font: .systemFont(ofSize: 20, weight: .semibold), textAlignment: .center)
        transactionTitle.text = "Transactions"
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        separatorView.height(1)
        
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        
        
        let addTransactionButton = UIButton()
        addTransactionButton.layer.cornerRadius = 8
        addTransactionButton.height(40)
        addTransactionButton.setTitle("Add transaction", for: .normal)
        addTransactionButton.backgroundColor = AppColor.bitcoinOrange.color()
        addTransactionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addTransactionButton.setTitleColor(AppColor.bitcoinGrey.color(), for: .normal)
        addTransactionButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        let addTransactionButttonStack = ViewsManager.createStackView(axis: .horizontal, spacing: 8)
        addTransactionButttonStack.addArrangedSubview(UIView())
        addTransactionButttonStack.addArrangedSubview(addTransactionButton)
        
        
        titleStack.addArrangedSubview(transactionTitle)
        titleStack.addArrangedSubview(separatorView)
        
        transactionStack.addArrangedSubview(titleStack)
        titleStack.fillHorizontally()
        
        transactionStack.addArrangedSubview(tableView)
        tableView.fillHorizontally()
        
        transactionStack.addArrangedSubview(addTransactionButttonStack)
        addTransactionButttonStack.fillHorizontally(m: 16)
        
        return transactionStack
    }
    
    func updateRateLabelValue() {
        currencyLabel?.text = fetchedBitcoinRate?.fetchedObjects?.first?.usdRate
    }
    
    func updateCurrentBalanceLabelValue() {
        currentBalanceLabel?.text = fetchedCurrentBalance?.fetchedObjects?.first?.currentBalance ?? CurrentBalanceService.defaultBalance
    }
    
    @objc func navigateToReplenishBalance() {
        let currentBalance = fetchedCurrentBalance?.fetchedObjects?.first?.balance ?? 0
        router?.navigateToReplenishBalance(currentBalance: currentBalance)
    }
    
    func showStartBusy() {
    }
    
    func showStopBusy() {
    }
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Transaction : \(indexPath.row + 1)"
        return cell
    }
}

extension WalletViewController: NSFetchedResultsControllerDelegate{
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        if controller == fetchedBitcoinRate {
            updateRateLabelValue()
        } else if controller == fetchedCurrentBalance {
            updateCurrentBalanceLabelValue()
        }
    }
}
