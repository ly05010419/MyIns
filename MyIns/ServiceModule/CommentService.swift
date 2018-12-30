//
//  CommentService.swift
//  MyIns
//
//  Created by LiYong on 2018/12/13.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class CommentService{
    
    let commentDatabase = FIRDatabase.database().reference().child("comments")
    
    static let share = CommentService()
    
    private init(){}
    
    func createComment(_ text:String,_ postId:String,_ userID:String,success:@escaping ()->(),falure:@escaping (String?)->()){
        
        let commentid = commentDatabase.childByAutoId().key
        let comment = commentDatabase.child(commentid)
        
        comment.setValue(["commentText" : text,"postId":postId,"uid" : AuthenticationService.share.getUserId()]) { (error, FIRDatabaseReference) in
            
            if error != nil{
                
                falure(error?.localizedDescription)
                
                return
            }
            
            
            MessageService.share.addMessage(userID, postId,text, "comment")
            
            
            CommentService.share.createPostComment(commentid, postId, success: {
                success()
            }, falure: { (error) in
                falure(error)
            })
        }
    }
    
    
    func createPostComment(_ commentId:String,_ postId:String,success:@escaping ()->(),falure:@escaping (String?)->()){
        let database = FIRDatabase.database().reference().child("post-comments").child(postId).child(commentId)
        database.setValue(true) { (error, FIRDatabaseReference) in
            if error != nil {
                falure(error?.localizedDescription)
                return
            }
            
            success()
        }
    }
    
    func loadComment(postId:String,success:@escaping (CommentModel)->()){
        
        let ref = FIRDatabase.database().reference().child("post-comments").child(postId)
        ref.observe(.childAdded) { (FIRDataSnapshot) in
            
            let commentId = FIRDataSnapshot.key
            
            CommentService.share.loadCommentModel(commentId: commentId, success: { (comment) in
                
                success(comment)
            })
        }
    }
    
    func loadCommentModel(commentId:String,success:@escaping (CommentModel)->()){
        
        let ref = commentDatabase.child(commentId)
        ref.observeSingleEvent(of: .value) { (FIRDataSnapshot) in
            
            guard let dic = FIRDataSnapshot.value as? [String:String] else{return}
            
            let comment = CommentModel(dic)
            
            UserService.share.loadSingleUser(uid: comment.uid!, success: { (user) in
                
                comment.user = user
                success(comment)
            })
        }
    }
    
    
    
}
