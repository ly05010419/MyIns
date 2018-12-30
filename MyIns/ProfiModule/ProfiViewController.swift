//
//  ProfiViewController.swift
//  MyIns
//
//  Created by LiYong on 2018/12/6.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit

class ProfiViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [PostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let userID = AuthenticationService.share.getUserId() else {
            return
        }
        
        UserService.share.loadSingleUser(uid:userID) { (userModel) in
            
            self.navigationItem.title = userModel.userName
        }

        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()

        let itemWidth = (UIScreen.main.bounds.width-2)/3

        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 165)
        collectionView.collectionViewLayout = layout
        
        
        loadPosts()
       
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: "relogin"), object: nil, queue: OperationQueue.main) { (Notification) in
            self.loadPosts()
        }
        
    }
    
    func loadPosts(){
        
        posts.removeAll()
        
        self.collectionView.reloadData()
        
        let uid = AuthenticationService.share.getUserId()
        
        PostService.share.loadUserPost(uid!) { (postModel) in
            self.posts.insert(postModel, at: 0)
            
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func addUserAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: "addVC", sender: nil)
        
    }
    
    
    
    @IBAction func logoutAction(_ sender: Any) {
        
        
        AuthenticationService.share.signOut(success: {
            
            let storyBoard = UIStoryboard(name: "Start", bundle: nil)
            
            let loginVc = storyBoard.instantiateViewController(withIdentifier: "loginVC") as! UINavigationController
            
            self.present(loginVc, animated: true, completion: nil)
            
        }) { (error) in
            
            ProgressHUD.showError(error?.localizedDescription)
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

extension ProfiViewController:UICollectionViewDataSource{
    
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
        
        
        resuableView.uid = AuthenticationService.share.getUserId()
        
        return resuableView
    }
    
    

}
