//
//  FrameSelectViewController.swift
//  SealsCameraStamp
//
//  Created by cano on 2016/10/12.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class FrameSelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var delegate : filterSelectDelegate?
    let reuseIdentifier = "Cell"
    
    var collectionView : UICollectionView?
    let pDdata = PublicDatas.getPublicDatas()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
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
        let itemCell = UINib(nibName: "FrameCell", bundle: nil)//.instantiateWithOwner(self, options: nil)[0]
        collectionView!.register(itemCell , forCellWithReuseIdentifier: reuseIdentifier)
        //collectionView!.registerClass(ItemCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
        // 画面に表示
        collectionView?.backgroundColor = UIColor.clear //UIColor(hex:9025020, alpha: 1.0)
        collectionView?.alpha = 1.0
        self.view.addSubview(collectionView!)
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
        return 13 //items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FrameCell
        
        // Configure the cell
        
        cell.backgroundColor = UIColor.clear
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0
        
        let num = indexPath.row
        let name = "\(num).png.png"
        let bundlepath = Bundle.main.path(forResource: "iphone5_Frame_SAM213", ofType: "bundle")
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
        
        let cell = self.collectionView?.cellForItem(at: indexPath as IndexPath) as! FrameCell
        
        let nc = self.presentingViewController as! UINavigationController
        let bc = nc.viewControllers[1] as! BaseViewController
        bc.addFrame(index: indexPath.row)
        
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
