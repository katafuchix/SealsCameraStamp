//
//  BaseViewController.swift
//  SealsCameraStamp
//
//  Created by cano on 2016/10/10.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit
import AVFoundation

enum EditStatus : Int {
    case Not = 0
    case Stamp = 1
    case Pen = 2
    case Frame = 3
    case Filter = 4
}

class BaseViewController: UIViewController, ZDStickerViewDelegate, buttonSelectDelegate, filterSelectDelegate, penSelectDelegate, colorPickerDelegate {

    let HEADER_VIEW_HEIGHT : CGFloat = 50.0
    let AD_VIEW_HEIGHT : CGFloat = 50.0
    let MENU_VIEW_HEIGHT : CGFloat = 75.0
    
    var status : EditStatus?
    var pData = PublicDatas.getPublicDatas()
    
    //@IBOutlet weak var imageView: UIImageView!
    var image : UIImage?
    var imageView: UIImageView?
    var backgroundImageView: UIImageView?
    
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var filterContainer: UIView!
    @IBOutlet weak var filterContainerTopConstraint: NSLayoutConstraint!
    
    var isShowFilter : Bool = false
    
    @IBOutlet weak var penContainer: UIView!
    @IBOutlet weak var penContainerTopConstraint: NSLayoutConstraint!
    var isShowPen: Bool = false
    var penViewController : PenViewController?
    
    var currentlyEditingView : ZDStickerView?
    var ZDStickerViews:Array<ZDStickerView>?
    
    var frameView:FrameView?
    
