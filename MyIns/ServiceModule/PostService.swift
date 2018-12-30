//
//  PostService.swift
//  MyIns
//
//  Created by LiYong on 2018/12/13.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class PostService{
    
    let postDatabase = FIRDatabase.database().reference().child("Posts")
    let myPostDatabase = FIRDatabase.database().reference().child("MyPosts")
    
    static var share = PostService()
    
    private init(){
        
    }
 
    
    
    func createPostWithImageUndVideo(_ text:String,_ imageData:Data!,_ imageRatio:CGFloat!,_ videoUrl:URL?,success:@escaping ()->(),falure:@escaping (String?)->()){
        
        
        if let uid = AuthenticationService.share.getUserId() {
            
            UploadService.share.uploadPostImage(uid, imageData, success: { (storageMetadata,imageKey) in
                
                
                let autoid = self.postDatabase.childByAutoId().key
                
                let imageUrl = storageMetadata?.downloadURL()?.absoluteString ?? ""
                
                if videoUrl != nil {
                    
                    
                    
                    UploadService.share.uploadPostVideo(AuthenticationService.share.getUserId(), videoUrl, success: { (metadata,videokey) in
                        
                        let videoUrl = metadata?.downloadURL()?.absoluteString ?? ""
                        
                        
                        self.createPost(autoid, uid, text, imageUrl,imageKey!, imageRatio, videoUrl,videokey, success: {
                            success()
                        }, falure: { (msg) in
                            falure(msg)
                        })
                        
                        
                    }, falure: { (error) in
                        
                        falure(error?.localizedDescription)
                    })
                    
                }else{
                    
                    self.createPost(autoid, uid, text, imageUrl,imageKey! ,imageRatio, nil,nil, success: {
                        success()
                    }, falure: { (msg) in
                        falure(msg)
                    })
                    
                }
                
                
                
            }) { (error) in
                falure(error?.localizedDescription)
            }
        }else{
            ProgressHUD.showError("Bitte anmelden!")
        }
    }
    
    
    
    private func createPost(_ autoid:String, _ uid:String, _ text:String,_ imageUrl:String!,_ imageKey:String,_ imageRatio:CGFloat!,_ videoUrl:String!,_ videoKey:String!,success:@escaping ()->(),falure:@escaping (String?)->()){
        
        let newDatabase = self.postDatabase.child(autoid)
        
        let postTime = Date().timeIntervalSince1970
        
        newDatabase.setValue(["uid":uid, "text" : text, "imageUrl" : imageUrl,"imageKey":imageKey,"videoUrl":videoUrl,"videoKey":videoKey,"imageRatio":imageRatio,"postTime":postTime], withCompletionBlock: { (error, FIRDatabaseReference) in
            
            if error != nil {
                falure(error?.localizedDescription)
                return
            }
            
            let postID = FIRDatabaseReference.key
            
            FeedService.share.addPostToMyNewFeed(postID)
            
            self.addToMyPost(uid,postID)
            
            HashTagService.share.addPostToHashtag(text, postID)
            
            FeedService.share.addFeedToMyFollow(uid,postID,imageUrl, success: {
                
            })
            
           
            
            success()
        })
    }
    
    
    
    
    private func addToMyPost(_ userID:String,_ postID:String){
        
        myPostDatabase.child(userID).child(postID).setValue(true) { (Error, FIRDatabaseReference) in
            if let error = Error{
                
                print("createMyPost : \(error.localizedDescription)")
                
            }
        }
        
    }
    
    
    
    

    func deletePost(_ post:PostModel!,success:@escaping ()->(),falure:@escaping(String?)->()){
        
        postDatabase.child(post.postId).removeValue { (Error, FIRDatabaseReference) in
            if let error = Error {
                
                falure(error.localizedDescription)
                return
            }
            
            
            
            self.myPostDatabase.child(post.userId).child(post.postId).removeValue(completionBlock: { (Error, FIRDatabaseReference) in
                if let error = Error {
                    
                    falure(error.localizedDescription)
                    return
                }
                
                FeedService.share.removeFeed(post.userId, post.postId, success: {
                    
                    UploadService.share.deletePostImage(post.userId, post.imagekey, success: {
                        if let videokey = post.videokey {
                            
                            UploadService.share.deletePostVideo(post.userId, videokey, success: {
                                success()
                            }, falure: { (msg) in
                                falure(msg)
                            })
                            
                        }else{
                            success()
                        }
                    }, falure: { (msg) in
                        falure(msg)
                    })
                    
                }, falure: { (msg) in
                    falure(msg)
                })
            
                
            })
            
            
            
        }
        
    }
   
    
    func loadPost(success:@escaping (PostModel)->()){
        
        postDatabase.observe(FIRDataEventType.childAdded) { (dataSnapshot) in
            
            guard let dic = dataSnapshot.value as? [String:Any] else{return}
            
            let postModel = PostModel(dic,dataSnapshot.key)
            
            UserService.share.loadSingleUser(uid: postModel.userId, success: { (userModel) in
                
                postModel.userModel = userModel
                success(postModel)
                
            })
        }
    }
    
    func loadPostList(success:@escaping (PostModel)->()){
        
        postDatabase.observe(FIRDataEventType.value) { (dataSnapshot) in
            
            guard let dic = dataSnapshot.value as? [String:Any] else{return}
            
            let postModel = PostModel(dic,dataSnapshot.key)
            
            UserService.share.loadSingleUser(uid: postModel.userId, success: { (userModel) in
                
                postModel.userModel = userModel
                success(postModel)
                
            })
        }
    }
    
    func loadSinglePost(_ postID:String,success:@escaping (PostModel)->()){
        
        postDatabase.child(postID).observeSingleEvent(of: FIRDataEventType.value) { (dataSnapshot) in
            guard let dic = dataSnapshot.value as? [String:Any] else{return}
            
            let postModel = PostModel(dic,dataSnapshot.key)
            
            UserService.share.loadSingleUser(uid: postModel.userId, success: { (userModel) in
                
                postModel.userModel = userModel
                success(postModel)
                
            })
        }
    }
    
    
   
    
    
    func loadPopularPost(success:@escaping (PostModel)->()){

        postDatabase.queryOrdered(byChild: "likeCount").observe(FIRDataEventType.childAdded) { (dataSnapshot) in

            guard let dic = dataSnapshot.value as? [String:Any] else{return}

            let postModel = PostModel(dic,dataSnapshot.key)

            UserService.share.loadSingleUser(uid: postModel.userId, success: { (userModel) in

                postModel.userModel = userModel
                success(postModel)

            })
        }
    }
    
    func loadAllPopularPost(success:@escaping ([PostModel])->()){
        
        postDatabase.queryOrdered(byChild: "likeCount").observe(FIRDataEventType.value) { (dataSnapshot) in
            
            let all = dataSnapshot.children.allObjects as! [FIRDataSnapshot]
            
            var posts = [PostModel]()
            
            all.forEach({ (dataSnapshot) in
                guard let dic = dataSnapshot.value as? [String:Any] else{return}
                
                let postModel = PostModel(dic,dataSnapshot.key)
                posts.append(postModel)
               
            })
            posts = posts.reversed()
            success(posts)
            
           
        }
    }
    
    
    
    
    
    func loadUserPost(_ userID:String ,success:@escaping (PostModel)->()){
        
        myPostDatabase.child(userID).observeSingleEvent(of: FIRDataEventType.value) { (FIRDataSnapshot) in
           
            if let data = FIRDataSnapshot.children.allObjects as? [FIRDataSnapshot] {
                
                data.forEach({ (snapshot) in
                    
                    self.loadSinglePost(snapshot.key, success: { (postModel) in
                        success(postModel)
                    })
                    
                })
            }
        }
        
    }
    
    
    func getUserPostCount(_ userID:String,success:@escaping (Int)->()){
        
        myPostDatabase.child(userID).observe(FIRDataEventType.value) { (FIRDataSnapshot) in
            
            let count = FIRDataSnapshot.childrenCount
            
            success(Int(count))
            
        }
    }
    
    
  
    
  
    
    func addOderRemoveLike(_ postID:String, success:@escaping (PostModel)->(),falure:@escaping (String?)->()){
        
        
        let thePost = postDatabase.child(postID)
        
        
        thePost.runTransactionBlock({ (FIRMutableData) -> FIRTransactionResult in
            
                
            if var post = FIRMutableData.value as? [String: Any] {
                
                var starCount = post["likeCount"] as? Int ?? 0
                
                var stars = post["likes"] as? [String:Bool] ?? [String:Bool]()
                
                let uid = AuthenticationService.share.getUserId()
                
                if stars[uid!] == nil {
                    starCount += 1
                    stars[uid!] = true
                }else{
                    starCount -= 1
                    stars.removeValue(forKey: uid!)
                }
                
                
                post["likeCount"] = starCount
                
                post["likes"] = stars
                
                FIRMutableData.value = post
            
            }
            return FIRTransactionResult.success(withValue: FIRMutableData)
            
        }) { (Error, Bool, FIRDataSnapshot) in
            
            if let error = Error {
                
                falure(error.localizedDescription)
            }else{
                
                guard let snapshot = FIRDataSnapshot else{return}
                
                let dic = snapshot.value as! [String:Any]
                let post = PostModel(dic, snapshot.key)
                
                success(post)
            }
            
        }
        
        
        
    }
    
    
}
