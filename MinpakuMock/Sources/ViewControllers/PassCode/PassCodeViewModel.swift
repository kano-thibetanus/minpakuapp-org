//
//  PassCodeViewModel.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/18.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class PassCodeViewModel: NSObject {
    var isLogin = true
    
    override init() {
        super.init()
    }
    
    func headerLblTxt() -> String {
        if isLogin {
            return "ガイド開始"
        }
        return "ガイド終了"
    }
    
    func guidanceLblTxt() -> String {
        if isLogin {
            return "ガイドを開始するための\nパスワードを入力してください。"
        }
        return "ガイドを終了するための\nパスワードを入力してください。"
    }
    
    func validatePass(pass: String) -> Bool {
        return pass == "111111"
    }
}
