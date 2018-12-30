//
//  CommentModel.swift
//  MyIns
//
//  Created by LiYong on 2018/12/10.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import Foundation

class CommentModel{
    
    var commentText:String?
    var uid:String?
    var user:UserModel?
    
    init(_ dic:[String:String]){
        
        commentText = dic["commentText"]
        uid = dic["uid"]
        
    }
    
}
