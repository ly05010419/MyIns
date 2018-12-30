//
//  UserService.swift
//  MyIns
//
//  Created by LiYong on 2018/12/13.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class UserService{
    
    let userDatabase = FIRDatabase.database().reference().child("users")
    
    static let share = UserService()
    
    private init(){}
    
    
    func createUser(_ name:String!,_ email:String!,_ password:String!,_ userImageData:Data,success:@escaping (FIRUser?)->(),falure:@escaping (String?)->()){
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            
            if error != nil {
                
                falure(error?.localizedDescription)
                
                return
            }
            
            UserService.share.uploadUserImage(user, userImageData, complition: { (FIRStorageMetadata, Error) in
                
                if Error != nil {
                    
                    falure("Ihre Konto ist erfolgreich erstellt, bitte versuche später noch einmal Ihre ProfiImage hochzuladen!")
                    
                    UserService.share.saveUser(user!.uid, name, email, "", complition: nil)
                    
                    return
                }
                
                let imageUrl = FIRStorageMetadata?.downloadURL()?.absoluteString ?? ""
                
                UserService.share.saveUser(user!.uid, name, email, imageUrl, complition: {
                    success(user)
                })
            })
        })
        
    }
    
    
   
    
    func loadUsers(success:@escaping (UserModel)->()){
        
        userDatabase.observe(FIRDataEventType.childAdded) { (dataSnapshot) in
            
            guard let dic = dataSnapshot.value as? [String:String] else{return}
            
            let user = UserModel(dic,dataSnapshot.key)
            
            success(user)
        }
    }
    
    func searchAllUsersWithName(_ name:String,success:@escaping (UserModel)->()){
        
        userDatabase.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: name).queryEnding(atValue: name+"\u{f8ff}").queryLimited(toLast: 10).observe(FIRDataEventType.value) { (dataSnapshot) in
            
            
            
            if let user = dataSnapshot.children.allObjects as? [FIRDataSnapshot] {
                
                user.forEach({ (snapshot) in
                    
                    guard let dic = snapshot.value as? [String:String] else{return}
                    
                    let u = UserModel(dic,snapshot.key)
                    
                    if u.uid != AuthenticationService.share.getUserId(){
                        
                        FollowService.share.isfollowing(with: u.uid, success: { (isFollowing) in
                            u.isFollowing = isFollowing
                            success(u)
                        })
                    }
                    
                    
                })
                
            }
            
            
        }
    }
    
    func loadSingleUser(uid:String,success:@escaping (UserModel)->()){
        
        let ref = userDatabase.child(uid)
        
        ref.observe(FIRDataEventType.value) { (dataSnapshot) in
            
            guard let dic = dataSnapshot.value as? [String:String] else{return}
            
            let user = UserModel(dic,dataSnapshot.key)
            
            success(user)
        }
    }
    
    func loadCurrentUser(success:@escaping (UserModel)->()){
        
        guard let userID = AuthenticationService.share.getUserId() else {
            return
        }
        
        UserService.share.loadSingleUser(uid: userID) { (user) in
            success(user)
        }
    }


    func uploadUserImage(_ user:FIRUser!,_ imageData:Data!,complition:@escaping (FIRStorageMetadata?, Error?)->()){
        
        
        let storageRef = FIRStorage.storage().reference().child("imageProfi").child(user.uid)
        
        storageRef.put(imageData, metadata: nil) { (metadata, Error) in
            
            complition(metadata, Error)
        }
        
        
    }
    
    
    
    
    func saveUser(_ uid:String,_ name:String,_ email:String,_ imageUrl:String,complition:(()->Void)?){
        
        let database = userDatabase.child(uid)
        
        database.setValue(["username" : name,"username_lowercase":name.lowercased(),"email" : email ,"imageUrl" : imageUrl])
        
        complition?()
    }
    
    
    
    
}
