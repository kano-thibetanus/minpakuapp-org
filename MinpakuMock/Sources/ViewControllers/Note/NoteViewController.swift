//
//  NoteViewController.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/08.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    var viewModel: NoteViewModel!
    @IBOutlet weak var drawView: ACEDrawingView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var undoBtn: UIButton!
    @IBOutlet weak var redoBtn: UIButton!
    @IBOutlet weak var allResetBtn: UIButton!
    @IBOutlet weak var pencilSlider: UISlider!
    
    @IBOutlet weak var pencilBlack: Pencil!
    @IBOutlet weak var pencilRed: Pencil!
    @IBOutlet weak var pencilBlue: Pencil!
    @IBOutlet weak var pencilGreen: Pencil!
    @IBOutlet weak var pencilWhite: Pencil!
    
    var pencils: [Pencil] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // viewModel
        viewModel = NoteViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the delegate
        drawView.delegate = self
        drawView.drawMode = .scale
        
        // start with a black pen
        pencilSlider.value = Float(drawView.lineWidth)
        pencilSlider.setThumbImage(UIImage(named: "paint_slider_knob"), for: .normal)
        
        // btn
        saveBtn.addTarget(self, action: #selector(pressSaveBtn(_:)), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(pressBackBtn(_:)), for: .touchUpInside)
        undoBtn.addTarget(self, action: #selector(pressUndoBtn(_:)), for: .touchUpInside)
        redoBtn.addTarget(self, action: #selector(pressRedoBtn(_:)), for: .touchUpInside)
        allResetBtn.addTarget(self, action: #selector(pressAllResetBtn(_:)), for: .touchUpInside)
        pencilBlack.addTarget(self, action: #selector(pressPencilBlackBtn(_:)), for: .touchUpInside)
        pencilRed.addTarget(self, action: #selector(pressPencilRedBtn(_:)), for: .touchUpInside)
        pencilBlue.addTarget(self, action: #selector(pressPencilBlueBtn(_:)), for: .touchUpInside)
        pencilGreen.addTarget(self, action: #selector(pressPencilGreenBtn(_:)), for: .touchUpInside)
        pencilWhite.addTarget(self, action: #selector(pressPencilWhiteBtn(_:)), for: .touchUpInside)
        pencilSlider.addTarget(self, action: #selector(slidePencilSlider(_:)), for: .valueChanged)
        
        pencils.append(pencilBlack)
        pencils.append(pencilRed)
        pencils.append(pencilBlue)
        pencils.append(pencilGreen)
        pencils.append(pencilWhite)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 目録詳細から来た場合画像があるか確認
        if let alreadyImage = self.viewModel.getImage() {
            drawView.loadImage(alreadyImage)
            viewModel.isCreate = false
        }
        
        colorChange(pencil: pencilBlack)
    }
    
    func colorChange(pencil: Pencil) {
        for pen in pencils where pen.isLong {
            // AutoLayout解除
            pen.translatesAutoresizingMaskIntoConstraints = true
            let rect = CGRect(x: pen.frame.origin.x,
                              y: pen.frame.origin.y + pen.frame.size.height * 0.5,
                              width: pen.frame.size.width,
                              height: pen.frame.size.height * 0.5)
            pen.layer.frame = rect
            pen.isLong = false
        }
        if !pencil.isLong {
            let rect = CGRect(x: pencil.frame.origin.x,
                              y: pencil.frame.origin.y - pencil.frame.size.height * 1.0,
                              width: pencil.frame.size.width,
                              height: pencil.frame.size.height * 2.0)
            pencil.layer.frame = rect
            pencil.isLong = true
        }
    }
    
    @objc func pressSaveBtn(_ sender: UIButton) {
        viewModel.saveImage(image: drawView.image, isCreate: viewModel.isCreate)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func pressBackBtn(_ sender: UIButton) {
        let alert: UIAlertController = UIAlertController(title: "前の画面へ戻る", message: "保存せずに終了しますか？", preferredStyle: UIAlertController.Style.alert)
        
        // OKボタン
        let defaultAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func pressUndoBtn(_ sender: UIButton) {
        drawView.undoLatestStep()
    }
    
    @objc func pressRedoBtn(_ sender: UIButton) {
        drawView.redoLatestStep()
    }
    
    @objc func pressAllResetBtn(_ sender: UIButton) {
        drawView.clear()
    }
    
    @objc func pressPencilBlackBtn(_ sender: Pencil) {
        drawView.lineColor = UIColor.black
        colorChange(pencil: sender)
    }
    
    @objc func pressPencilRedBtn(_ sender: Pencil) {
        drawView.lineColor = UIColor.red
        colorChange(pencil: sender)
    }
    
    @objc func pressPencilBlueBtn(_ sender: Pencil) {
        drawView.lineColor = UIColor.blue
        colorChange(pencil: sender)
    }
    
    @objc func pressPencilGreenBtn(_ sender: Pencil) {
        drawView.lineColor = UIColor.green
        colorChange(pencil: sender)
    }
    
    @objc func pressPencilWhiteBtn(_ sender: Pencil) {
        drawView.lineColor = UIColor.white
        colorChange(pencil: sender)
    }
    
    @objc func slidePencilSlider(_ sender: UISlider) {
        drawView.lineWidth = CGFloat(sender.value)
    }
}

extension NoteViewController: ACEDrawingViewDelegate {}
