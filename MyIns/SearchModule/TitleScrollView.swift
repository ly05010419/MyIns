//
//  PageTitleView.swift
//  MyIns
//
//  Created by LiYong on 2018/12/29.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit

protocol TitleScrollViewDelegete {
    func titleDidSelected(index:Int)
}

class TitleScrollView: UIView {

    var titleIndicator:UIView!
    
    var labels = [UILabel]()
    
    var imageViews = [UIImageView]()
    
    var delegate:TitleScrollViewDelegete?
    
    var titles:[String]?{
        
        didSet{
            setupViews()
        }
    }
    
    private let screenWidth = UIScreen.main.bounds.width
    
    private var lebelWidth:CGFloat!
    
    
    
    private var imageWidth:CGFloat!
    

    
    private var frameHeight:CGFloat!
    
    private var titleScrollView: UIScrollView!
    
    override init(frame:CGRect) {

        super.init(frame: frame)
        frameHeight = frame.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        frameHeight = frame.height
    }
    
    override func layoutSubviews() {
        
        self.titleScrollView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        self.titleScrollView.contentSize = CGSize(width: CGFloat(titles!.count) * lebelWidth, height: self.titleScrollView.frame.height)
        
        self.titleIndicator.frame.origin = CGPoint(x: titleIndicator.frame.origin.x, y: frame.height-15)
        
        labels.forEach { (label) in
            label.frame.origin = CGPoint(x: label.frame.origin.x, y: frame.height-65)
        }
        
        imageViews.forEach { (imageView) in
            imageView.frame.size = CGSize(width: imageWidth, height: frame.height-10)
        }
    }
    

    fileprivate func setupViews() {
        
        
        self.titleScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        self.addSubview(self.titleScrollView)
        
        self.lebelWidth = self.screenWidth/3
        

        self.backgroundColor = UIColor.white
        self.titleScrollView.backgroundColor = UIColor.white
//        self.backgroundColor = UIColor.red
//        self.titleScrollView.backgroundColor = UIColor.blue
        
        
        
        self.titleScrollView.showsVerticalScrollIndicator = false
        self.titleScrollView.showsHorizontalScrollIndicator = false
        
        imageWidth = lebelWidth-10

        
        for index in titles!.indices {
            
            let x = CGFloat(index) * lebelWidth
            
            let imageView = UIImageView(image: UIImage(named: "ps4"))
            imageView.clipsToBounds = true
            imageView.frame = CGRect(x:x+5 , y: 5, width: imageWidth, height: frame.height-10)
            imageView.layer.cornerRadius = 10
            imageView.contentMode = .center
            
            imageViews.append(imageView)
            
            self.titleScrollView.addSubview(imageView)
            
            let label = UILabel(frame: CGRect(x: x, y: frame.height-65, width: lebelWidth, height: frame.height-20))
            label.text = titles![index]
            
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.shadowOffset = CGSize(width: 1, height: 1)
            label.shadowColor = UIColor.gray
            label.textAlignment = .center
            label.textColor = UIColor.white
            
            labels.append(label)
            
            self.titleScrollView.addSubview(label)
            
            imageView.isUserInteractionEnabled = true
            imageView.tag = index
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
            imageView.addGestureRecognizer(tap)
            
        }
        
        self.titleIndicator = UIView(frame: CGRect(x: (self.lebelWidth/4), y: frame.height-15, width: lebelWidth/2, height: 2))
        titleIndicator.backgroundColor = UIColor.white
        
        self.titleScrollView.addSubview(titleIndicator)
        
        self.titleScrollView.contentSize = CGSize(width: CGFloat(titles!.count) * lebelWidth, height: self.titleScrollView.frame.height)
    }
    
    
    @objc func tapAction(sender:UITapGestureRecognizer){
        
        let index = (sender.view as! UIImageView).tag
        
        showTitleIndex(index: index)
        
        self.delegate?.titleDidSelected(index: index)
    }
    
     func showTitleIndex(index:Int){
        
        self.titleIndicator.frame = CGRect(x: CGFloat(index) * self.lebelWidth+(self.lebelWidth/2), y: self.titleIndicator.frame.origin.y, width: 0, height: 2)
        
        UIView.animate(withDuration: 0.3) {
            
            self.titleIndicator.frame = CGRect(x: CGFloat(index) * self.lebelWidth+(self.lebelWidth/4), y: self.titleIndicator.frame.origin.y, width: self.lebelWidth/2, height: 2)
        }
        
        var offsetX = CGFloat(index) * self.lebelWidth
        
        if offsetX > self.titleScrollView.contentSize.width-screenWidth{
            offsetX = self.titleScrollView.contentSize.width-screenWidth
        }
        
        self.titleScrollView.setContentOffset(CGPoint(x:offsetX , y: 0), animated: true)
    }
    
   
    
}
