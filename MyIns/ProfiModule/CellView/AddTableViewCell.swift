//
//  AddTableViewCell.swift
//  MyIns
//
//  Created by LiYong on 2018/12/14.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit

class AddTableViewCell: UITableViewCell {

    @IBOutlet weak var folgenButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profiImageView: UIImageView!
    
    var user:UserModel?{
        
        didSet{
            
            if let imageUrl = self.user!.userImageUrl,let url = URL(string: imageUrl) {
                profiImageView.sd_setImage(with: url, completed: nil)
            }
            
            nameLabel.text = self.user?.userName
            
            
            updateFollowButton()
            
        }
    }
    
    func updateFollowButton(){
        
        if self.user!.isFollowing {
            self.folgenButton.setTitle("Following", for: UIControl.State.normal)
            self.folgenButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            self.folgenButton.backgroundColor = UIColor.white
            self.folgenButton.addTarget(self, action: #selector(unfolgenAction(_:)), for: UIControl.Event.touchUpInside)
            
        }else{
            
            self.folgenButton.setTitle("Follow", for: UIControl.State.normal)
            self.folgenButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            self.folgenButton.backgroundColor = UIColor(red: 1/255, green: 84/255, blue: 147/255, alpha: 1)
            self.folgenButton.addTarget(self, action: #selector(folgenAction(_:)), for: UIControl.Event.touchUpInside)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profiImageView.clipsToBounds = true
        profiImageView.layer.cornerRadius = profiImageView.frame.width/2
        
        folgenButton.layer.cornerRadius = 5
        folgenButton.layer.borderWidth = 1
        folgenButton.layer.borderColor = UIColor.gray.cgColor
        
        
    }

    @objc func folgenAction(_ sender: UIButton) {
        
        
        guard let userID = self.user?.uid else {
            return
         }
        
        FollowService.share.follow(with: userID)
        self.user?.isFollowing = true
        
        
        updateFollowButton()
    }
    
    @objc func unfolgenAction(_ sender: UIButton) {
        
        
        guard let userID = self.user?.uid else {
            return
        }
        
        FollowService.share.unfollow(with: userID)
        
        
        self.user?.isFollowing = false
        updateFollowButton()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
