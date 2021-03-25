//
//  SearchViewController.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/02/27.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    var viewModel: SearchViewModel!
    @IBOutlet weak var header: GeneralHeader!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var freeWordTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var peapleTextField: UITextField!
    @IBOutlet weak var owcTextField: UITextField!
    @IBOutlet weak var ocmTextField: UITextField!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // viewModel
        viewModel = SearchViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // notification
        configureObserver()
        
        // textField
        freeWordTextField.delegate = self
        titleTextField.delegate = self
        placeTextField.delegate = self
        peapleTextField.delegate = self
        owcTextField.delegate = self
        ocmTextField.delegate = self
        
        // btn
        header.menuBtn.addTarget(self, action: #selector(pressMenuBtn(_:)), for: .touchUpInside)
        header.backBtn.addTarget(self, action: #selector(pressBackBtn(_:)), for: .touchUpInside)
        searchBtn.addTarget(self, action: #selector(pressSearchBtn(_:)), for: .touchUpInside)
        
        // title
        header.titleLbl.text = "調べる"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func search() {
        if let viewController: SearchResultViewController = SearchResultViewController.viewControllerFromStoryboard() {
            let searchPredicates = viewModel.searchQuerys(viewController: self)
            viewController.viewModel.search(querys: searchPredicates)
            viewController.viewModel.searchKeys = viewModel.searchKeys(viewController: self)
            viewController.viewModel.searchWords = viewModel.searchWords(viewController: self)
            
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        // MARK: Log
        
        ActivityLogManager.registerActiveLog(event: .search, itemID: nil, predicate: nil, image: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification?) {
        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height * 0.34))
            self.view.transform = transform
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification?) {
        guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    @objc func pressSearchBtn(_ sender: UIButton) {
        search()
    }
    
    @objc func pressMenuBtn(_ sender: UIButton) {
        if let viewController: MenuNavigationController = MenuNavigationController.viewControllerFromStoryboard() {
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc func pressBackBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        search()
        
        return true
    }
}
