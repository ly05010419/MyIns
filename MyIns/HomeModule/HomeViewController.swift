//
//  HomeViewController.swift
//  MyIns
//
//  Created by LiYong on 2018/12/6.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var post:PostModel?
    
    var hashtag:String!
    
    var posts = [PostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Timeline"
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.delegate = self;
        tableView.dataSource = self;

        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        

        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: "relogin"), object: nil, queue: OperationQueue.main) { (Notification) in
            self.loadPosts()
        }
        
        
        autoLogin()
    }
    
    fileprivate func autoLogin() {
        AuthenticationService.share.autoLogin(completion: {
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "relogin"), object: nil)
            
        }) {
            let storyBoard = UIStoryboard(name: "Start", bundle: nil)
            
            let loginVc = storyBoard.instantiateViewController(withIdentifier: "loginVC") as! UINavigationController
            
            self.present(loginVc, animated: true, completion: nil)
        }
    }
    
  
    
   
    
    func loadPosts(){
        
        posts.removeAll()
        
        self.tableView.reloadData()
        
        activityIndicator.startAnimating()
        
        FeedService.share.loadMyNewFeed { (postModel) in
            self.posts.insert(postModel, at: 0)
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
            self.tableView.setContentOffset(CGPoint.zero, animated: true)

        }
        
     
        
//        FeedService.share.removePostFromFeed { (postModel) in
//
//            self.posts = self.posts.filter({ (p) -> Bool in
//                p.postId != postModel.postId
//            })
//
//            self.tableView.reloadData()
//            self.tableView.setContentOffset(CGPoint.zero, animated: true)
//        }
        
    }
    
    
    @IBAction func refrechAction(_ sender: Any) {
        self.posts.removeAll()
        loadPosts()
    }
    
   
    func showAlert(_ alertVC:UIAlertController){
        
        self.present(alertVC, animated: true, completion: nil)
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

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
      return posts.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        
        cell.postModel = self.posts[indexPath.row]
        cell.homeVC = self
        cell.commentButton.tag = indexPath.row
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "commentVC" {    
            let comentVC = segue.destination as! CommentTableViewController
            
            let button =  sender as! UIButton
            
            comentVC.post = posts[button.tag]
            
        }else if segue.identifier == "HashTagVC" {
            let hashtagVC = segue.destination as! HashTagViewController
            
            hashtagVC.hashtag = self.hashtag
        }
        
    }
    
    
    func gotoHashTagVC(_ hashtag:String){
        self.hashtag = hashtag
        
        self.performSegue(withIdentifier: "HashTagVC", sender: nil)
        
    }
    
   

}


//extension HomeViewController:CommentActionDelegete{
//    func commentAction(_ post: PostModel?) {
//        self.post = post
//        self.performSegue(withIdentifier: "commentVC", sender: nil)
//    }
//
//}
