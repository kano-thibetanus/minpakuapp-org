//
//  PassCodeViewController.swift
//  MinpakuMock
//
//  Created by 平林陽一 on 2019/02/19.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class PassCodeViewController: UIViewController {
    var viewModel: PassCodeViewModel!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var guidanceLbl: UILabel!
    @IBOutlet weak var passCodeTextField: UITextField!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // viewModel
        viewModel = PassCodeViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // notification
        configureObserver()
        
        // label
        headerLbl.text = viewModel.headerLblTxt()
        guidanceLbl.text = viewModel.guidanceLblTxt()
        
        // btn
        enterBtn.addTarget(self, action: #selector(pressEnterBtn(_:)), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(pressBackBtn(_:)), for: .touchUpInside)
        backBtn.isHidden = true
        
        // textField
        passCodeTextField.delegate = self
        passCodeTextField.keyboardType = .phonePad
        
        // TODO: debug
//        passCodeTextField.text = "111111"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !viewModel.isLogin {
            enterBtn.setImage(UIImage(named: "btn_logout"), for: .normal)
            backBtn.isHidden = false
        }
    }
    
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func validatePassCode() {
        if viewModel.validatePass(pass: passCodeTextField.text ?? "") {
            if viewModel.isLogin {
                if let viewController: MainNavigationController = MainNavigationController.viewControllerFromStoryboard() {
                    present(viewController, animated: true) {
                        // MARK: Log
                        
                        RealmKit.createUser()
                        ActivityLogManager.registerActiveLog(event: .login, itemID: nil, predicate: nil, image: nil)
                        
                        // beacon検知開始
                        BeaconManager.sharedInstance.start()
                    }
                }
            } else {
                // MARK: Log
                
                ActivityLogManager.registerActiveLog(event: .logout, itemID: nil, predicate: nil, image: nil)
                
                // beacon検知終了
                BeaconManager.sharedInstance.end()
                
                // Log書き出し
                ActivityLogManager.exportLogs()
                
                // データ削除
                RealmKit.deleteUserData()
                // 遷移
                // 2019.11 yang
//                UIApplication.shared.keyWindow!.rootViewController?.dismiss(animated: true, completion: nil)
                if #available(iOS 13, *) {
//                    let keywindow = UIApplication.shared.connectedScenes
//                        .filter { $0.activationState == .foregroundActive }
//                        .map { $0 as? UIWindowScene }
//                        .compactMap { $0 }
//                        .first?.windows
//                        .filter { $0.isKeyWindow }.first
                    let keywindow = UIApplication.shared.windows.first { $0.isKeyWindow }
//                    let keywindow = (UIApplication.shared.connectedScenes.first as! UIWindowScene).windows.first
                    print("keywindow: \(keywindow!.isKeyWindow)")
                    keywindow!.rootViewController?.dismiss(animated: true, completion: nil)
                } else {
                    UIApplication.shared.keyWindow!.rootViewController?.dismiss(animated: true, completion: nil)
                }
                // end
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification?) {
        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height * 0.5))
            self.view.transform = transform
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification?) {
        guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    @objc func pressEnterBtn(_ sender: UIButton) {
        validatePassCode()
    }
    
    @objc func pressBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension PassCodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
