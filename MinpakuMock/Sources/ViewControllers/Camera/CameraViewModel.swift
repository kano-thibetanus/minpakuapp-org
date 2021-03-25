//
//  CameraViewModel.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/18.
//  Copyright © 2019 hiratti. All rights reserved.
//

import RealmSwift
import UIKit

class CameraViewModel: NSObject {
    var mokuroku: Mokuroku!
    
    override init() {
        super.init()
    }
    
    func saveImage(image: UIImage) {
        let imageData = Photo.saveImage(mokuroku: mokuroku, uiImage: image)
        
        // MARK: Log
        
        ActivityLogManager.registerActiveLog(event: .photoCreate, itemID: nil, predicate: nil, image: imageData)
    }
}
