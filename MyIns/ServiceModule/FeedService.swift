//
//  FeedService.swift
//  MyIns
//
//  Created by LiYong on 2018/12/14.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class FeedService{
    let followsDatabase = FIRDatabase.database().reference().child("newFeeds")
    
    static let share = FeedService()
    
    private init(){}
    
    
   
    
    //首页加载Feed
    func loadMyNewFeed(success:@escaping (PostModel)->()){
        
        guard let myID = AuthenticationService.share.getUserId() else {
            return
        }
        
        
        followsDatabase.child(myID).observeSingleEvent(of: .value) { (FIRDataSnapshot) in
            
            let objects = FIRDataSnapshot.children.allObjects as! [FIRDataSnapshot]
            
            objects.forEach({ (snapshot) in
                let postID = snapshot.key
                PostService.share.loadSinglePost(postID, success: { (postModel) in
                    
                    success(postModel)
                })
            })
            
            
        }
        
    }
    
    
//    添加一个post到所有的关注者的NewFeed里面
    func addFeedToMyFollow(_ userID:String,_ postID:String,_ imageUrl:String,success:@escaping ()->()){
        
        FollowService.share.getfollowsUserID(userID) { (ids) in
            
            ids.forEach({ (id) in
                
                FeedService.share.addPostToUserNewFeed(id, postID)
                
                MessageService.share.addMessage(id, postID,nil,"newPost")
            })
            
        }
    }
    
//    添加一个post到用户的newFeed里面
    func addPostToUserNewFeed(_ userID:String,_ postID:String){
        
        followsDatabase.child(userID).child(postID).setValue(true)
    }
    
    //发Post之后 添加到我的NewFeed里
    func addPostToMyNewFeed(_ postID:String){
        guard let myID = AuthenticationService.share.getUserId() else {
            return
        }
       self.addPostToUserNewFeed(myID, postID)
    }
    
    //关注之后，把他所有的Post放到我的newFeed里面
    func addAllUserPostToMyNewFeed(_ userID:String){
        
        guard let myID = AuthenticationService.share.getUserId() else {
            return
        }
        
        PostService.share.loadUserPost(userID) { (postModel) in
            self.followsDatabase.child(myID).child(postModel.postId).setValue(true)
        }
    }
    //取消关注之后，把他所有的Post从我的newFeed里面移除
    func removeAlleUserPostFromMyNewFeed(_ userID:String){
        
        guard let myID = AuthenticationService.share.getUserId() else {
            return
        }
        
        PostService.share.loadUserPost(userID) { (postModel) in
            self.followsDatabase.child(myID).child(postModel.postId).removeValue()
        }
    }
    
    

    
    
    func removeFeed(_ userID:String,_ postID:String,success:@escaping ()->(),falure:@escaping (String)->()){
        
        followsDatabase.child(userID).child(postID).removeValue { (Error, FIRDatabaseReference) in
            if let error = Error {
                falure(error.localizedDescription)
                return
            }
            success()
        }
    }


}


