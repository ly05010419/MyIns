//
//  SearchViewController.swift
//  MyIns
//
//  Created by LiYong on 2018/12/6.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit



class SearchViewController: UIViewController {
 
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    @IBOutlet weak var titleScrollView: TitleScrollView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var titleScrollViewHeight:CGFloat?
    var titleScrollViewY:CGFloat?
    
    var imageScrollViewHeight:CGFloat?
    var imageScrollViewY:CGFloat?
    
    var searchBarY:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titles = ["推荐","游戏","搞笑","艺术","购物","军事","动物"]
        
        titleScrollView.titles = titles
        
        titleScrollView.delegate = self
        
        titleScrollViewHeight = titleScrollView.frame.height
        titleScrollViewY = titleScrollView.frame.origin.y
        
        imageScrollView.viewCount = titles.count
        
        imageScrollView.delegate = self
        
        imageScrollViewY = imageScrollView.frame.origin.y
        imageScrollViewHeight = imageScrollView.frame.height-49
        
        searchBar.delegate = self;
        searchBar.placeholder = "Search User"
        
        searchBarY = searchBar.frame.origin.y

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
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


extension SearchViewController:TitleScrollViewDelegete{
    func titleDidSelected(index: Int) {
        self.imageScrollView.showViewIndex(index: index)
    }
}


extension SearchViewController:ScrollViewWithCollectionViewsDelegate{
    func scrollViewDidScroll(offSetY: CGFloat) {
        
        searchBar.frame.origin = CGPoint(x: 0, y: searchBarY!-offSetY)
        
        self.titleScrollView.frame = CGRect(x: 0, y:titleScrollViewY!-offSetY, width: self.titleScrollView.frame.width, height: titleScrollViewHeight!)
        
        
        self.imageScrollView.frame = CGRect(x: 0, y: imageScrollViewY!-offSetY, width: imageScrollView.frame.width, height: imageScrollViewHeight!+offSetY)
    }
    
    func viewDidSelected(index: Int) {
        titleScrollView.showTitleIndex(index: index)
    }
}





extension SearchViewController:UISearchBarDelegate{
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let text = searchBar.text else {
            return
        }
        
        print(text)
        
        UserService.share.searchAllUsersWithName(text) { (userModel) in
            
            
            
        }
        
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        self.view.endEditing(true)
        
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        
        self.searchBar.resignFirstResponder()
        self.performSegue(withIdentifier: "addFreundVC", sender: nil)
        
    }
    
    
    
}

