//
//  Message.swift
//  MyIns
//
//  Created by LiYong on 2018/12/25.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import Foundation
class MessageModel{
    
    var id:String!
    var fromID:String!
    var postID:String!
    var type:String!
    var time:Double!
    
    var user:UserModel!
    var post:PostModel!
    var commentText:String!
    
    init(_ data:[String: Any]){
        id =  data["id"] as? String
        fromID =  data["fromID"] as? String
        postID =  data["postID"] as? String
        type =  data["type"] as? String
        
        time =  data["time"] as? Double
        commentText =  data["commentText"] as? String
    }
}
