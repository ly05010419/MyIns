//
//  ActivityViewController.swift
//  MyIns
//
//  Created by LiYong on 2018/12/6.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var msgs = [MessageModel]()
    var badgeValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Activity"

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
      
        loadPosts()
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: "relogin"), object: nil, queue: OperationQueue.main) { (Notification) in
            self.loadPosts()
        }
        
    }
    
    func loadPosts(){
        
        self.msgs.removeAll()
        
        self.tableView.reloadData()
        
        badgeValue = 0
        
        MessageService.share.loadMessages { (messageModel) in
            self.msgs.append(messageModel)
            self.badgeValue = self.badgeValue + 1
            self.navigationController?.tabBarItem.badgeValue  = "\(self.badgeValue)"
            self.tableView.reloadData()
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

extension ActivityViewController:UITableViewDelegate,UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return msgs.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "activityTableViewCell", for: indexPath) as! ActivityTableViewCell
        
        cell.msg = self.msgs[indexPath.row]
        
        return cell
    }

}
