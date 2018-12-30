//
//  KeyChainService.swift
//  MyIns
//
//  Created by LiYong on 2018/12/25.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Keychain

class KeyChainService{
    
    
    static let share = KeyChainService()
    
    private init(){}

    func addEmailUndPasswordInKeyChain(_ email:String,_ password:String){
        
        let flag = Keychain.save(password, forKey: email)
        if flag {
            
            print("Password gespeichert!")
        }
    }
    
    func getPassword(_ email:String)->String?{
        // You can retrieve it by using the same key:
        
        return Keychain.load(email)
        
    }
    
}
