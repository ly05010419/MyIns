//
//  UploadService.swift
//  MyIns
//
//  Created by LiYong on 2018/12/22.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class UploadService {
    
    let storage = FIRStorage.storage().reference().child("Posts")
    
    static var share = UploadService()
    
    private init(){
        
    }
    
    func uploadPostImage(_ uid:String!,_ imageData:Data! ,success:@escaping (FIRStorageMetadata?,String?)->(),falure:@escaping (Error?)->()){
        
        let key = NSUUID().uuidString
        let storageRef = storage.child(uid).child(key)
        
        storageRef.put(imageData, metadata: nil) { (metadata, error) in
            
            if error != nil {
                falure(error)
                return
            }
            
            success(metadata,key)
        }
    }
    
    func uploadPostVideo(_ uid:String!,_ videoUrl:URL! ,success:@escaping (FIRStorageMetadata?,String?)->(),falure:@escaping (Error?)->()){

        let key = NSUUID().uuidString
        
        let storageRef = storage.child(uid).child(key)
        
        storageRef.putFile(videoUrl, metadata: nil) { (metadata, error) in
            if error != nil {
                falure(error)
                return
            }
            
            success(metadata,key)
        }
        
    }
    
    func deletePostVideo(_ uid:String!,_ videoKey:String! ,success:@escaping ()->(),falure:@escaping (String?)->()){
        
        let storageRef = storage.child(uid).child(videoKey)
        storageRef.delete { (error) in
            if error != nil {
                falure(error?.localizedDescription)
                return
            }
            
            success()
        }
    }
    
    func deletePostImage(_ uid:String!,_ imagekey:String! ,success:@escaping ()->(),falure:@escaping (String?)->()){
        
        let storageRef = storage.child(uid).child(imagekey)
        storageRef.delete { (error) in
            if error != nil {
                falure(error?.localizedDescription)
                return
            }
            
            success()
        }
    }
    
    
    
}
