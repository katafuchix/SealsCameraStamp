//
//  DrawBase.swift
//  SealsCameraStamp
//
//  Created by cano on 2016/10/16.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class DrawBase: UIView {

    
    let pData = PublicDatas.getPublicDatas()
    
    var touchPoint:CGPoint?
    var currentPath:UIBezierPath?
    var drawColor:UIColor?
    
    var paths:Array<UIBezierPath>   = Array<UIBezierPath>()
    var paths2:Array<UIBezierPath>  = Array<UIBezierPath>()
    var widthArray:Array<CGFloat>   = Array<CGFloat>()
    var colorArray:Array<UIColor>   = Array<UIColor>()
    
    var drawFlg = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //drawColor = pData.getUIColorForKey("color")
        //drawColor?.set()
        
    }
    
    //描画処理
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //drawColor = CommonUtil.getSettingThemaColor()
        /*
         let color = pData.getStringForKey("color")
         if color != "" {
         drawColor = UIColor(hex: Int(color)!, alpha: 1.0)
         }else{
         drawColor = UIColor.whiteColor()
         }
         drawColor?.set()
         */
        for (index, path) in paths.enumerated() {
            let color = colorArray[index]
            color.set()
            
            path.lineWidth = widthArray[index]
            path.miterLimit = 10
            path.lineCapStyle = .round//kCGLineCapRound
            path.lineJoinStyle = .round//kCGLineJoinRound
            
            //UIColor.blackColor().setFill()
            //path.fill()
            path.stroke()
            if color == UIColor.clear {
                path.stroke(with: .clear, alpha: 0)//kCGBlendModeClear, alpha: 0)
            }
        }
    }
    
    //override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if !drawFlg { return }
        
        //print("start")
        currentPath = UIBezierPath()
        currentPath!.lineWidth = 3.0
        
        if let touch = touches.first {
            currentPath?.move(to: touch.location(in: self))
            paths.append(currentPath!)
            paths2.append(currentPath!)
            widthArray.append(CGFloat(pData.getFloatForKey(key: "width")))
            
            let c = pData.getBoolForKey(key: "clear")
            if c == true {
                drawColor = UIColor.clear
            }else{
                let color = pData.getStringForKey(key: "color")
                if color != "" {
                    drawColor = UIColor(hex: Int(color!)!, alpha: 1.0)
                }else{
                    drawColor = UIColor.white
                }
            }
            colorArray.append(drawColor!)
        }
        
    }
    
    //override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("move")
        
        if !drawFlg { return }
        
        if let touch = touches.first {
            currentPath?.addLine(to: touch.location(in: self))
            self.setNeedsDisplay()
        }
    }
    
    func undoButtonClicked() {
        if paths.count > 0 {
            paths.removeLast()
        }
        self.setNeedsDisplay()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
