//
//  HashTagService.swift
//  MyIns
//
//  Created by LiYong on 2018/12/23.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class HashTagService{
    
    let hashDatabase = FIRDatabase.database().reference().child("Hashtags")
    
    
    static var share = HashTagService()
    
    private init(){
        
    }
    
    
    func addPostToHashtag(_ text:String,_ postID:String){
        
//        let split = text.components(separatedBy: CharacterSet.init(charactersIn: " "))

        let split = text.components(separatedBy: CharacterSet.whitespaces)
        
        for word in split {
        
//            if word.contains(Character("#")) {

            if word.hasPrefix("#") && word.count>1{
                
                let hashtag = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                
                let database = hashDatabase.child(hashtag)
                
                database.child(postID).setValue(true)
                
            }
        }
    }
    
    
    func loadAllHashTagPost(_ hashtag:String,success:@escaping (PostModel)->()){
        
        hashDatabase.child(hashtag).observe(FIRDataEventType.value) { (dataSnapshot) in
            
            let all = dataSnapshot.children.allObjects as! [FIRDataSnapshot]
            
            all.forEach({ (dataSnapshot) in
                
                let key = dataSnapshot.key
                
                PostService.share.loadSinglePost(key, success: { (postModel) in
                    success(postModel)
                })

            })
            
        }
    }
    
}
