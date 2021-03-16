//
//  ViewControllers.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation
import UIKit

protocol BaseViewControllerDelegate {
    var hideNavigationBar: Bool {get}
}

class BaseViewController: UIViewController, BaseViewControllerDelegate {
    
    private var attachableTap: UITapGestureRecognizer?
    
    var navigationBarColor: UIColor?
    var setNavigationBarTransparent: Bool = false
    var hideNavigationBar: Bool = false
    var scroller: UIScrollView?
    private var firstAppear: Bool = true
    private var _beforeFirstAppear: Bool = true
    
    var keyBoardPresent: Bool = false
    
    func beforeFirstAppear(){
        _beforeFirstAppear = false
    }
    
    func beforeNextAppear(){
        
    }
    
    func onFirstAppear(){
        firstAppear = false
    }
    
    func onNextAppear(){
    }
    
    func setTopBarDarkContentStyle(){
        setNavigationBarTransparent = true
        navigationBarColor = .white
    }
    
    func setTopBarLightContentStyle(){
        setNavigationBarTransparent = true
        navigationBarColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings()
    }
    
    func settings(){
        attachableTap =  hideKeyboardWhenTappedAround()
        navigationController?.delegate = self
    }
    
    func attachTap(_ attachedAction: Selector){
        attachableTap?.addTarget(self, action: attachedAction)
    }
    
    @objc private func keyboardChangeFrame(_ notification: Notification){
        guard let userInfo = notification.userInfo, let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
        let convertedFrame = view.convert(frame, from: UIScreen.main.coordinateSpace)
        let intersectedKeyboardHeight = view.frame.intersection(convertedFrame).height
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.scroller?.contentInset.bottom = intersectedKeyboardHeight
        }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if _beforeFirstAppear {
            beforeFirstAppear()
        }else{
            beforeNextAppear()
        }
        
        addKeyboardNotofications()
        
        guard let _ = self.parent as? UINavigationController else {return}

        if let color = navigationBarColor {
            let navigationBar = self.navigationController?.navigationBar
            navigationBar?.shadowImage = nil
            navigationBar?.setBackgroundImage(nil, for: .default)
            navigationBar?.tintColor = color
        }
        
        if setNavigationBarTransparent {
            let navigationBar = self.navigationController?.navigationBar
            navigationBar?.setBackgroundImage(UIImage(), for: .default)
            navigationBar?.shadowImage = UIImage()
            navigationBar?.tintColor = navigationBarColor ?? UIColor.white
            navigationBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationBarColor ?? UIColor.white]
        }else{
            let navigationBar = self.navigationController?.navigationBar
            navigationBar?.shadowImage = nil
            navigationBar?.setBackgroundImage(nil, for: .default)
            navigationBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationBarColor ?? .black]
        }
        
        navigationController?.setNavigationBarHidden(hideNavigationBar, animated: animated)
    }
    
    private func addKeyboardNotofications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillAppear() {
        keyBoardPresent = true
    }
    
    @objc func keyboardWillDisappear() {
        keyBoardPresent = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppear {
            firstAppear = false
            onFirstAppear()
        }else{
            onNextAppear()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)

        if setNavigationBarTransparent || navigationBarColor != nil {
            let navigationBar = self.navigationController?.navigationBar
            navigationBar?.tintColor = .black
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BaseViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? BaseViewControllerDelegate {
            navigationController.setNavigationBarHidden(vc.hideNavigationBar, animated: animated)
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() -> UITapGestureRecognizer{
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        return tap
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

protocol BasePresenterDelegate: class {
}

extension UIViewController: BasePresenterDelegate {
    
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
}
