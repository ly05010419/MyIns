//
//  ShowProfiViewController.swift
//  MyIns
//
//  Created by LiYong on 2018/12/21.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit

class ShowProfiViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var uid:String!
    var user:UserModel!
    
    var posts = [PostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        
        let itemWidth = (UIScreen.main.bounds.width-2)/3
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 165)
        collectionView.collectionViewLayout = layout
        
        
        UserService.share.loadSingleUser(uid:uid!) { (userModel) in
            self.user = userModel

            self.title = self.user.userName
        }
        

        PostService.share.loadUserPost(uid) { (postModel) in
            self.posts.insert(postModel, at: 0)
            
            self.collectionView.reloadData()
        }
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ShowProfiViewController:UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return posts.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfiCollectionViewCell", for: indexPath) as! ProfiCollectionViewCell
        
        cell.post = self.posts[indexPath.row]
        return cell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        let resuableView = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "ProfiHeader", for: indexPath) as! ProfiHeaderCollectionReusableView
        
        resuableView.uid = self.uid
        
        return resuableView
    }
    
}
