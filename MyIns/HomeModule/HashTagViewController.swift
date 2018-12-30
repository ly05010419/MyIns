//
//  HashTagViewController.swift
//  MyIns
//
//  Created by LiYong on 2018/12/23.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit

class HashTagViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
   
    var hashtag:String!
    
    var posts = [PostModel]()
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tag = hashtag {
            self.navigationItem.title = "#\(tag)"
        }
        
        let layout = UICollectionViewFlowLayout()
        
        let imageWidth = (UIScreen.main.bounds.width-3)/4
        
        layout.itemSize = CGSize(width: imageWidth, height: imageWidth)
        
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self;
        
        HashTagService.share.loadAllHashTagPost(self.hashtag) { (postModel) in
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


extension HashTagViewController: UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return posts.count
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hashtagCollectionViewCell", for: indexPath) as! HashTagCollectionViewCell
        
        let post = posts[indexPath.row]
        
        if let url = URL(string: post.postImageUrl) {
            
            cell.imageView.sd_setImage(with: url, completed: nil)
        }
        
        return cell
    }
    
    
}



