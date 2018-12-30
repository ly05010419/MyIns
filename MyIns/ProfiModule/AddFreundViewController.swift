//
//  AddFreundViewController.swift
//  MyIns
//
//  Created by LiYong on 2018/12/14.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit

class AddFreundViewController: UIViewController {

    var uid:String?
    var searchbar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchbar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-50, height: 44))
        searchbar.delegate = self;
        searchbar.placeholder = "Search User"
        
        let item = UIBarButtonItem(customView: searchbar)
//        self.navigationItem.titleView = searchbar
        
        self.navigationItem.setRightBarButton(item, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute:
            {
                self.searchbar.becomeFirstResponder()
        })
        
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.keyboardDismissMode = .onDrag
        
        UserService.share.loadUsers { (userModel) in
            
            guard let userID = AuthenticationService.share.getUserId() else{return}
            
            if userModel.uid != userID {
                
                FollowService.share.isfollowing(with: userModel.uid, success: { (isFollowing) in
                    userModel.isFollowing = isFollowing
                    self.users.append(userModel)
                    self.tableView.reloadData()
                })
                
              
            }
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


extension AddFreundViewController: UITableViewDelegate,UITableViewDataSource{
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! AddTableViewCell
        cell.selectionStyle = .none
        cell.user = self.users[indexPath.row]
        return cell
        
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        uid = self.users[indexPath.row].uid
        self.performSegue(withIdentifier: "showProfiVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ShowProfiViewController{
            
            controller.uid = self.uid
            
        }
    }
    
    
}

extension AddFreundViewController:UISearchBarDelegate{
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard var text = searchBar.text else {
            return
        }
        
        text = text.lowercased()
        
        self.users.removeAll()
        self.tableView.reloadData()
        
        UserService.share.searchAllUsersWithName(text) { (userModel) in
            
            self.users.append(userModel)
            self.tableView.reloadData()
            
        }
        
    }
    
}
