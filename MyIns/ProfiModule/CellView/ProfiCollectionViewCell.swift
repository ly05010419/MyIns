//
//  ProfiCollectionViewCell.swift
//  MyIns
//
//  Created by LiYong on 2018/12/14.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit

class ProfiCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var fotoImageView: UIImageView!
    
    var post:PostModel?{
        didSet{
            
            if let imageUrl = self.post?.postImageUrl,let url = URL(string: imageUrl) {
                fotoImageView.sd_setImage(with: url, completed: nil)
            }
            
        }
    }
    
    override func awakeFromNib() {
        
    }
    
    
}

