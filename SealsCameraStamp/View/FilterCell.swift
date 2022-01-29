//
//  FilterCell.swift
//  SealsCameraStamp
//
//  Created by cano on 2016/10/10.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    @IBOutlet weak var baseImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func draw(_ rect: CGRect) {
        
        self.backgroundColor = UIColor.gray
        
    }
}
