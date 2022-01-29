//
//  ColorPickerViewController.swift
//  SealsCameraStamp
//
//  Created by cano on 2016/10/16.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit
import Color_Picker_for_iOS

class ColorPickerViewController: UIViewController {
    
    let colorPickerView = HRColorPickerView()
    var pData = PublicDatas.getPublicDatas()
    
    var delegate : colorPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.7)
        
        let color = pData.getStringForKey(key: "color")
        if color != "" {
            colorPickerView.color = UIColor(hex: Int(color!)!, alpha: 1.0)
        }else{
            colorPickerView.color = UIColor.white
        }
        //colorPickerView.color = UIColor.red
        
        let rect = CGRect(x:40, y:40, width:self.view.frame.width - 80, height:self.view.frame.height - 60)
        colorPickerView.frame = rect
        colorPickerView.backgroundColor = UIColor.clear
        self.view.addSubview(colorPickerView)
        
        colorPickerView.addTarget(self, action: #selector(ColorPickerViewController.onChange(_:)), for: .valueChanged)
    }

    func onChange(_ sender: AnyObject) {
        if sender is HRColorPickerView{
            let picker = sender as! HRColorPickerView
            //print(String(UIColor.toInt32(color: picker.color)))
            self.pData.setData(value: String(UIColor.toInt32(color: picker.color)) as AnyObject, key: "color")
            
            if (self.delegate?.responds(to: Selector(("colorSelect")))) != nil {
                // 実装先のメソッドを実行
                self.delegate?.colorSelect()
            }
        }
    }
    
    @IBAction func onClose(_ sender: AnyObject) {
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
protocol colorPickerDelegate : NSObjectProtocol {
    
    func colorSelect()
    
}
