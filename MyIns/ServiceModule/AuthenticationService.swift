//
//  AuthenticationService.swift
//  MyIns
//
//  Created by LiYong on 2018/12/6.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage



class AuthenticationService {
    
    
    static let share = AuthenticationService()
    
    private init(){}
    
    
    func autoLogin(completion :  ()->() ,falure:@escaping ()->()){
        
        if FIRAuth.auth()?.currentUser != nil {
            
            completion()
            
        }else{
            falure()
            
        }
    }
    
    
    func login(_ email:String!,_ password:String!,success:@escaping (FIRUser?)->(),falure:@escaping (Error?)->()){
        
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (FIRUser, Error) in
            
            if Error != nil {
                falure(Error)
                
                return
            }
            
            success(FIRUser)
        })
    }
    
    
    func signOut(success:@escaping ()->(),falure:@escaping (Error?)->()){
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            falure(error)
        }
        success()
    }
    
    
    func getUserId()->String!{
        let user = FIRAuth.auth()?.currentUser
        return user?.uid
    }
    
    
}

