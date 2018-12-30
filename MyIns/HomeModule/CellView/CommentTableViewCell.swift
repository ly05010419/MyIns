//
//  CommentTableViewCell.swift
//  MyIns
//
//  Created by LiYong on 2018/12/9.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit
import KILabel

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: KILabel!
    @IBOutlet weak var profiImageView: UIImageView!
    var commentVC:CommentTableViewController!
    
    var comment:CommentModel? {
        didSet{
            guard let text = self.comment?.commentText else {
                return
            }
            
            guard let userName = self.comment?.user?.userName else {
                return
            }
            
             let attributText = NSMutableAttributedString(string:userName, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            
            attributText.append(NSAttributedString(string: " \(text)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
            
            self.commentLabel.attributedText = attributText
            
            self.commentLabel.hashtagLinkTapHandler = {(lebel,word,range) in
                
                let hashtag = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                
                self.commentVC.gotoHashTagVC(hashtag)
            }
            
            guard let url = self.comment?.user?.userImageUrl else {
                return
            }
            profiImageView.sd_setImage(with: URL(string: url), completed: nil)
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profiImageView.clipsToBounds = true
        self.profiImageView.layer.cornerRadius = self.profiImageView.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
