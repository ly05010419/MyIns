//
//  HomeTableViewCell.swift
//  MyIns
//
//  Created by LiYong on 2018/12/9.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit
import Photos
import ProgressHUD
import KILabel

class HomeTableViewCell: UITableViewCell {

  
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profiImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var postTextLabel: KILabel!
    
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var audioButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var homeVC:HomeViewController!
    var player:AVPlayer!
    var playerLayer:AVPlayerLayer!
    
    
    var userModel:UserModel?{
        didSet{
            setupUser()
        }
        
    }
  
    
    public var postModel:PostModel! {
        
        didSet{
            
            setupPost()
            
            self.userModel = self.postModel?.userModel
        }
    }
    
    func setupPost(){
        
        activityIndicator.startAnimating()
        
        guard let post = self.postModel else { return }
        
        updateLike(post)
        
        guard let postImageUrl = post.postImageUrl else {
            return
        }
        
        guard let imageURL = URL(string:postImageUrl) else {
            return
        }
        
        
        
        self.postTextLabel.text = post.postText
        
        postTextLabel.hashtagLinkTapHandler = {(lebel,word,range) in
            
            let hashtag = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)

            self.homeVC.gotoHashTagVC(hashtag)
        }
        
        self.postImageView?.sd_setImage(with: imageURL, completed: { (image, error, type, url) in
            self.activityIndicator.stopAnimating()
        })
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        let imageRatio = self.postModel.imageRatio
            
        self.imageHeightConstraint?.constant = screenWidth / imageRatio!
        self.layoutIfNeeded()
        
        if let time = post.postTime {
            let date = Date(timeIntervalSince1970: time)
            
            timeLabel.text = date.timeAgoToDisplay()
        }
        
        
        guard let videoUrl = post.videoUrl else {
            return
        }
        
        guard let url = URL(string:videoUrl) else {
            return
        }
        
        player = AVPlayer(url: url)
        
        if playerLayer == nil {
            playerLayer = AVPlayerLayer(player: player)
        }else{
            playerLayer.player = player
        }
        
        playerLayer.videoGravity = .resizeAspectFill
        
        
        playerLayer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth / imageRatio!)
        
        self.postImageView.layer.addSublayer(playerLayer)
        
        player.play()
        
        addNotification()
        
        player.isMuted = true
        updateAudioButton()
        
        self.audioButton.isHidden = false
    }
    
    
    func addNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(playbackFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopVideo), name: NSNotification.Name.init(rawValue: "stopVideo"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(playVideo), name: NSNotification.Name.init(rawValue: "playVideo"), object: nil)
        
    }
    @objc func stopVideo(){
        
        self.player?.pause()
    }
    
    @objc func playVideo(){
        
        self.player?.play()
    }
    @objc func playbackFinished(){
        self.player?.seek(to: CMTime(value: 0, timescale: 1))
        self.player?.play()
    }
    
    
    func setupUser(){
        self.nameLabel.text = self.userModel?.userName
        
        guard let userImageUrl = self.userModel?.userImageUrl else {
            return
        }
        guard let imageURL = URL(string:userImageUrl) else {
            return
        }
        self.profiImageView.sd_setImage(with: imageURL, completed: nil)
    }
    
    
    
    
    
    func updateLike(_ post:PostModel!){
        
        guard let userID = AuthenticationService.share.getUserId() else { return }
        
        if post.isLike(userID) {
            
            self.likeButton.isSelected = true
        }else{
            
            self.likeButton.isSelected = false
        }
        
        if let likeCount = post.likeCount {
            self.likeCountLabel.text = "\(likeCount) like"
            
        } else {
            self.likeCountLabel.text = "0 like"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profiImageView.layer.cornerRadius = self.profiImageView.frame.width/2
        self.profiImageView.layer.borderWidth = 1
        self.profiImageView.layer.borderColor = UIColor.gray.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(audioTap(_:)))
        self.postImageView.addGestureRecognizer(tap)
        
        self.audioButton.isHidden = true
    }
    
    

    @IBAction func likeAction(_ sender: UIButton) {
        
        guard let post = self.postModel else { return }
        
        PostService.share.addOderRemoveLike(post.postId, success: {(postModel) in
            
            self.postModel?.likeCount = postModel.likeCount
            self.postModel?.likeUsers = postModel.likeUsers
            
            self.updateLike(self.postModel)
            
            if self.likeButton.isSelected {
                
                MessageService.share.addMessage(post.userId, post.postId, nil, "like")
                
            }
            
        }) { (error) in
            ProgressHUD.showError(error)
        }
        
    }
    
    
    override func prepareForReuse() {
        self.postImageView.image = nil
        self.player?.pause()
        self.playerLayer?.removeFromSuperlayer()
        
        NotificationCenter.default.removeObserver(self)
        self.audioButton.isHidden = true
    }
    
    
    @IBAction func editAction(_ sender: UIButton) {
        
        let alertVC = UIAlertController()
        
        if let userID = AuthenticationService.share.getUserId(), userID == self.postModel?.userId{
            alertVC.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                
                PostService.share.deletePost(self.postModel, success: {
                    ProgressHUD.showSuccess("Delete sucessfull!")
                }) { (msg) in
                    ProgressHUD.showError(msg)
                }
                
            }))
            
        }
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
            alertVC.dismiss(animated: true, completion: nil)
        }))
        
        
       self.homeVC.showAlert(alertVC)
        
    }
    
    @objc func audioTap(_ sender: Any) {
        if player != nil {
            player.isMuted = !player.isMuted
            updateAudioButton()
        }
        
    }
    
    func updateAudioButton(){
        if player != nil {
            self.audioButton.isSelected = player.isMuted
        }
        
    }
    
}
