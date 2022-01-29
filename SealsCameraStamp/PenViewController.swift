//
//  PenViewController.swift
//  SealsCameraStamp
//
//  Created by cano on 2016/10/10.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class PenViewController: UIViewController {

    var delegate : penSelectDelegate?
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var penBaseView: UIView!
    
    @IBOutlet weak var penImageView: UIImageView!
    
    var pData = PublicDatas.getPublicDatas()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var width = pData.getFloatForKey(key: "width")
        if width == 0.0 {
            width = 10.0
            pData.setData(value: 10.0 as AnyObject, key: "width")
        }
        
        slider.setThumbImage(UIImage(named: "slider_thumb_30.png"), for: .normal)
        slider.setMaximumTrackImage(UIImage(named: "skeleton.png"), for: .normal)
        slider.setMinimumTrackImage(UIImage(named: "skeleton.png"), for: .normal)
        
        slider.minimumValue = 1.0
        slider.maximumValue = 50.0
        let w = pData.getFloatForKey(key: "width")
        if  w! > Float(0) {
            slider.value = w!
        }else{
            slider.value = 10.0
            pData.setData(value: 10.0 as AnyObject, key: "width")
        }
        slider.addTarget(self, action: #selector(PenViewController.onChgSlider), for: UIControlEvents.valueChanged)
        
        //penButton.addTarget(self, action: #selector(PenViewController.onPen(_:)), forControlEvents: .TouchUpInside)
        
        let color = pData.getStringForKey(key: "color") as String
        if color != "" {
            //let myInt: Int = Int(color)!
            //penBaseView.backgroundColor = UIColor(hex: myInt, alpha: 1.0)
            //penBaseView.backgroundColor = UIColor.hexStr ( hexStr : color as NSString, alpha : 1.0)
            penBaseView.backgroundColor = UIColor(hex: Int(color)!, alpha: 1.0)
        }else{
            penBaseView.backgroundColor = UIColor.clear
        }
        
        penImageView.isUserInteractionEnabled = true
        let tapped = UITapGestureRecognizer(target: self, action: #selector(PenViewController.onPen))
        penImageView.addGestureRecognizer(tapped)
    }

    func onChgSlider(sender:UISlider){
        pData.setData(value: sender.value as AnyObject, key: "width")
    }
    
    func onPen(sender:AnyObject){
        if (self.delegate?.responds(to: Selector(("penSelect")))) != nil {
            // 実装先のメソッドを実行
            delegate?.penSelect()
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

protocol penSelectDelegate : NSObjectProtocol {
    
    func penSelect()
    
}
