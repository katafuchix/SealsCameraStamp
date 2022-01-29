//
//  StampBase.swift
//  SealsCameraStamp
//
//  Created by cano on 2016/10/12.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class StampBase: UIView, ZDStickerViewDelegate {

    func addStamp(image:UIImage){
        /*
         if currentlyEditingView != nil {
         currentlyEditingView?.hideEditingHandles()
         }
         */
        let gripFrame1 : CGRect = CGRect(x: 30 , y: 30 , width:150, height:150)
        let contentView : UIView = UIView(frame:gripFrame1)
        contentView.backgroundColor = UIColor.clear
        
        let imageView1 = UIImageView(image: image)
        contentView.addSubview(imageView1)
        
        let userResizableView1 : ZDStickerView = ZDStickerView(frame: gripFrame1)
        
        userResizableView1.tag = 0
        userResizableView1.stickerViewDelegate = self
        userResizableView1.contentView = contentView
        userResizableView1.preventsPositionOutsideSuperview = false
        userResizableView1.translucencySticker = false
        userResizableView1.showEditingHandles()
        self.addSubview(userResizableView1)
        /*
         currentlyEditingView = userResizableView1
         ZDStickerViews?.append(userResizableView1)
         
         let stampBase = StampBase(frame:self.imageView.frame)
         stampBase.backgroundColor = UIColor.lightGrayColor()
         self.imageView.addSubview(stampBase)
         
         userResizableView1.stickerViewDelegate = stampBase
         stampBase.addSubview(userResizableView1)
         */
    }
    
    func stickerViewDidLongPressed(_ sticker:ZDStickerView){
        
        if sticker.isEditingHandlesHidden() == true {
            sticker.showEditingHandles()
        }else{
            sticker.hideEditingHandles()
        }
    }
    
    func stickerViewDidCustomButtonTaplose(_ sticker: ZDStickerView!) {
        print(sticker.tag)
    }
    
    func stickerViewDidCustomButtonTap(sticker: ZDStickerView!) {
        print(sticker.tag)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
