//
//  AddTransactionViewController.swift
//  BitcoinWallet
//
//  Created by admin on 17.03.2021.
//

import UIKit
import Stevia

protocol AddTransactionViewDelegate{
    func addTransaction(amount: Int64, date: Date, category: TransactionCategory)
}

class AddTransactionViewController: BaseViewController,  AddTransactionPresenterDelegate{
    
    var delegate: AddTransactionViewDelegate?
    var router: AddTransactionRouter?
    
    var currentBitcoinAmount: Int64 = 0
    
    var datePickerTextField: UITextField?
    var categoryPickerTextField: UITextField?
    var amountTextField: AmountValidationTextField?
    
    let datePicker = UIDatePicker()
    let categoryPicker = UIPickerView()
    
    var selectedDate: Date = Date() {
        didSet{
            datePickerTextField?.text = selectedDate.simpleDay
        }
    }
    
    var selectedCategory: TransactionCategory = .other {
        didSet{
            categoryPickerTextField?.text = selectedCategory.rawValue
        }
    }
    
    var scrollView: UIScrollView? {
        didSet{
            self.scroller = scrollView
        }
    }
    
    override func settings() {
        super.settings()
        AddTransactionConfigurator.shared.configure(vc: self)
        setTopBarLightContentStyle()
        setUI()
    }
    
    private func setUI() {
        self.title = "Add transaction"
        addBackground()
        setupPickers()
        guard let mainStackView = createBaseStackView() else {
            return
        }
        
        let descriptionTitle = ViewsManager.createLabel(numberOfLines: 0, font: .systemFont(ofSize: 24, weight: .semibold), textAlignment: .center)
        descriptionTitle.text = "Fill in the required data to add new transaction"
        
        let userDataStack = createEnterDataStack()
        
        let confirmButton = createConfirmButtonView()
        
        mainStackView.addArrangedSubview(descriptionTitle)
        descriptionTitle.fillHorizontally()
        mainStackView.addArrangedSubview(userDataStack)
        userDataStack.fillHorizontally()
        mainStackView.addArrangedSubview(confirmButton)
    }
    
    private func createConfirmButtonView() -> CornerButton{
        let confirmButton = CornerButton()
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.backgroundColor = AppColor.bitcoinOrange.color()
        confirmButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        confirmButton.setTitleColor(AppColor.bitcoinGrey.color(), for: .normal)
        confirmButton.width(>=150)
        confirmButton.addTarget(self, action: #selector(addTransactionAction), for: .touchUpInside)
        
        return confirmButton
    }
    
    private func createEnterDataStack() -> UIStackView {
        let mainStack = ViewsManager.createStackView(spacing: 16)
        
        mainStack.addArrangedSubview(createDatePickerStack())
        mainStack.addArrangedSubview(createCategoryPickerStack())
        mainStack.addArrangedSubview(createAmountStack())
        
        return mainStack
    }
    
    private func createBaseSubtitleLabel(text: String) -> UILabel {
        let subtitle = ViewsManager.createLabel(font: .systemFont(ofSize: 16, weight: .medium))
        subtitle.text = text
        return subtitle
    }
    
    private func createAmountStack() -> UIStackView {
        let amountStack = ViewsManager.createStackView(spacing: 8)
        
        let descriptionTitle = createBaseSubtitleLabel(text: "Enter the amount of the transaction")
        
        amountTextField = AmountValidationTextField()
        amountTextField?.currentBitcoinAmount = currentBitcoinAmount
        
        amountStack.addArrangedSubview(descriptionTitle)
        if let amountTextField = amountTextField {
            amountStack.addArrangedSubview(amountTextField)
        }
        
        return amountStack
    }
    
    private func createDatePickerStack() -> UIStackView {
        let datePickerStack = ViewsManager.createStackView(spacing: 8)
        
        let descriptionTitle = createBaseSubtitleLabel(text: "Enter the date of the transaction")
        
        
        datePickerTextField = ViewsManager.createTextField(font: .systemFont(ofSize: 16, weight: .semibold))
        
        datePickerStack.addArrangedSubview(descriptionTitle)
        if let datePickerTextField = datePickerTextField {
            datePickerStack.addArrangedSubview(datePickerTextField)
            datePickerTextField.inputView = datePicker
            datePickerTextField.inputAccessoryView = createToolBar()
            datePickerTextField.text = selectedDate.simpleDay
        }
        
        return datePickerStack
    }
    
    private func createCategoryPickerStack() -> UIStackView {
        let categoryPickerStack = ViewsManager.createStackView(spacing: 8)
        let descriptionTitle = createBaseSubtitleLabel(text: "Select transaction category")
        
        categoryPickerTextField = ViewsManager.createTextField(font: .systemFont(ofSize: 16, weight: .semibold))
        
        categoryPickerStack.addArrangedSubview(descriptionTitle)
        if let categoryPickerTextField = categoryPickerTextField {
            categoryPickerStack.addArrangedSubview(categoryPickerTextField)
            categoryPickerTextField.inputView = categoryPicker
            categoryPickerTextField.inputAccessoryView = createToolBar()
            categoryPickerTextField.text = selectedCategory.rawValue
        }
        
        return categoryPickerStack
    }
    
    private func createBaseStackView() -> UIStackView? {
        let cornerView = CornerTopView()
        
        self.view.sv(cornerView)
        cornerView.Top == view.safeAreaLayoutGuide.Top
        cornerView.Bottom == view.safeAreaLayoutGuide.Bottom
        cornerView.Leading == view.safeAreaLayoutGuide.Leading
        cornerView.Trailing == view.safeAreaLayoutGuide.Trailing
        
        scrollView = UIScrollView()
        
        guard let scrollView = scrollView else {
            return nil
        }
        
        cornerView.sv(scrollView)
        scrollView.fillContainer(16)
        scrollView.showsVerticalScrollIndicator = false
        
        let mainStackView = ViewsManager.createStackView(alignment: .center, distribution: .equalSpacing, spacing: 16)
        
        scrollView.sv(mainStackView)
        mainStackView.fillVertically().centerHorizontally()
        mainStackView.Width == scrollView.Width
        mainStackView.Height >= scrollView.Height
        
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
    
    private func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        toolBar.setItems([doneButton], animated: true)
        
        return toolBar
    }
    
    private func setupPickers() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.minimumDate = DateUtils.shared.bitcoinCreationDate
        
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
    }
    
    @objc private func addTransactionAction() {
        guard let text = amountTextField?.text, !text.isEmpty, let amount = Int64(text) else {
            self.showError(message: "You must enter bitcoins amount to replenish")
            return
        }
        delegate?.addTransaction(amount: amount, date: selectedDate, category: selectedCategory)
        self.back()
    }
    
    @objc func doneButtonPressed() {
        
        if datePickerTextField?.isEditing == true {
            self.selectedDate = datePicker.date
        } else if categoryPickerTextField?.isEditing == true {
            selectedCategory = TransactionCategory.allowedForAddingTransaction[categoryPicker.selectedRow(inComponent: 0)]
        }
        
        self.view.endEditing(true)
    }
    
    func showStartBusy() {
    }
    
    func showStopBusy() {
    }
}

extension AddTransactionViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TransactionCategory.allowedForAddingTransaction.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TransactionCategory.allowedForAddingTransaction[row].rawValue
    }
}
