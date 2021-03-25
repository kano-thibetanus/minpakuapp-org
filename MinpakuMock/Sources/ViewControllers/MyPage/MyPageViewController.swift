//
//  MyPageViewController.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/02/27.
//  Copyright © 2019 hiratti. All rights reserved.
//

import JTSImageViewController
import UIKit

class MyPageViewController: UIViewController {
    var viewModel: MyPageViewModel!
    
    @IBOutlet weak var header: GeneralHeader!
    @IBOutlet weak var collectionView: UICollectionView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // viewModel
        viewModel = MyPageViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // btn
        header.menuBtn.addTarget(self, action: #selector(pressMenuBtn(_:)), for: .touchUpInside)
        header.backBtn.addTarget(self, action: #selector(pressBackBtn(_:)), for: .touchUpInside)
        
        // collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellName = String(describing: MyPageCollectionViewCell.self)
        collectionView.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        let headerName = String(describing: MyPageCollectionReusableView.self)
        collectionView?.register(UINib(nibName: headerName, bundle: nil),
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: headerName)
        
        // title
        header.titleLbl.text = "マイページ"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    func showImageViewer(data: Data?, orientation: UIImage.Orientation) {
        let imageInfo = JTSImageInfo()
        if let uiImage = UIImage(data: data ?? Data())?.tint(color: UIColor.white) {
            let orientationImage = UIImage(cgImage: uiImage.cgImage!, scale: uiImage.scale, orientation: orientation)
            imageInfo.image = orientationImage
        }
        
        let imageViewer = JTSImageViewController(imageInfo: imageInfo,
                                                 mode: JTSImageViewControllerMode.image,
                                                 backgroundStyle: JTSImageViewControllerBackgroundOptions.blurred)
        imageViewer?.show(from: self, transition: JTSImageViewControllerTransition.fromOffscreen)
    }
    
    func showImageViewer(any: Any?) {
        if let rec = any {
            if type(of: rec) == Photo.self {
                if let photo = rec as? Photo {
                    showImageViewer(data: photo.image, orientation: .left)
                }
            } else if type(of: rec) == Note.self {
                if let note = rec as? Note {
                    showImageViewer(data: note.image, orientation: .up)
                }
            }
        }
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

extension MyPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sectionNumber()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MyPageCollectionViewCell.self),
                                                         for: indexPath) as? MyPageCollectionViewCell {
            cell.record = viewModel.recordForIndexPath(indexPath: indexPath)
            cell.fill()
            cell.cameraBtnAction = { self.showImageViewer(any: $0) }
            cell.memoBtnAction = { self.showImageViewer(any: $0) }
            
            return cell
        }
        return ItemCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                            withReuseIdentifier: String(describing: MyPageCollectionReusableView.self),
                                                                            for: indexPath) as? MyPageCollectionReusableView {
                header.sectionLbl.text = viewModel.sectionName(section: indexPath.section)
                return header
            }
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rec = viewModel.recordForIndexPath(indexPath: indexPath)
        if type(of: rec) == Favorite.self {
            if let favorite = rec as? Favorite,
                let viewController: DisplayDetailViewController = DisplayDetailViewController.viewControllerFromStoryboard() {
                viewController.viewModel.mokuroku = favorite.mokuroku
                viewController.viewModel.mokurokus = viewModel.favorites.map { ($0.mokuroku ?? nil)! }
                viewController.viewModel.mokurokuIndex = indexPath.row
                viewController.viewModel.currentMokurokuIndex = indexPath.row
                
                navigationController?.pushViewController(viewController, animated: true)
            }
        } else {
            showImageViewer(any: rec)
        }
    }
}

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = self.collectionView.bounds
        let width = (bounds.width / 5) - 10
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: viewModel.sectionBoundsHeight(section: section))
    }
}
