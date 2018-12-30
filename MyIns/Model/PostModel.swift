//
//  PostModel.swift
//  MyIns
//
//  Created by LiYong on 2018/12/9.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import Foundation

class PostModel {
    
    var userModel:UserModel!
    
    var postText:String!
    var postImageUrl:String!
    var videoUrl:String!
    var postName:String!
    var postUserImageUrl:String!
    var userId:String!
    var postId:String!
    var videokey:String!
    var imagekey:String!
    var postTime:Double!
    
    
    var likeCount:Int!
    var likeUsers:[String:Bool]?
    var imageRatio:CGFloat!
    
    init(_ dic:[String:Any],_ id:String){
        
        postId = id
        
        if let text = dic["text"] as? String{
            postText = text
        }
        
        if let imageUrl = dic["imageUrl"] as? String{
            postImageUrl = imageUrl
        }
        
        if let uid = dic["uid"] as? String{
            userId = uid
        }
        
        if let count = dic["likeCount"] as? Int{
            likeCount = count
        }
        
        if let vurl = dic["videoUrl"] as? String{
            videoUrl = vurl
        }
        
        if let likes = dic["likes"] as? [String:Bool]{
            likeUsers = likes
        }
        
        if let ratio = dic["imageRatio"] as? CGFloat{
            imageRatio = ratio
        }
        
        if let time = dic["postTime"] as? Double{
            postTime = time
        }
        
        
        
        
        if let vKey = dic["videoKey"] as? String{
            videokey = vKey
        }
        
        if let iKey = dic["imageKey"] as? String{
            imagekey = iKey
        }
    }
    
    func isLike(_ userID:String)->Bool!{
        
        
        if let like = likeUsers?[userID] {
            
            return like
        }
        
        return false
    }
    
}

