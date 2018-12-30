//
//  ProfiHeaderCollectionReusableView.swift
//  MyIns
//
//  Created by LiYong on 2018/12/14.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit

class ProfiHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profiButton: UIButton!
    
    @IBOutlet weak var profiImageView: UIImageView!
    
    @IBOutlet weak var postsLabel: UILabel!
    
    @IBOutlet weak var follwerLabel: UILabel!
    
    @IBOutlet weak var fansLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var user:UserModel?{
        
        didSet{
            if let imageUrl = self.user!.userImageUrl,let url = URL(string: imageUrl) {
                profiImageView.sd_setImage(with: url, completed: nil)
            }
            
            nameLabel.text = self.user?.userName
            
        }
    }
    
    var uid:String!{
        
        didSet{
            
            UserService.share.loadSingleUser(uid:uid!) { (userModel) in
                
                self.user = userModel
                
                
                if self.uid != AuthenticationService.share.getUserId(){
                    FollowService.share.isfollowing(with: self.uid, success: { (isFollowing) in
                        
                        self.user?.isFollowing = isFollowing
                        self.updateFollowButton()
                        
                    })
                }else{
                    
                    self.profiButton.setTitle("Edit Profi", for: UIControl.State.normal)
                }
                
            }
            
            PostService.share.getUserPostCount(uid!) { (count) in
                
                let text = NSMutableAttributedString(string: "\(count) \n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
                
                text.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray]))
                
                self.postsLabel.attributedText = text
                
            }
            
            FollowService.share.getfollowsCount(uid!) { (count) in
                
                let text = NSMutableAttributedString(string: "\(count) \n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
                
                text.append(NSAttributedString(string: "follwers", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray]))
                
                self.follwerLabel.attributedText = text
                
            }
            
            
            FollowService.share.getfollowingCount(uid!) { (count) in
                
                let text = NSMutableAttributedString(string: "\(count) \n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
                
                text.append(NSAttributedString(string: "follwering", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray]))
                
                self.fansLabel.attributedText = text
                
            }
            
        }
    }
    
    
    
    
    override func awakeFromNib() {
        
        profiImageView.clipsToBounds = true
        profiImageView.layer.cornerRadius = profiImageView.frame.width/2
        profiImageView.layer.borderWidth = 1
        profiImageView.layer.borderColor = UIColor.gray.cgColor
        
        
        profiButton.layer.cornerRadius = 5
        profiButton.layer.borderWidth = 1
        profiButton.layer.borderColor = UIColor.gray.cgColor
        
    }
    
    
    
    
    
    @IBAction func profiButtonAction(_ sender: Any) {
        
        
        
    }
    
    
    
    
    @objc func folgenAction(_ sender: UIButton) {
        
        
        FollowService.share.follow(with: uid)
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
    
    
    func updateFollowButton(){
        
        if self.user!.isFollowing {
            self.profiButton.setTitle("Following", for: UIControl.State.normal)
            self.profiButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            self.profiButton.backgroundColor = UIColor.white
            self.profiButton.addTarget(self, action: #selector(unfolgenAction(_:)), for: UIControl.Event.touchUpInside)
            
        }else{
            
            self.profiButton.setTitle("Follow", for: UIControl.State.normal)
            self.profiButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            self.profiButton.backgroundColor = UIColor(red: 1/255, green: 84/255, blue: 147/255, alpha: 1)
            self.profiButton.addTarget(self, action: #selector(folgenAction(_:)), for: UIControl.Event.touchUpInside)
        }
    }
    
}

