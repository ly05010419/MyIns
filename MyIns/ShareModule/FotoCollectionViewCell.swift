//
//  FotoCollectionViewCell.swift
//  MyIns
//
//  Created by LiYong on 2018/12/7.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit

class FotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    var representedAssetIdentifier: String!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
        
    }
}
