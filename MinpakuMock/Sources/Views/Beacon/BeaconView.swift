//
//  BeaconView.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/04/02.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class BeaconView: UIImageView {
    var circleLayer: CAShapeLayer!
    var beacon: Beacon!
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        circleLayer = CAShapeLayer()
        circleLayer.frame = bounds
        circleLayer.fillColor = UIColor.black.withAlphaComponent(0.2).cgColor
        circleLayer.needsDisplayOnBoundsChange = true
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        let startPath = UIBezierPath(ovalIn: bounds).cgPath
        circleLayer.path = startPath
        
        let endSize = CGSize(width: 60, height: 60)
        let inset = (bounds.width / 2) - (endSize.width / 2)
        let endRect = bounds.insetBy(dx: inset,
                                     dy: inset)
        
        let endPath = UIBezierPath(ovalIn: endRect).cgPath
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = endPath
        pathAnimation.duration = 2
        pathAnimation.fillMode = .forwards
        pathAnimation.isRemovedOnCompletion = false
        
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1
        fadeOutAnimation.toValue = 0
        fadeOutAnimation.duration = 1
        fadeOutAnimation.beginTime = 2
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = pathAnimation.duration + fadeOutAnimation.duration
        animationGroup.repeatCount = .infinity
        animationGroup.animations = [pathAnimation, fadeOutAnimation]
        
        circleLayer.add(animationGroup,
                        forKey: nil)
    }
}
