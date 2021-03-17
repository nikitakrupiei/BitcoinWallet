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
    func fetchedTransactions() -> NSFetchedResultsController<Transaction>
    func performFetch(for controller: NSFetchedResultsController<Transaction>, limit: Int) -> NSFetchedResultsController<Transaction>
}

class WalletViewController: BaseViewController,  WalletPresenterDelegate{
    
    var delegate: WalletViewDelegate?
    var router: WalletRouter?
    
    private var currencyLabel: UILabel?
    private var currentBalanceLabel: UILabel?
    
    private var fetchedBitcoinRate: NSFetchedResultsController<BitcoinRate>?
    private var fetchedCurrentBalance: NSFetchedResultsController<CurrentBalance>?
    private var fetchedTransactions: NSFetchedResultsController<Transaction>?
    
    var reachedEnd = false
    var currentLimit = CoreDataConfiguration.paginationStep
    
    var transactionsNoDataStack: UIStackView?{
        didSet{
            transactionsNoDataStack?.isHidden = true
            transactionsNoDataStack?.alpha = 0
        }
    }
    
    var tableView: UITableView?{
        didSet{
            tableView?.dataSource = self
            tableView?.delegate = self
            tableView?.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reusableIdentifier)
            tableView?.separatorStyle = .none
            tableView?.showsVerticalScrollIndicator = false
        }
    }
    
    override func settings() {
        super.settings()
        WalletConfigurator.shared.configure(vc: self)
        setTopBarLightContentStyle()
        
        setupFetchControllers()
        setUI()
        handleNoData()
    }
    
    private func setupFetchControllers() {
        fetchedBitcoinRate = delegate?.fetchedBitcoinRate()
        fetchedBitcoinRate?.delegate = self
        
        fetchedCurrentBalance = delegate?.fetchedCurrentBalance()
        fetchedCurrentBalance?.delegate = self
        
        fetchedTransactions = delegate?.fetchedTransactions()
        fetchedTransactions?.delegate = self
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
        
        let replenishButton = CornerButton()
        replenishButton.setTitle("Replenish balance", for: .normal)
        replenishButton.backgroundColor = .white
        replenishButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        replenishButton.setTitleColor(AppColor.bitcoinGrey.color(), for: .normal)
        replenishButton.addTarget(self, action: #selector(navigateToReplenishBalance), for: .touchUpInside)
        
        if let currencyLabel = currencyLabel {
            infoStack.addArrangedSubview(currencyLabel)
        }
        infoStack.addArrangedSubview(balanceTextStack)
        infoStack.addArrangedSubview(replenishButton)
        
        return infoStack
    }
    
    private func createCornerViews() -> CornerTopView {
        let cornerView = CornerTopView()
        
        let transactionStack = createTransactionStack()
        cornerView.sv(transactionStack)
        transactionStack.fillHorizontally().top(8).bottom(8)
        
        transactionsNoDataStack = addTransactionsNoDataStack()
        
        if let transactionsNoDataStack = transactionsNoDataStack {
            cornerView.sv(transactionsNoDataStack)
            transactionsNoDataStack.fillHorizontally()
            transactionsNoDataStack.centerVertically()
        }
        
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
        
        tableView = UITableView()
        
        let addTransactionButton = UIButton()
        addTransactionButton.layer.cornerRadius = 8
        addTransactionButton.height(40)
        addTransactionButton.setTitle("Add transaction", for: .normal)
        addTransactionButton.backgroundColor = AppColor.bitcoinOrange.color()
        addTransactionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addTransactionButton.setTitleColor(AppColor.bitcoinGrey.color(), for: .normal)
        addTransactionButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        addTransactionButton.addTarget(self, action: #selector(navigateToAddTransaction), for: .touchUpInside)
        
        let addTransactionButttonStack = ViewsManager.createStackView(axis: .horizontal, spacing: 8)
        addTransactionButttonStack.addArrangedSubview(UIView())
        addTransactionButttonStack.addArrangedSubview(addTransactionButton)
        
        
        titleStack.addArrangedSubview(transactionTitle)
        titleStack.addArrangedSubview(separatorView)
        
        transactionStack.addArrangedSubview(titleStack)
        titleStack.fillHorizontally()
        
        if let tableView = tableView {
            transactionStack.addArrangedSubview(tableView)
            tableView.fillHorizontally(m: 16)
        }
        
        transactionStack.addArrangedSubview(addTransactionButttonStack)
        addTransactionButttonStack.fillHorizontally(m: 16)
        
        return transactionStack
    }
    
    func addTransactionsNoDataStack() -> UIStackView {
        let transactionsNoDataStack = ViewsManager.createStackView(alignment: .center, spacing: 16)
        
        let noDataImage = UIImageView()
        noDataImage.size(150)
        noDataImage.image = #imageLiteral(resourceName: "transactions-no-data")
        
        let noDataTitle = ViewsManager.createLabel(numberOfLines: 2, font: .systemFont(ofSize: 24, weight: .semibold), textAlignment: .center)
        noDataTitle.text = "Oops... No transactions found"
        
        
        let noDataDescription = ViewsManager.createLabel(numberOfLines: 0, font: .systemFont(ofSize: 16, weight: .medium), textAlignment: .center)
        noDataDescription.text = "Add new transaction by clicking \"Add transaction\" button"
        
        
        let transactionsNoDataTitleStack = ViewsManager.createStackView(spacing: 4)
        
        transactionsNoDataTitleStack.addArrangedSubview(noDataTitle)
        transactionsNoDataTitleStack.addArrangedSubview(noDataDescription)
        
        transactionsNoDataStack.addArrangedSubview(noDataImage)
        transactionsNoDataStack.addArrangedSubview(transactionsNoDataTitleStack)
        transactionsNoDataTitleStack.fillHorizontally()
        
        return transactionsNoDataStack
    }
    
    func updateRateLabelValue() {
        currencyLabel?.text = fetchedBitcoinRate?.fetchedObjects?.first?.usdRate
    }
    
    func updateCurrentBalanceLabelValue() {
        currentBalanceLabel?.text = fetchedCurrentBalance?.fetchedObjects?.first?.currentBalance ?? CurrentBalanceService.defaultBalance
    }
    
    @objc func navigateToReplenishBalance() {
        router?.navigateToReplenishBalance(currentBalance: getCurrentBalance())
    }
    
    @objc func navigateToAddTransaction() {
        router?.navigateToAddTransaction(currentBalance: getCurrentBalance())
    }
    
    private func getCurrentBalance() -> Int64 {
        return fetchedCurrentBalance?.fetchedObjects?.first?.balance ?? 0
    }
    
    private func handleNoData() {
        UIView.animate(withDuration: 0.5) { [self] in
            transactionsNoDataStack?.alpha = fetchedTransactions?.sections?.count == 0 ? 1 : 0
            transactionsNoDataStack?.isHidden = fetchedTransactions?.sections?.count != 0
        }
    }
    
    // methods for future hiding and showing loader for API requests
    func showStartBusy() {
    }
    
    func showStopBusy() {
    }
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount: Int = 0
        if let sections = fetchedTransactions?.sections, !sections.isEmpty {
            sectionCount = sections.count
        }
        
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedTransactions?.sections, !sections.isEmpty {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reusableIdentifier, for: indexPath) as? TransactionCell else {
            return UITableViewCell()
        }
        cell.transaction = fetchedTransactions?.object(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let container = UIView()
        container.backgroundColor = .white
        container.height(60)
        let label = ViewsManager.createLabel(font: .systemFont(ofSize: 16, weight: .medium), textAlignment: .center)
        
        container.sv(label)
        label.fillContainer()
        label.text = (fetchedTransactions?.sections?[section].objects?.first as? Transaction)?.date?.simpleDay
        return container
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //function to fetch more data when scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard !reachedEnd else {
            return
        }
        
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offSetY >= contentHeight - scrollView.frame.height * 2{
            guard let cont = fetchedTransactions else {
                return
            }
            currentLimit += CoreDataConfiguration.paginationStep
            fetchedTransactions = delegate?.performFetch(for: cont, limit: currentLimit)
            
            
            if fetchedTransactions?.fetchedObjects?.count ?? 0 < currentLimit {
                reachedEnd = true
            }

            tableView?.reloadData()
        }
    }
}

extension WalletViewController: NSFetchedResultsControllerDelegate{
    
    //listener for CoreData changes
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        if controller == fetchedBitcoinRate {
            updateRateLabelValue()
        } else if controller == fetchedCurrentBalance {
            updateCurrentBalanceLabelValue()
        } else if controller == fetchedTransactions {
            handleNoData()
            tableView?.reloadData()
        }
    }
}
