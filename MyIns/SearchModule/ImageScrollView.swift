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
        
        self.backgroundColor = UIColor.clear
        
        mainScrollView.backgroundColor = UIColor.clear
        
        mainScrollView.contentInset = UIEdgeInsets(top: 90, left: 0, bottom: 0, right: 0)
        mainScrollView.scrollIndicatorInsets = UIEdgeInsets(top: 90, left: 0, bottom: 0, right: 0)
//        mainScrollView.showsHorizontalScrollIndicator = false
//        mainScrollView.showsVerticalScrollIndicator = false
        //        mainScrollView.backgroundColor = UIColor.white
        
        
        
        
        
        mainScrollView.delegate = self
        
        mainScrollView.decelerationRate = .fast
        
        mainScrollView.isDirectionalLockEnabled = true
        
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
        
        
        
        mainScrollView.contentSize = CGSize(width: CGFloat(viewCount) * screenWidth, height: mainScrollView.frame.height+50)
        
//        mainScrollView.isPagingEnabled = true

        
        PostService.share.loadAllPopularPost { (posts) in
            self.posts = posts
            self.collectionViewList[0].reloadData()
        }
    }

  
    
    func showViewIndex(index:Int){
        self.mainScrollView.setContentOffset(CGPoint(x: CGFloat(index) * screenWidth, y: self.mainScrollView.contentOffset.y), animated: true)
        
        self.collectionViewList[index].reloadData()
    }
}

extension ImageScrollView:UIScrollViewDelegate{
    
    //    计算最终停止的位置
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        
        if scrollView.isPagingEnabled {
            return
        }
        
        var targetX:CGFloat = 0.0
        
        var page = Int((scrollView.contentOffset.x+scrollView.bounds.size.width/2)/scrollView.bounds.size.width)
        
        if velocity.x == 0 {//用户松手
            
            targetX = CGFloat(page) * scrollView.bounds.size.width
            
        }else{//用户滑动
            
            page = Int((scrollView.contentOffset.x)/scrollView.bounds.size.width)
            
            if velocity.x < 0{//右滑
                print("右滑")
                targetX = scrollView.bounds.size.width * CGFloat(page)
            }else{//左滑
                print("左滑")
                
                if page+1 < collectionViewList.count{
                    
                    page = page + 1
                }
                targetX = scrollView.bounds.size.width * CGFloat(page)
            }
        }
        
        print("targetX:\(targetX)")
        
        let point = CGPoint (x: targetX, y: targetContentOffset.pointee.y)
        
        targetContentOffset.pointee = point
        
        self.delegate?.viewDidSelected(index: page)
    }
    
    
    
//    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)  {
//
//        let index = Int((scrollView.contentOffset.x+scrollView.frame.width/2)/scrollView.frame.width)
//
//        self.showViewIndex(index:index)
//
//        self.delegate?.viewDidSelected(index: index)
//    }
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        if (scrollView.contentOffset.x != 0 &&
//            scrollView.contentOffset.y != 0) {
//            scrollView.contentOffset = CGPoint(x: 0, y: 0)
//        }
        
        let index = Int(scrollView.contentOffset.x/scrollView.frame.width)

        self.collectionViewList[index].reloadData()

        if index+1 < self.collectionViewList.count{
            self.collectionViewList[index+1].reloadData()
        }
        
        var offsetY = scrollView.contentOffset.y + 90

        if offsetY < 0 {
            offsetY = 0
        }
        
//        print("offsetY:\(offsetY)")
        
        
        
        self.delegate?.scrollViewDidScroll(offSetY: offsetY)

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

