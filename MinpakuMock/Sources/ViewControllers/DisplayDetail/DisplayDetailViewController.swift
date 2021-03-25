//
//  DisplayDetailViewController.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/02/27.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

import AVFoundation
import AVKit
import JTSImageViewController

class MyAVPlayerViewController: AVPlayerViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

class DisplayDetailViewController: UIViewController {
    var viewModel: DisplayDetailViewModel!
    
    @IBOutlet weak var header: GeneralHeader!
    @IBOutlet weak var descriptionTableView: UITableView!
    @IBOutlet weak var tileCollectionView: UICollectionView!
    @IBOutlet weak var hashTagCollectionView: UICollectionView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var whereIsBtn: UIButton!
    @IBOutlet weak var zoomBtn: UIButton!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var noteBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var leftArrowBtn: UIButton!
    @IBOutlet weak var rightArrowBtn: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // viewModel
        viewModel = DisplayDetailViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView
        descriptionTableView.delegate = self
        descriptionTableView.dataSource = self
        
        // register cell
        let tableCellName = String(describing: DetailTableViewCell.self)
        descriptionTableView.register(UINib(nibName: tableCellName, bundle: nil), forCellReuseIdentifier: tableCellName)
        
        // tileCollectionView
        tileCollectionView.delegate = self
        tileCollectionView.dataSource = self
        let tileItemName = String(describing: DetailCollectionViewCell.self)
        tileCollectionView.register(UINib(nibName: tileItemName, bundle: nil), forCellWithReuseIdentifier: tileItemName)
        
        // hashTagCollectionView
        hashTagCollectionView.delegate = self
        hashTagCollectionView.dataSource = self
        let hashTagItemName = String(describing: HashTagCollectionViewCell.self)
        hashTagCollectionView.register(UINib(nibName: hashTagItemName, bundle: nil), forCellWithReuseIdentifier: hashTagItemName)
        
