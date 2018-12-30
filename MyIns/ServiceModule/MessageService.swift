//
//  MessageService.swift
//  MyIns
//
//  Created by LiYong on 2018/12/25.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class MessageService{
    
    let messageDatabase = FIRDatabase.database().reference().child("Messages")
    
    static let share = MessageService()
    
    private init(){}
    
    
    
    
    
//   添加一个消息
    func addMessage(_ userID:String,_ postID:String,_ commentText:String?,_ type:String){
        
        let time = Date().timeIntervalSince1970
        
        let key = messageDatabase.child(userID).childByAutoId().key
        
        var msg = ["id":key,"fromID":AuthenticationService.share.getUserId(),"postID":postID,"type":type,"time":time] as [String : Any]
        
        
        if commentText != nil {
            
            msg["commentText"] = commentText
        }
        
        messageDatabase.child(userID).child(key).setValue(msg)

    }
    
    func loadMessages(sucess:@escaping (MessageModel)->()){
        
        let userID = AuthenticationService.share.getUserId()
        messageDatabase.child(userID!).observe(FIRDataEventType.childAdded) { (FIRDataSnapshot) in
            let dic = FIRDataSnapshot.value as! [String:Any]
            let msg = MessageModel(dic)
            
            UserService.share.loadSingleUser(uid: msg.fromID, success: { (user) in
                msg.user = user
                
                PostService.share.loadSinglePost(msg.postID, success: { (post) in
                    msg.post = post
                    
                    sucess(msg)
                })
                
                
            })
            
            
        }
        
    }
    

}
