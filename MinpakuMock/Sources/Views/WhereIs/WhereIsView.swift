//
//  WhereIsView.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/22.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class WhereIsView: UIImageView {
    // 表示する配列
    let numList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
    let alpList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N"]
    
    func getArea(shelf: Shelf?) -> String {
        if let safeShelf = shelf {
            let verticalSpace = Int(frame.height) / numList.count
            let verticalIndex = safeShelf.y() / verticalSpace
            
            let horizonSpace = Int(frame.width) / alpList.count
            let horizonIndex = safeShelf.x() / horizonSpace
            return String(format: "%@%d", alpList[horizonIndex], numList[verticalIndex])
        }
        
        return ""
    }
    
    func highLightArea(shelf: Shelf?) {
        if let safeShelf = shelf {
            let verticalSpace = frame.height / CGFloat(numList.count)
            let verticalIndex = safeShelf.y() / Int(verticalSpace)
            
            let horizonSpace = frame.width / CGFloat(alpList.count)
            let horizonIndex = safeShelf.x() / Int(horizonSpace)
            
            let highLightImage = UIImage.image(color: UIColor.red, size: CGSize(width: horizonSpace, height: verticalSpace))
            let highLightImageView = UIImageView(frame: CGRect(x: horizonSpace * CGFloat(horizonIndex),
                                                               y: verticalSpace * CGFloat(verticalIndex),
                                                               width: horizonSpace,
                                                               height: verticalSpace))
            highLightImageView.image = highLightImage
            highLightImageView.alpha = 0.7
            addSubview(highLightImageView)
        }
    }
    
    func addGrid() {
        // 描画するレイヤーを作成する
        let gridLayer = CAShapeLayer()
        gridLayer.frame = bounds
        
        // 線の色
        gridLayer.strokeColor = UIColor(red: 93.0 / 255.0, green: 94.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0).cgColor
        // 線の太さ
        gridLayer.lineWidth = 1.0
        
        let gridLine = UIBezierPath()
        
        // 横線の描画
        let horizonLineNum = 14
        let horizonSpillSpace = CGFloat(0)
        let horizonLineSpace = frame.height / CGFloat(horizonLineNum - 1)
        var horizonStartPoint = CGPoint(x: -horizonSpillSpace, y: 0)
        var horizonEndPoint = CGPoint(x: frame.width + horizonSpillSpace, y: 0)
        for _ in 0 ..< horizonLineNum {
            gridLine.move(to: horizonStartPoint)
            gridLine.addLine(to: horizonEndPoint)
            horizonStartPoint.y += horizonLineSpace
            horizonEndPoint.y += horizonLineSpace
        }
        
        // 縦線を描画
        let verticalLineNum = 15
        let verticalSpillSpace = CGFloat(0)
        let verticalLineSpace = frame.width / CGFloat(verticalLineNum - 1)
        var verticalStartPoint = CGPoint(x: 0, y: -verticalSpillSpace)
        var verticalEndPoint = CGPoint(x: 0, y: frame.height + verticalSpillSpace)
        for _ in 0 ..< verticalLineNum {
            gridLine.move(to: verticalStartPoint)
            gridLine.addLine(to: verticalEndPoint)
            verticalStartPoint.x += verticalLineSpace
            verticalEndPoint.x += verticalLineSpace
        }
        
        // 線を描画
        gridLayer.path = gridLine.cgPath
        
        layer.addSublayer(gridLayer)
    }
    
    func addLbl() {
        addAlpLbl()
        addNumLbl()
    }
    
    func addAlpLbl() {
        // アルファベットのラベル
        // フォント
        let alpFont = UIFont.boldSystemFont(ofSize: 22)
        // カラー
        let alpFontColor = UIColor(red: 32.0 / 255.0, green: 72.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
        // ラベルのサイズ
        let alpLblSize = CGSize(width: 36, height: 30)
        // 最初のラベルの位置調整
        let alpFirstLblSpace = CGFloat(20.0)
        // ImageViewからはみ出す長さ
        let alpUpSpillSpace = CGFloat(50.0)
        let alpLowerSpillSpace = CGFloat(20.0)
        // ラベルの間隔
        let alpLblSpace = frame.width / CGFloat(alpList.count)
        // 上のラベルの初期位置
        var alpUpLblPoint = CGPoint(x: alpLblSpace * 0.5 - alpFirstLblSpace, y: -alpUpSpillSpace)
        // 右のラベルの初期位置
        var alpLowerLblPoint = CGPoint(x: alpLblSpace * 0.5 - alpFirstLblSpace, y: frame.height + alpLowerSpillSpace)
        for alphabet in alpList {
            // 上のラベル
            let upRect = CGRect(x: alpUpLblPoint.x,
                                y: alpUpLblPoint.y,
                                width: alpLblSize.width,
                                height: alpLblSize.height)
            let upLbl = UILabel(frame: upRect)
            upLbl.font = alpFont
            upLbl.textColor = alpFontColor
            upLbl.text = String(describing: alphabet)
            upLbl.textAlignment = NSTextAlignment.center
            addSubview(upLbl)
            // 下のラベル
            let lowerRect = CGRect(x: alpLowerLblPoint.x,
                                   y: alpLowerLblPoint.y,
                                   width: alpLblSize.width,
                                   height: alpLblSize.height)
            let lowerLbl = UILabel(frame: lowerRect)
            lowerLbl.text = String(describing: alphabet)
            lowerLbl.font = alpFont
            lowerLbl.textColor = alpFontColor
            lowerLbl.textAlignment = NSTextAlignment.center
            addSubview(lowerLbl)
            
            alpUpLblPoint.x += alpLblSpace
            alpLowerLblPoint.x += alpLblSpace
        }
    }
    
    func addNumLbl() {
        // 数字のラベル
        // フォント
        let numFont = UIFont.boldSystemFont(ofSize: 22)
        // カラー
        let numFontColor = UIColor(red: 32.0 / 255.0, green: 72.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
        // ラベルのサイズ
        let numLblSize = CGSize(width: 36, height: 30)
        // 最初のラベルの位置調整
        let numFirstLblSpace = CGFloat(15.0)
        // ImageViewからはみ出す長さ
        let numLeftSpillSpace = CGFloat(50.0)
        let numRightSpillSpace = CGFloat(30.0)
        // ラベルの間隔
        let numLblSpace = frame.height / CGFloat(numList.count)
        // 左のラベルの初期位置
        var numLeftLblPoint = CGPoint(x: -numLeftSpillSpace, y: numLblSpace * 0.5 - numFirstLblSpace)
        // 右のラベルの初期位置
        var numRightLblPoint = CGPoint(x: frame.width + numRightSpillSpace, y: numLblSpace * 0.5 - numFirstLblSpace)
        for num in numList {
            // 右のラベル
            let leftRect = CGRect(x: numLeftLblPoint.x,
                                  y: numLeftLblPoint.y,
                                  width: numLblSize.width,
                                  height: numLblSize.height)
            let leftLbl = UILabel(frame: leftRect)
            leftLbl.font = numFont
            leftLbl.textColor = numFontColor
            leftLbl.text = String(describing: num)
            leftLbl.textAlignment = NSTextAlignment.center
            addSubview(leftLbl)
            // 左のラベル
            let rightRect = CGRect(x: numRightLblPoint.x,
                                   y: numRightLblPoint.y,
                                   width: numLblSize.width,
                                   height: numLblSize.height)
            let rightLbl = UILabel(frame: rightRect)
            rightLbl.text = String(describing: num)
            rightLbl.font = numFont
            rightLbl.textColor = numFontColor
            rightLbl.textAlignment = NSTextAlignment.center
            addSubview(rightLbl)
            
            numLeftLblPoint.y += numLblSpace
            numRightLblPoint.y += numLblSpace
        }
    }
}
