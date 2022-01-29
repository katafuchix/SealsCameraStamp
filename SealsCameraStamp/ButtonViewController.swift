//
//  ButtonViewController.swift
//  SealsCameraStamp
//
//  Created by cano on 2016/10/10.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class ButtonViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let reuseIdentifier = "Cell"
    
    var collectionView : UICollectionView?
    let pDdata = PublicDatas.getPublicDatas()
    
    var delegate : buttonSelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        /*
         UIGraphicsBeginImageContext(self.view.frame.size)
         UIImage(named: "menu_back.png")?.drawInRect(CGRectMake(0, 0, 50, 50))
         
         let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
         
         UIGraphicsEndImageContext()
         */
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "footer_bg.png")!)
        
        // レイアウトを指定
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSize(width:70.0, height:70.0)
        // 縦、横のスペース
        flowLayout.minimumInteritemSpacing = 5.0
        flowLayout.minimumLineSpacing = 5.0
        // スクロールの方向
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        // サイズ、レイアウトを指定して初期化
        //collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        let rect = CGRect(x:0, y:0, width:self.view.frame.width, height:75)
        collectionView = UICollectionView(frame: rect, collectionViewLayout: flowLayout)
        // delegateを指定
        collectionView!.delegate = self
        // dataSourceを指定
        collectionView!.dataSource = self
        // セルのクラスを登録
        let itemCell = UINib(nibName: "ItemCell", bundle: nil)//.instantiateWithOwner(self, options: nil)[0]
        collectionView!.register(itemCell , forCellWithReuseIdentifier: reuseIdentifier)
        //collectionView!.registerClass(ItemCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
        //collectionView!.backgroundView?.backgroundColor = UIColor(patternImage: image)
        collectionView!.backgroundColor = UIColor.clear
        // 画面に表示
        //collectionView?.backgroundColor = UIColor(hex:9025020, alpha: 1.0)
        self.view.addSubview(collectionView!)

    }

    // MARK: UICollectionViewDataSource
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 6 //items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ItemCell
        
        // Configure the cell
        var n = indexPath.row
        if n == 5 { n = 7 }
        
        cell.backgroundColor = UIColor.clear
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0
        cell.tag = indexPath.row
        
        let num = pDdata.getIntegerForKey(key: "button")
        var on = "OFF"
        if num == indexPath.row {
            on = "ON"
        }
        let name = "\(n)_\(on).png"
        cell.imageView.image = UIImage(named: name)
        //print(cell)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath){
        /*
         // 選択されたセルの番号を表示
         let alert:UIAlertController = UIAlertController(title: "\(indexPath.row)", message: "", preferredStyle: UIAlertControllerStyle.Alert)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
         // OKボタンが押された時の処理
         (action:UIAlertAction) -> Void in
         alert.dismissViewControllerAnimated(true, completion: nil)
         }))
         
         self.presentViewController(alert, animated: true, completion: nil)
         */
        
        let name = "\(indexPath.row)_OFF.png"
        print("name : \(name)")
        pDdata.setData(value: indexPath.row as AnyObject, key: "button")
        collectionView.reloadData()
        
        if (self.delegate?.responds(to: Selector("buttonSelect:"))) != nil {
            // 実装先のメソッドを実行
            delegate?.buttonSelect(index: indexPath.row)
        }
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

protocol buttonSelectDelegate : NSObjectProtocol {
    
    func buttonSelect(index:Int)
    
}
