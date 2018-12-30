//
//  CommentTableViewController.swift
//  MyIns
//
//  Created by LiYong on 2018/12/9.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit

class CommentTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var profiImage: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var commentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var hashtag:String!
    
    public var post:PostModel?
    
    var commnets = [CommentModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Kommentar"
    
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.profiImage.clipsToBounds = true
        self.profiImage.layer.cornerRadius = self.profiImage.frame.width/2
        
        guard let uid = AuthenticationService.share.getUserId() else {
            return
        }
        
        UserService.share.loadSingleUser(uid:uid ) { (user) in
            if let imageUrl = user.userImageUrl,let url = URL(string: imageUrl) {
                self.profiImage.sd_setImage(with: url, completed: nil)
            }
            
        }
        
        loadComments()
        
        checkText()
        
        textField.addTarget(self, action: #selector(checkText), for: UIControl.Event.editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardshow(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardhidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView.keyboardDismissMode = .onDrag
    }
    
    func loadComments(){
        
        guard let postId = self.post?.postId else {return}
        
        CommentService.share.loadComment(postId: postId) { (commentModel) in
            self.commnets.append(commentModel)
            
            self.tableView.reloadData()
        }
    }
    
    @objc func checkText(){
        
        guard let text = textField.text else{return}
        if text.count > 0{
            sendButton.isEnabled = true
        }else{
            sendButton.isEnabled = false
        }
        
    }
    
    
   
    
    @objc func keyboardshow(note: Notification){
        
        let height = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue?.height ?? 0
        
        tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y + height), animated: false)
        
        self.commentViewBottomConstraint.constant = height
        self.view.layoutIfNeeded()
    }
    @objc func keyboardhidden(note: Notification){
        
        let height = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue?.height ?? 0
        tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y - height), animated: false)
        
        self.commentViewBottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)  {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func sendAction(_ sender: Any) {
        
        guard let postId = self.post?.postId else {
            ProgressHUD.showError("Auswählen Sie bitte ein Post")
            return
        }
        guard let userID = self.post?.userId else {
            ProgressHUD.showError("Error!")
            return
        }
        
        CommentService.share.createComment(self.textField.text!,postId,userID,success: {
            
            ProgressHUD.showSuccess("comment success!")
            
            self.view.endEditing(true)
            self.textField.text = ""
            self.checkText()
            
        }) { (error) in
            ProgressHUD.showError(error)
        }
        
       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       if segue.identifier == "HashTagVC" {
            let hashtagVC = segue.destination as! HashTagViewController
            
            hashtagVC.hashtag = self.hashtag
        }
        
    }

    
    func gotoHashTagVC(_ hashtag:String){
        self.hashtag = hashtag
        
        self.performSegue(withIdentifier: "HashTagVC", sender: nil)
        
    }
    
    
    
    

    // MARK: - Table view data source

   

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.commnets.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        cell.comment = self.commnets[indexPath.row]
        cell.commentVC = self
        return cell
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