        // btn
        whereIsBtn.addTarget(self, action: #selector(pressWhereIsBtn(_:)), for: .touchUpInside)
        zoomBtn.addTarget(self, action: #selector(pressZoomBtn(_:)), for: .touchUpInside)
        photoBtn.addTarget(self, action: #selector(pressPhotoBtn(_:)), for: .touchUpInside)
        noteBtn.addTarget(self, action: #selector(pressNoteBtn(_:)), for: .touchUpInside)
        favoriteBtn.addTarget(self, action: #selector(pressFavoriteBtn(_:)), for: .touchUpInside)
        leftArrowBtn.addTarget(self, action: #selector(pressLeftArrowBtn(_:)), for: .touchUpInside)
        rightArrowBtn.addTarget(self, action: #selector(pressRightArrowBtn(_:)), for: .touchUpInside)
        header.menuBtn.addTarget(self, action: #selector(pressMenuBtn(_:)), for: .touchUpInside)
        header.backBtn.addTarget(self, action: #selector(pressBackBtn(_:)), for: .touchUpInside)
        
        if viewModel.mokurokus == nil {
            leftArrowBtn.isHidden = true
            rightArrowBtn.isHidden = true
        }
        
        // title
        header.titleLbl.text = "詳細"
        
        // imageView
        if let imageName = self.viewModel.mokuroku.mainImageName() {
            mainImageView.image = UIImage(named: imageName)
        }
        
        // gesture
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        rightSwipeRecognizer.direction = .right
        view.addGestureRecognizer(rightSwipeRecognizer)
        
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        leftSwipeRecognizer.direction = .left
        view.addGestureRecognizer(leftSwipeRecognizer)
        
        // MARK: Log
        
        ActivityLogManager.registerActiveLog(event: .detail, itemID: viewModel.mokuroku.objectID, predicate: nil, image: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // title
        titleLbl.text = viewModel.mokuroku.catTitle
        
        // favorite
        favoriteCheck()
    }
    
    func playVideo(videoName: String) {
        if let path = Bundle.main.path(forResource: videoName, ofType: nil) {
            let player = AVPlayer(url: URL(fileURLWithPath: path))
            let playerController = MyAVPlayerViewController()
            
            playerController.player = player
            present(playerController, animated: true)
            playerController.view.frame = view.frame
            player.play()
            // 0907 yang add start ビデオを見るとき
            
            // MARK: Log
            
            ActivityLogManager.registerActiveLog(event: .video, itemID: viewModel.mokuroku.objectID, predicate: nil, image: nil)
            // 0907 yang add end
        }
    }
    
    func favoriteCheck() {
        var imageName = "btn_bookmark.png"
        if viewModel.isFavorite() {
            imageName = "btn_bookmark_delete.png"
        }
        
        favoriteBtn.setImage(UIImage(named: imageName), for: .normal)
    }
    
    func reloadView() {
        viewModel.detailArray = nil
        viewModel.thumbImageArray = nil
        
        descriptionTableView.reloadData()
        tileCollectionView.reloadData()
        hashTagCollectionView.reloadData()
        // imageView
        if let imageName = self.viewModel.mokuroku.mainImageName() {
            mainImageView.image = UIImage(named: imageName)
            zoomBtn.isHidden = false
        } else {
            mainImageView.image = nil
            zoomBtn.isHidden = true
        }
        // title
        titleLbl.text = viewModel.mokuroku.catTitle
        // favorite
        favoriteCheck()
    }
    
    @objc func pressWhereIsBtn(_ sender: UIButton) {
        if let viewController: WhereIsViewController = WhereIsViewController.viewControllerFromStoryboard() {
            viewController.viewModel.mokuroku = viewModel.mokuroku
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc func pressZoomBtn(_ sender: UIButton) {
        if mainImageView.image != nil {
            let imageInfo = JTSImageInfo()
            
            imageInfo.image = mainImageView.image
            imageInfo.referenceRect = mainImageView.frame
            imageInfo.referenceView = mainImageView.superview
            
            let imageViewer = JTSImageViewController(imageInfo: imageInfo,
                                                     mode: JTSImageViewControllerMode.image,
                                                     backgroundStyle: JTSImageViewControllerBackgroundOptions.blurred)
            imageViewer?.show(from: self, transition: JTSImageViewControllerTransition.fromOriginalPosition)
            ActivityLogManager.registerActiveLog(event: .zoom, itemID: viewModel.mokuroku.objectID, predicate: nil, image: nil)
            // 0907 yang add end
        }
    }
    
    @objc func pressPhotoBtn(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            if let viewController: CameraViewController = CameraViewController.viewControllerFromStoryboard() {
                viewController.viewModel.mokuroku = viewModel.mokuroku
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @objc func pressNoteBtn(_ sender: UIButton) {
        if let viewController: NoteViewController = NoteViewController.viewControllerFromStoryboard() {
            viewController.viewModel.mokuroku = viewModel.mokuroku
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func pressFavoriteBtn(_ sender: UIButton) {
        viewModel.changeFavorite()
        favoriteCheck()
    }
    
    @objc func pressLeftArrowBtn(_ sender: UIButton) {
        viewModel.mokuroku = viewModel.mokurokus[viewModel.changeMokuroku(cnt: -1)]
        reloadView()
        
        // MARK: Log
        
        ActivityLogManager.registerActiveLog(event: .detail, itemID: viewModel.mokuroku.objectID, predicate: nil, image: nil)
    }
    
    @objc func pressRightArrowBtn(_ sender: UIButton) {
        viewModel.mokuroku = viewModel.mokurokus[viewModel.changeMokuroku(cnt: 1)]
        reloadView()
        
        // MARK: Log
        
        ActivityLogManager.registerActiveLog(event: .detail, itemID: viewModel.mokuroku.objectID, predicate: nil, image: nil)
    }
    
    @objc func panGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            viewModel.mokuroku = viewModel.mokurokus[viewModel.changeMokuroku(cnt: 1)]
            reloadView()
        case .left:
            viewModel.mokuroku = viewModel.mokurokus[viewModel.changeMokuroku(cnt: -1)]
            reloadView()
            
        default:
            print("default")
            viewModel.mokuroku = viewModel.mokurokus[viewModel.changeMokuroku(cnt: 1)]
            reloadView()
        }
    }
    
    @objc func pressMenuBtn(_ sender: UIButton) {
        if let viewController: MenuNavigationController = MenuNavigationController.viewControllerFromStoryboard() {
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc func pressBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        // 2019.08.31 yang add start 戻るボータンを押したら、閉じる時間を記録
        
        // MARK: Log
        
        ActivityLogManager.registerActiveLog(event: .detail, itemID: viewModel.mokuroku.objectID, predicate: nil, image: nil)
        // 2019.08.31 yang add end
    }
}

extension DisplayDetailViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.details().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailTableViewCell.self),
                                                    for: indexPath) as? DetailTableViewCell {
            let detail = viewModel.details()[indexPath.item]
            cell.detail = detail
            cell.refresh()
            cell.viewController = self
            
            return cell
        }
        return UITableViewCell()
    }
}

extension DisplayDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isEqual(tileCollectionView) {
            // tileCollectionView
            return viewModel.thumbImages().count
            
        } else {
            // hashTagCollectionView
            return viewModel.mokuroku.hashTags.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.isEqual(tileCollectionView) {
            // tileCollectionView
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailCollectionViewCell.self),
                                                             for: indexPath) as? DetailCollectionViewCell {
                if let imageName = self.viewModel?.thumbImages()[indexPath.item] {
                    cell.imageName = imageName
                    cell.fill()
                }
                return cell
            }
            return ItemCollectionViewCell()
            
        } else {
            // hashTagCollectionView
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HashTagCollectionViewCell.self),
                                                             for: indexPath) as? HashTagCollectionViewCell {
                cell.tagLbl.text = "#" + viewModel.mokuroku.hashTags[indexPath.item].str
                
                return cell
            }
            return HashTagCollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isEqual(tileCollectionView) {
            // tileCollectionView
            collectionView.deselectItem(at: indexPath, animated: false)
            let fileName = viewModel.thumbImages()[indexPath.item]
            if !fileName.contains("jpg") {
                playVideo(videoName: fileName)
            } else {
                mainImageView.image = UIImage(named: fileName)
            }
            
        } else {
            // hashTagCollectionView
            if let viewController: SearchResultViewController = SearchResultViewController.viewControllerFromStoryboard() {
                viewController.viewModel.search(query: viewModel.mokuroku.hashTagQueryString(index: indexPath.item))
                viewController.viewModel.searchKeys = [Mokuroku.SearchKey.hashTag.rawValue]
                viewController.viewModel.searchWords = [viewModel.mokuroku.hashTags[indexPath.item].str]
                
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

extension DisplayDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.isEqual(tileCollectionView) {
            // tileCollectionView
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            
        } else {
            // hashTagCollectionView
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.isEqual(tileCollectionView) {
            // tileCollectionView
            let bounds = tileCollectionView.bounds
            let width = bounds.height - 10
            return CGSize(width: width, height: width)
            
        } else {
            // hashTagCollectionView
            let width = UILabel.textWidth(font: UIFont.boldSystemFont(ofSize: 22), text: "#" + viewModel.mokuroku.hashTags[indexPath.item].str)
            return CGSize(width: width + 8, height: 32)
        }
    }
}
