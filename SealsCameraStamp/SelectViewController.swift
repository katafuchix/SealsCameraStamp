//
//  SelectViewController.swift
//  SealsCameraStamp
//
//  Created by cano on 2016/10/12.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var delegate : filterSelectDelegate?
    let reuseIdentifier = "Cell"
    
    var collectionView : UICollectionView?
    let pData = PublicDatas.getPublicDatas()
    
    var type : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //self.view.backgroundColor = UIColor.lightGrayColor()
        //self.view.alpha = 0.3
        self.view.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.7)
        
        // レイアウトを指定
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSize(width:100.0, height:100.0)
        // 縦、横のスペース
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        // スクロールの方向
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        // サイズ、レイアウトを指定して初期化
        //collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        let rect = CGRect(x:0, y:40.0, width:self.view.frame.width, height:self.view.frame.height-40.0)
        collectionView = UICollectionView(frame: rect, collectionViewLayout: flowLayout)
        // delegateを指定
        collectionView!.delegate = self
        // dataSourceを指定
        collectionView!.dataSource = self
        // セルのクラスを登録
        let itemCell = UINib(nibName: "StampCell", bundle: nil)//.instantiateWithOwner(self, options: nil)[0]
        collectionView!.register(itemCell , forCellWithReuseIdentifier: reuseIdentifier)
        //collectionView!.registerClass(ItemCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
        // 画面に表示
        collectionView?.backgroundColor = UIColor.clear //UIColor(hex:9025020, alpha: 1.0)
        collectionView?.alpha = 1.0
        self.view.addSubview(collectionView!)
        print("type : \(type)")
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    @IBAction func onClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        //return 57 //items.count
        var count = 0
        switch type {
        case 1:
            let bundlepath = Bundle.main.path(forResource: "iphone5_STAMP_chara_SAM213", ofType: "bundle")
            let manager = FileManager.default
            let list = try! manager.contentsOfDirectory(atPath: bundlepath!)
            count = list.count
        case 2:
            let bundlepath_m = Bundle.main.path(forResource: "iphone5_STAMP_moji_SAM213", ofType: "bundle")
            let bundlepath_a = Bundle.main.path(forResource: "iphone5_STAMP_azarashimoji_SAM213", ofType: "bundle")
            let manager = FileManager.default
            let list_m = try! manager.contentsOfDirectory(atPath: bundlepath_m!)
            let list_a = try! manager.contentsOfDirectory(atPath: bundlepath_a!)
            count = list_a.count + list_m.count
        case 3:
            let bundlepath = Bundle.main.path(forResource: "iphone5_STAMP_mark_SAM213", ofType: "bundle")
            let manager = FileManager.default
            let list = try! manager.contentsOfDirectory(atPath: bundlepath!)
            count = list.count
        default:
            count = 0
        }
        //print("count:\(count)")
        return count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StampCell
        
        // Configure the cell
        
        var bundleName = ""
        switch type {
        case 1:
            bundleName = "iphone5_STAMP_chara_SAM213"
        case 2:
            if indexPath.row < 40 {
                bundleName = "iphone5_STAMP_azarashimoji_SAM213"
            }else{
                bundleName = "iphone5_STAMP_moji_SAM213"
            }
        case 3:
            bundleName = "iphone5_STAMP_mark_SAM213"
        default:
            bundleName = "iphone5_STAMP_chara_SAM213"
        }
        
        cell.backgroundColor = UIColor.clear
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0
        
        
        
        var num = indexPath.row + 1
        if type == 2 && indexPath.row >= 40 {
            num = indexPath.row - 40 + 1
        }
        //let name = "images/iphone5/STAMP_chara_SAM213/\(num),png"
        let name = "\(num).png"
        let bundlepath = Bundle.main.path(forResource: bundleName, ofType: "bundle")
        var isDir : ObjCBool = false
        if FileManager.default.fileExists(atPath: bundlepath! + "/" + name, isDirectory: &isDir) {
            let url = NSURL(fileURLWithPath: bundlepath!).appendingPathComponent(name)
            let image = UIImage(contentsOfFile: url!.path)
            cell.imageView.image = image
        }
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath){
        
        let cell = self.collectionView?.cellForItem(at: indexPath as IndexPath) as! StampCell
        
        var bundleName = ""
        switch type {
        case 1:
            bundleName = "iphone5_STAMP_chara_SAM213"
        case 2:
            if indexPath.row < 40 {
                bundleName = "iphone5_STAMP_azarashimoji_SAM213"
            }else{
                bundleName = "iphone5_STAMP_moji_SAM213"
            }
        case 3:
            bundleName = "iphone5_STAMP_mark_SAM213"
        default:
            bundleName = "iphone5_STAMP_chara_SAM213"
        }
        
        
        var num = indexPath.row + 1
        if type == 2 && indexPath.row >= 40 {
            num = indexPath.row - 40 + 1
        }
        //let name = "images/iphone5/STAMP_chara_SAM213/\(num),png"
        let name = "\(num).png"
        let bundlepath = Bundle.main.path(forResource: bundleName, ofType: "bundle")
        var isDir : ObjCBool = false
        if FileManager.default.fileExists(atPath: bundlepath! + "/" + name, isDirectory: &isDir) {
            let url = NSURL(fileURLWithPath: bundlepath!).appendingPathComponent(name)
            //let image = UIImage(contentsOfFile: url.path!)
            //pData.setData(image!, key: "stamp")
            pData.setData(value: url!.absoluteString as AnyObject, key: "stampUrl")
            
            //let b = bundleName.stringByReplacingOccurrencesOfString("_SAM213", withString: "")
            let b = bundleName.replacingOccurrences(of: "_SAM213", with: "")
            
            pData.setData(value:b as AnyObject, key: "bundleName")
            pData.setData(value: name as AnyObject, key: "imageName")
            
            let nc = self.presentingViewController as! UINavigationController
            let bc = nc.viewControllers[1] as! BaseViewController
            //ステータス変更
            //bc.chgStatus(EditStatus.Stamp)
        }
        
        self.dismiss(animated: true, completion: nil)
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
