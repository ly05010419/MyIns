//
//  ActivityTableViewCell.swift
//  MyIns
//
//  Created by LiYong on 2018/12/25.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var profiImageView: UIImageView!
    
    var msg:MessageModel!{
        
        didSet{
            
            self.nameLabel.text = msg.user.userName
            
            if let pUrl = msg?.user.userImageUrl {
                let profiUrl = URL(string: pUrl)
                self.profiImageView.sd_setImage(with: profiUrl, completed: nil)
            }
            
           
            let url = URL(string: msg.post.postImageUrl)
            self.postImageView.sd_setImage(with: url, completed: nil)
            
            if msg!.type == "newPost"{
                
                self.postLabel.text = "Neuer Post erstellt!"
            }else if msg!.type == "comment"{
                
                self.postLabel.text = msg.commentText
            }else if msg!.type == "like"{
                
                self.postLabel.text = "Neuer like!"
            }
            
          

            let date = Date(timeIntervalSince1970: msg.time)
            timeLabel.text = date.timeAgoToDisplay()
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.postImageView.clipsToBounds = true
//        self.postImageView.layer.borderWidth = 1
//        self.postImageView.layer.borderColor = UIColor.black.cgColor

        self.profiImageView.layer.borderWidth = 1
        self.profiImageView.layer.borderColor = UIColor.gray.cgColor
        self.profiImageView.layer.cornerRadius = self.profiImageView.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
