//
//  ScrollViewWithCollectionViews.swift
//  MyIns
//
//  Created by LiYong on 2018/12/29.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit

protocol ScrollViewWithCollectionViewsDelegate {
    func viewDidSelected(index:Int)
    func scrollViewDidScroll(offSetY:CGFloat)
}

class ImageScrollView: UIView {
    
    var mainScrollView: UIScrollView!
    
    var collectionViewList = [UICollectionView]()
    
    var posts = [PostModel]()
    
    let screenWidth = UIScreen.main.bounds.width
    
    var startOffsetY:CGFloat!
    
    var delegate:ScrollViewWithCollectionViewsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var viewCount:Int!{
        didSet{
            setupViews()
        }
    }
    
    func setupViews() {
        mainScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width:self.frame.width, height:frame.height))
        
        mainScrollView.isDirectionalLockEnabled = true
        
        mainScrollView.delegate = self
        
        self.addSubview(mainScrollView)
        
        let imageWidth = ((screenWidth-10)-2)/3
        
        
        for index in 0 ..< viewCount {
            
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: imageWidth, height: imageWidth)
            layout.minimumLineSpacing = 1
            layout.minimumInteritemSpacing = 1
            
            let collectionView = UICollectionView(frame: CGRect(x: CGFloat(index) * screenWidth+5, y: 0, width:screenWidth-10, height:mainScrollView.frame.height), collectionViewLayout: layout)
            
            collectionView.collectionViewLayout = layout
            collectionView.dataSource = self
            (collectionView as UIScrollView).delegate = self
            
            collectionView.backgroundColor = UIColor.white
            collectionView.layer.cornerRadius = 10
            
            collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            
            collectionViewList.append(collectionView)
            
            mainScrollView.addSubview(collectionView)
            
            
            collectionView.isUserInteractionEnabled = false
        }
        
        mainScrollView.backgroundColor = UIColor.white
        
        mainScrollView.contentSize = CGSize(width: CGFloat(viewCount) * screenWidth, height: mainScrollView.frame.height+200)
        
        mainScrollView.isPagingEnabled = true
        
        
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = false
        
        
        PostService.share.loadAllPopularPost { (posts) in
            self.posts = posts
            self.collectionViewList[0].reloadData()
        }
    }

    override func layoutSubviews() {
        
        self.mainScrollView.frame.size = CGSize(width: self.frame.width, height: self.frame.height)

        self.collectionViewList.forEach { (collectionView) in

            collectionView.frame.size = CGSize(width: collectionView.frame.width, height: self.frame.height)
        }
    }
    
    
    func showViewIndex(index:Int){
        self.mainScrollView.setContentOffset(CGPoint(x: CGFloat(index) * screenWidth, y: 0), animated: true)
        
        self.collectionViewList[index].reloadData()
    }
    
   
    
}

extension ImageScrollView:UIScrollViewDelegate{
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)  {
        
        let index = Int(scrollView.contentOffset.x/scrollView.frame.width)
        
      
        
        self.delegate?.viewDidSelected(index: index)
    }
    
    
   
    
     public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let scVW = scrollView as? UICollectionView{
            
            var offsetY = scVW.contentOffset.y
            
            if offsetY > 35 {
                offsetY = 35
            }
            
            if offsetY < 0 {
                offsetY = 0
            }
            
            print("offsetY:\(offsetY)")
            
            
            
            self.delegate?.scrollViewDidScroll(offSetY: offsetY)
            
            
        }else{
            
            let index = Int(scrollView.contentOffset.x/scrollView.frame.width)
            
            self.collectionViewList[index].reloadData()
            
            if index+1 < self.collectionViewList.count{
                self.collectionViewList[index+1].reloadData()
                
            }
            
        }
        
    }
    
}


extension ImageScrollView: UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return posts.count
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
        
        let post = posts[indexPath.row]
        
        if let url = URL(string: post.postImageUrl) {
            
            cell.imageView.sd_setImage(with: url, completed: nil)
        }
        
        return cell
    }
    
    
    
    
    
}

