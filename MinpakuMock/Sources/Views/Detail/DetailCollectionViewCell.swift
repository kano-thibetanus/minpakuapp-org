//
//  DetailCollectionViewCell.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/12.
//  Copyright © 2019 hiratti. All rights reserved.
//

import AssetsLibrary
import AVFoundation
import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    var imageName: String = ""
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    
    public func fill() {
        if imageName.contains("jpg") {
            playImageView.isHidden = true
            
            imageView.image = UIImage(named: imageName)
        } else {
            playImageView.isHidden = false
            
            do {
                if let path = Bundle.main.path(forResource: self.imageName.components(separatedBy: ".")[0], ofType: "mp4") {
                    let fileURL = URL(fileURLWithPath: path)
                    let avAsset = AVURLAsset(url: fileURL, options: nil)
                    
                    let imgGenerator = AVAssetImageGenerator(asset: avAsset)
                    imgGenerator.appliesPreferredTrackTransform = true
                    let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 90, timescale: 30), actualTime: nil)
                    let thumbnail = UIImage(cgImage: cgImage)
                    imageView.image = thumbnail
                } else {
                    imageView.image = UIImage(named: "nophoto")
                }
            } catch {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
            }
        }
    }
}
