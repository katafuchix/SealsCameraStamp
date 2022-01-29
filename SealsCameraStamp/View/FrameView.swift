//
//  FrameView.swift
//  SealsCameraStamp
//
//  Created by cano on 2016/10/12.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class FrameView: UIView {
    var image : UIImage?
    
    func setFrameImage(image:UIImage){
        self.backgroundColor = UIColor.clear
        let imageView = UIImageView(frame:self.bounds)
        imageView.image = image
        self.addSubview(imageView)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
