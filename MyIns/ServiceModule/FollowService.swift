//
//  File.swift
//  MyIns
//
//  Created by LiYong on 2018/12/14.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FollowService{
    let followsDatabase = FIRDatabase.database().reference().child("follows")
    let followingDatabase = FIRDatabase.database().reference().child("following")
    
    static let share = FollowService()
    
    private init(){}
    
    func follow(with userID:String){
        
        guard let myID = AuthenticationService.share.getUserId() else {
            return
        }
        
        followsDatabase.child(myID).child(userID).setValue(true)
        followingDatabase.child(userID).child(myID).setValue(true)
        
        FeedService.share.addAllUserPostToMyNewFeed(userID)
        
    }
    
    func unfollow(with userID:String){
        
        guard let myID = AuthenticationService.share.getUserId() else {
            return
        }
        
        followsDatabase.child(myID).child(userID).removeValue()
        followingDatabase.child(userID).child(myID).removeValue()
        
        FeedService.share.removeAlleUserPostFromMyNewFeed(userID)
    }
    
    
    func isfollowing(with userID:String,success:@escaping (Bool)->()){
        
        
        guard let myID = AuthenticationService.share.getUserId() else {
            return
        }
       

        followingDatabase.child(userID).child(myID).observeSingleEvent(of: FIRDataEventType.value) { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                
                success(false)
                
            }else{
                success(true)
            }
        }
        
        
    }
    
    
    
    
    func getfollowsCount(_ userID:String, success:@escaping (Int)->()){
        
        followsDatabase.child(userID).observe(FIRDataEventType.value) { (FIRDataSnapshot) in
            
            let count = FIRDataSnapshot.childrenCount
            success(Int(count))
            
        }
    }
    
    
    func getfollowingCount(_ userID:String, success:@escaping (Int)->()){
        
        guard let userID = AuthenticationService.share.getUserId() else {
            return
        }
        
        followingDatabase.child(userID).observe(FIRDataEventType.value) { (FIRDataSnapshot) in
            
            let count = FIRDataSnapshot.childrenCount
            success(Int(count))
            
        }
    }
    
    func getfollowsUserID(_ userID:String, success:@escaping ([String])->()){
        
        followsDatabase.child(userID).observeSingleEvent(of: .value) { (FIRDataSnapshot) in
            let objects = FIRDataSnapshot.children.allObjects as! [FIRDataSnapshot]
            
            var ids = [String]()
            
            objects.forEach({ (snapshot) in
                ids.append(snapshot.key)
            })
            
            success(ids)
        }
        
        
    }
    
  
   
    
}

