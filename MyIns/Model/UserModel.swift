//
//  UserModel.swift
//  MyIns
//
//  Created by LiYong on 2018/12/9.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import Foundation


class UserModel {
    
    var userName:String!
    var userImageUrl:String!
    var userEmail:String!
    var uid:String!
    var isFollowing:Bool!

    
    init(_ dic:[String:String],_ key:String){
        guard let name = dic["username"] else {return}
        guard let imageUrl = dic["imageUrl"] else {return}
        guard let email = dic["email"] else {return}
        
        
        userName = name
        userImageUrl = imageUrl
        userEmail = email
       
        uid = key
        
        
        
     
    }
    
}