    @IBOutlet weak var headerView: UIImageView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var undoBtn: UIButton!
    @IBOutlet weak var eraserBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 50.0, width: self.view.frame.width, height: self.view.frame.width))
        self.imageView?.contentMode = .scaleAspectFit
        self.imageView?.image = image
        self.view.addSubview(self.imageView!)
        
        self.backgroundImageView = UIImageView(frame: CGRect(x: 0, y: self.view.frame.width, width: self.view.frame.width, height: self.view.frame.height - self.view.frame.width))
        self.backgroundImageView?.contentMode = .scaleAspectFit
        self.backgroundImageView?.image = UIImage(named:"iphone5_bg_under.png")
        self.view.addSubview(self.backgroundImageView!)
        self.view.bringSubview(toFront: undoBtn)
        self.view.bringSubview(toFront: eraserBtn)
        self.view.bringSubview(toFront: menuContainer)
        
        penViewController = self.childViewControllers[0] as? PenViewController
        penViewController!.delegate = self
        self.penContainerTopConstraint.constant = self.view.frame.size.height
        
        self.filterContainerTopConstraint.constant = self.view.frame.size.height
        let filterViewController = self.childViewControllers[1] as! FilterViewController
        filterViewController.setImageFile(image: (self.imageView?.image!)!)
        filterViewController.delegate = self
        
        let buttonViewController = self.childViewControllers[2] as! ButtonViewController
        buttonViewController.delegate = self
    }

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    @IBAction func onHome(_ sender: AnyObject) {
        //アラートを表示する
        let okAction = UIAlertAction(title: "OK", style: .default) {
            action in NSLog("OK！")
            self.navigationController?.popToRootViewController(animated: true)
        }
        var message = "";
        if CommonUtil.isJa() {
            message = "編集中の画像があります。\nHOMEへ戻りますか？"
        }else{
            message = "Image is editing.\n Do you come back to the first screen?"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
            action in NSLog("キャンセル")
            self.dismiss(animated: true, completion: nil)
        }
        
        let alert = CommonUtil.createAlertOKCancel(message: message, okAction: okAction, cancelAction: cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: AnyObject) {
        let cropImage = getImage()
        UIImageWriteToSavedPhotosAlbum(cropImage, self, #selector(BaseViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func getImage()->UIImage {
        //unFocus()
        var r = AVMakeRect(aspectRatio: self.imageView!.image!.size, insideRect: self.imageView!.frame)
        if frameView != nil && frameView!.isDescendant(of: imageView!) {
            r = CGRect(x:0, y:50.0, width:frameView!.frame.size.width, height:frameView!.frame.size.height)
        }
        // self.viewを画像化
        let viewImg = UtilManager.getUIImageFromUIView(myUIView: self.view)
        
        // imageViewのimageを切り取る
        let cropImage = self.cropImage(image: viewImg, rect:
            CGRect(
                x:r.origin.x ,
                y:r.origin.y ,
                width:r.size.width,
                height:r.size.height
            )
        )
        return cropImage
    }
    
    func cropImage(image:UIImage, rect:CGRect)->UIImage {
        let scale = image.scale
        
        let cliprect = CGRect(x: rect.origin.x * scale, y:rect.origin.y * scale,
                              width:rect.size.width * scale, height:rect.size.height * scale)
        // ソース画像からCGImageRefを取り出す
        let srcImgRef : CGImage = image.cgImage!
        
        // 指定された範囲を切り抜いたCGImageRefを生成しUIImageとする
        let imgRef : CGImage = srcImgRef.cropping(to: cliprect)!
        let resultImage : UIImage = UIImage(cgImage: imgRef, scale: scale, orientation: image.imageOrientation)
        
        // 後片付け
        //CGImageRelease(imgRef)
        return resultImage
    }
    
    // 画像保存時のセレクタ
    func image(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        
        var message : String?
        if error == nil {
            if CommonUtil.isJa() {
                message = "画像を保存しました"
            }else{
                message = "saved successfully."
            }
        }
        // 処理の完了時にはアラートを出す
        let alert = UIAlertController(title: message!, message: "", preferredStyle: .alert)
        // OKボタンを追加
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        // 表示
        present(alert, animated: true, completion: nil)
    }
    
    func chgStatus(_ editStatus:EditStatus){
        
        status = editStatus
        
        if status == EditStatus.Pen {
            self.pData.setData(value: false as AnyObject, key: "clear")
        }else{
            // ペン以外のときはペンの描画を無効にしておく
            //self.disableDraw()
        }
        if status == EditStatus.Stamp {
            pData.setData(value: "" as AnyObject, key: "bundleName")
            pData.setData(value: "" as AnyObject, key: "imageName")
            return
        }
        
        // スタンプーフレームの変更時
        let views = self.view.subviews.reversed()
        for view in views {
            //print("view : \(view)")
            if view is ZDStickerView {
                let z = view as! ZDStickerView
                z.hideEditingHandles()
            }
        }
    }
    
    // menu button
    func buttonSelect(index:Int) {
        print(index)
        switch index {
        case 0:
            hidePen()
            chgStatus(EditStatus.Filter)
            if !isShowFilter {
                showFilter()
            }else{
                hideFilter()
            }
        case 4:
            hideFilter()
            chgStatus(EditStatus.Pen)
            if !isShowPen {
                showPen()
            }else{
                hidePen()
            }
            break
        case 5:
            hideFilter()
            hidePen()
            showFrameSelectViewController()
            break
        default:
            hideFilter()
            hidePen()
            chgStatus(EditStatus.Stamp)
            showSelectViewController(index)
            break
        }
    }
    
    func onFilter(sender:AnyObject) {
        //StampTopConstraint.constant = self.view.frame.height - 240
        if isShowFilter {
            hideFilter()
        }else{
            showFilter()
        }
    }
    
    func showFilter(){
        self.view.bringSubview(toFront: filterContainer)
        self.view.bringSubview(toFront: menuContainer)
        UIView.animate(withDuration: 0.2, animations: {
            self.filterContainerTopConstraint.constant = self.view.frame.size.height - (self.MENU_VIEW_HEIGHT + self.filterContainer.frame.size.height)
            //print("self.filterContainerTopConstraint.constant : \(self.filterContainerTopConstraint.constant)")
            //+= self.filterContainer.frame.size.height
            //self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            //self.view.setNeedsUpdateConstraints()
            },completion: {
                finished in
                self.isShowFilter = true
                //print(self.filterContainer.frame)
            }
        )
    }
    
    func hideFilter(){
        UIView.animate(withDuration: 0.2, animations: {
            self.filterContainerTopConstraint.constant = self.view.frame.size.height + self.filterContainer.frame.size.height
            //print("self.filterContainerTopConstraint.constant : \(self.filterContainerTopConstraint.constant)")
            //self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            //self.view.setNeedsUpdateConstraints()
            }, completion: {
                finished in
                self.isShowFilter = false
                //print(self.filterContainer.frame)
        } )
    }
    
    func filterSelect(index:Int){
        //print(index)
        applyFilter(selectedFilterIndex: index)
    }
    
    // apply filter to current image
    private func applyFilter(selectedFilterIndex filterIndex: Int) {
        let filterViewController = self.childViewControllers[1] as! FilterViewController
        
        print("Filter - \(filterViewController.filterNameList[filterIndex])")
        
        /* filter name
         0 - NO Filter,
         1 - PhotoEffectChrome, 2 - PhotoEffectFade, 3 - PhotoEffectInstant, 4 - PhotoEffectMono,
         5 - PhotoEffectNoir, 6 - PhotoEffectProcess, 7 - PhotoEffectTonal, 8 - PhotoEffectTransfer
         */
        
        // if No filter selected then apply default image and return.
        if filterIndex == 0 {
            // set image selected image
            self.imageView?.image = self.image
            return
        }
        
        
        // Create and apply filter
        // 1 - create source image
        let sourceImage = CIImage(image: self.image!)
        
        // 2 - create filter using name
        let myFilter = CIFilter(name: filterViewController.filterNameList[filterIndex])
        myFilter?.setDefaults()
        
        // 3 - set source image
        myFilter?.setValue(sourceImage, forKey: kCIInputImageKey)
        
        // 4 - create core image context
        let context = CIContext(options: nil)
        
        // 5 - output filtered image as cgImage with dimension.
        let outputCGImage = context.createCGImage(myFilter!.outputImage!, from: myFilter!.outputImage!.extent)
        
        // 6 - convert filtered CGImage to UIImage
        let filteredImage = UIImage(cgImage: outputCGImage!)
        
        // 7 - set filtered image to preview
        self.imageView?.image = filteredImage
    }
    
    // 画像がフルサイズの場合20pxほど長くなる　対応が必要
    func addDrawView() {
        let r = AVMakeRect(aspectRatio: self.imageView!.image!.size, insideRect: self.imageView!.frame)
        print("r : \(r)")
        //let r = self.imageView!.frame
        let drawBase = DrawBase(frame:r)
        imageView!.isUserInteractionEnabled = true
        drawBase.isUserInteractionEnabled = true
        print(drawBase.frame)
        //drawBase.backgroundColor = UIColor.black
        self.view.addSubview(drawBase)
    }
    
    func onPen(_ sender:AnyObject) {
        //StampTopConstraint.constant = self.view.frame.height - 240
        
        if isShowPen {
            hidePen()
        }else{
            showPen()
        }
    }
    
    func penSelect() {
        self.pData.setData(value: false as AnyObject, key: "clear")
        // ビューコントローラーを取得
        let story = UIStoryboard(name: "Main", bundle: nil)
        let colorVC = story.instantiateViewController(withIdentifier: "ColorPickerViewController") as! ColorPickerViewController
        colorVC.delegate = self
        colorVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //self.modalPresentationStyle = .CurrentContext
        self.present(colorVC, animated: true, completion: nil)
    }
    
    func showPen(){
        //self.view.bringSubviewToFront(filterContainer)
        //self.view.bringSubviewToFront(menuContainer)
        self.view.bringSubview(toFront: penContainer)
        self.view.bringSubview(toFront: menuContainer)
        UIView.animate(withDuration: 0.2, animations: {
            self.penContainerTopConstraint.constant = self.view.frame.size.height - (self.AD_VIEW_HEIGHT + self.MENU_VIEW_HEIGHT + self.penContainer.frame.size.height)
            print("self.penContainerTopConstraint.constant : \(self.penContainerTopConstraint.constant)")
            //+= self.filterContainer.frame.size.height
            //self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            //self.view.setNeedsUpdateConstraints()
            },completion: {
                finished in
                self.isShowPen = true
                //print(self.filterContainer.frame)
                self.addDrawView()
            }
        )
    }
    
    func hidePen(){
        UIView.animate(withDuration: 0.2, animations: {
            self.penContainerTopConstraint.constant = self.view.frame.size.height + self.penContainer.frame.size.height
            print("self.penContainerTopConstraint.constant : \(self.penContainerTopConstraint.constant)")
            //self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            //self.view.setNeedsUpdateConstraints()
            }, completion: {
                finished in
                self.isShowPen = false
                //print(self.filterContainer.frame)
        } )
    }
    
    func colorSelect() {
        let color = pData.getStringForKey(key: "color")
        if color != "" {
            penViewController!.penBaseView.backgroundColor = UIColor(hex: Int(color!)!, alpha: 1.0)
        }else{
            penViewController!.penBaseView.backgroundColor = UIColor.clear
        }
        self.addDrawView()
    }
    
    func showFrameSelectViewController(){
        // ビューコントローラーを取得
        let story = UIStoryboard(name: "Main", bundle: nil)
        let selectVC = story.instantiateViewController(withIdentifier: "FrameSelectViewController") as! FrameSelectViewController
        
        selectVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //self.modalPresentationStyle = .CurrentContext
        self.present(selectVC, animated: true, completion: nil)
    }
    
    func showSelectViewController(_ index:Int){
        // ビューコントローラーを取得
        let story = UIStoryboard(name: "Main", bundle: nil)
        let selectVC = story.instantiateViewController(withIdentifier: "SelectViewController") as! SelectViewController
        selectVC.type = index
        
        selectVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //self.modalPresentationStyle = .CurrentContext
        self.present(selectVC, animated: true, completion: nil)
    }
    
    
    func addFrame(index:Int){
        chgStatus(EditStatus.Frame)
        
        frameView?.removeFromSuperview()
        
        let name = "\(index).png"
        let bundlepath = Bundle.main.path(forResource: "iphone5_Frame", ofType: "bundle")
        var isDir : ObjCBool = false
        if FileManager.default.fileExists(atPath: bundlepath! + "/" + name, isDirectory: &isDir) {
            let url = NSURL(fileURLWithPath: bundlepath!).appendingPathComponent(name)
            let image = UIImage(contentsOfFile: url!.path)
            frameView = FrameView(frame:(self.imageView?.frame)!)
            frameView?.setFrameImage(image: image!)
            self.view.addSubview(frameView!)
        }
    }
    
    // 画面にタッチで呼ばれる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("status : \(status) \(status?.rawValue)")
        if status != EditStatus.Stamp { return }
        
        if let touch = touches.first {
            let p = touch.location(in: self.view)
            
            //print("currentlyEditingView : \(currentlyEditingView)")
            if currentlyEditingView != nil {
                //print("currentlyEditingView?.isEditingHandlesHidden() : \(currentlyEditingView?.isEditingHandlesHidden())")
                //print("currentlyEditingView?.frame : \(currentlyEditingView?.frame)")
                //print("p : \(p)")
                if currentlyEditingView?.isEditingHandlesHidden() == false  && !(currentlyEditingView?.frame)!.contains(p){
                    currentlyEditingView?.hideEditingHandles()
                    currentlyEditingView = nil
                    return
                }
            }
            
            let bundleName = pData.getStringForKey(key: "bundleName")
            let name = pData.getStringForKey(key: "imageName")
            
            if(bundleName == "" && name == "" ){
                return
            }
            
            let bundlepath = Bundle.main.path(forResource: bundleName, ofType: "bundle")
            var isDir : ObjCBool = false
            if FileManager.default.fileExists(atPath: bundlepath! + "/" + name!, isDirectory: &isDir) {
                let url = NSURL(fileURLWithPath: bundlepath!).appendingPathComponent(name!)
                let image = UIImage(contentsOfFile: url!.path)
                
                //print("imgUrl.path! : \(url.path!)")
                if !(self.imageView?.frame)!.contains(p) { return }
                
                let gripFrame1 : CGRect = CGRect(x:p.x , y:p.y , width:150, height:150)
                let contentView : UIView = UIView(frame:gripFrame1)
                contentView.backgroundColor = UIColor.clear
                
                let imageView1 = UIImageView(image: image)
                imageView1.contentMode = .scaleAspectFit
                contentView.addSubview(imageView1)
                
                let views = self.view.subviews.reversed()
                for view in views {
                    //if view.isKindOfClass(ZDStickerView) {
                    if view is ZDStickerView{
                        let z = view as! ZDStickerView
                        z.hideEditingHandles()
                    }
                }
                
                let userResizableView1 : ZDStickerView = ZDStickerView(frame: gripFrame1)
                userResizableView1.tag = 0
                userResizableView1.stickerViewDelegate = self
                userResizableView1.contentView = contentView
                userResizableView1.preventsPositionOutsideSuperview = false
                userResizableView1.translucencySticker = false
                userResizableView1.showEditingHandles()
                userResizableView1.rangeRect = (self.imageView?.frame)!
                userResizableView1.center = p
                self.view.addSubview(userResizableView1)
                
                self.view.bringSubview(toFront: headerView)
                self.view.bringSubview(toFront: homeBtn)
                self.view.bringSubview(toFront: saveBtn)
                
                //self.view.bringSubviewToFront(backgroundUnderImageView)
                self.view.bringSubview(toFront: self.backgroundImageView!)
                self.view.bringSubview(toFront: undoBtn)
                self.view.bringSubview(toFront: eraserBtn)
                self.view.bringSubview(toFront: menuContainer)
                
                currentlyEditingView = userResizableView1
                ZDStickerViews?.append(userResizableView1)
            }
        }
    }
    
    @IBAction func onUndo(_ sender: AnyObject) {
        let views = self.view.subviews.reversed()
        for view in views {
            if view is ZDStickerView {
                let z = view as! ZDStickerView
                if z.isEditingHandlesHidden() == false {
                    self.currentlyEditingView = nil
                }
                z.removeFromSuperview()
                ZDStickerViews?.removeLast()
                //chgStatus(EditStatus.Stamp)
                break
            }
            if view is DrawBase {
                let drawBase = view as! DrawBase
                //drawBase.undoButtonClicked()
                if drawBase.paths.count == 0 { //&& self.imageView?.subviews.count > 1 {
                    drawBase.removeFromSuperview()
                    continue;
                }else{
                    drawBase.undoButtonClicked()
                    break
                }
                //break
            }
            
            if view is FrameView {
                view.removeFromSuperview()
                break
            }
        }
        
        let nviews = self.view.subviews.reversed()
        if nviews.count == 0 { return }
        for view in nviews {
            //print("view : \(view)")
            if view is ZDStickerView {
                chgStatus(EditStatus.Stamp)
                break
            }else if view is DrawBase {
                chgStatus(EditStatus.Pen)
                // 描画可能に
                let drawBase = view as! DrawBase
                drawBase.drawFlg = true
                break
            }else if view is FrameView {
                chgStatus(EditStatus.Frame)
                break
            }else{
                //chgStatus(EditStatus.Not)
            }
            //break
        }
    }
    
    @IBAction func onEraser(_ sender: AnyObject) {
        if status != EditStatus.Pen { return }
        self.pData.setData(value: true as AnyObject, key: "clear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
