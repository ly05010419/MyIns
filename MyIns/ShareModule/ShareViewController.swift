//
//  ShareViewController.swift
//  MyIns
//
//  Created by LiYong on 2018/12/6.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit
import Photos

class ShareViewController: UIViewController,UITabBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate{
    
    
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var imageColletionView: UICollectionView!
    
    @IBOutlet weak var shareView: UIView!
    
    fileprivate let imageManager = PHCachingImageManager()
    var allPhotos: PHFetchResult<PHAsset>!
    fileprivate var thumbnailSize: CGSize!
    fileprivate var playerLayer: AVPlayerLayer!
    var selectedAsset: PHAsset!
    
    var aspectFill = true
    
    var imageWidth:CGFloat = 0.0
    var imageSize:CGSize!
    
    var shareViewY:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareViewY = shareView.frame.origin.y
        
        let screenWidth = UIScreen.main.bounds.width
        
        let itemWidth = (screenWidth-3)/4
        
        thumbnailSize = CGSize(width:itemWidth , height: itemWidth)
        
        imageSize = CGSize(width:screenWidth*2 , height: screenWidth*2)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = thumbnailSize
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        imageColletionView.collectionViewLayout = layout
        imageColletionView.delegate = self
        imageColletionView.dataSource = self
        
        imageColletionView.contentInset = UIEdgeInsets(top: 316, left: 0, bottom: 0, right: 0)
        
        imageColletionView.scrollIndicatorInsets = UIEdgeInsets(top: 316, left: 0, bottom: 0, right: 0)
        
        (imageColletionView as UIScrollView).delegate = self

        
        checkAuthorizationForPhotoLibraryAndGet()
    }
    

    
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        var offsetY = scrollView.contentOffset.y + 316
        
        print(offsetY)
        
        if offsetY < 0 {
            
            offsetY = 0
        }
        
        if offsetY > 316 {
            offsetY = 316
            
        }
        
        shareView.frame.origin = CGPoint(x: 0, y: shareViewY!-offsetY)
        
    }
    
    private func checkAuthorizationForPhotoLibraryAndGet(){
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            
            getAlleFotos()
        }else {
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.getAlleFotos()
                }else {
                    ProgressHUD.showError("Foto greifen Error!")
                }
            })
        }
    }
    
    func getAlleFotos(){
        
        let requestOptions=PHImageRequestOptions()
        
        requestOptions.isSynchronous=true
        requestOptions.deliveryMode = .fastFormat
        requestOptions.resizeMode = .fast
        
        let fetchOptions=PHFetchOptions()
        fetchOptions.sortDescriptors=[NSSortDescriptor(key:"creationDate", ascending: false)]
        
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        
        allPhotos =  PHAsset.fetchAssets(with: fetchOptions)
        
        
        selectedAsset = allPhotos[0]
        
        addImageOderVideo()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shareDetaiVC" {
            let vc = segue.destination as! ShareDetailViewController
            
            vc.asset = self.selectedAsset
            vc.aspectFill = self.aspectFill
            vc.imageSize = self.imageSize
        }
    }
    
    
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        
        switch item.tag {
        case 1:
            
            return
        case 2:
            findEinFoto()
        case 3:
            return
        default:
            return
        }
        
    }
    
    
    func findEinFoto(){
        
        self.performSegue(withIdentifier: "CamaraVC", sender: nil)
        
    }
    
    
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return allPhotos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! FotoCollectionViewCell
        
        let asset = allPhotos.object(at: indexPath.item)
        
        cell.representedAssetIdentifier = asset.localIdentifier
        
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.cellImageView.image = image
            }
        })
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        selectedAsset = allPhotos.object(at: indexPath.item)
        
        addImageOderVideo()
    }
    
    
    func addImageOderVideo(){
        
        if self.playerLayer != nil {
            self.playerLayer.removeFromSuperlayer()
        }
        
        if selectedAsset.mediaType == .image {
            
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            
            PHImageManager.default().requestImage(for: selectedAsset, targetSize: imageSize, contentMode: .aspectFit, options: options, resultHandler: { image, _ in
                
                if self.aspectFill {
                    self.shareImageView.contentMode = .scaleAspectFill
                }else{
                    self.shareImageView.contentMode = .scaleAspectFit
                }
                
                self.shareImageView.image = image

            })
            
        }else
            
            if selectedAsset.mediaType == .video {
            
            play()
        }
        
    }
    
    func play() {

        let options = PHVideoRequestOptions()
        
        options.deliveryMode = .automatic
        
        PHImageManager.default().requestPlayerItem(forVideo: selectedAsset, options: options, resultHandler: { playerItem, info in
            DispatchQueue.main.sync {
                
                let player = AVPlayer(playerItem: playerItem)
                
                if self.playerLayer != nil{
                    
                    self.playerLayer.player = player
                }else{
                    
                    self.playerLayer = AVPlayerLayer(player: player)
                }
              
                if self.aspectFill {
                    self.playerLayer.videoGravity = .resizeAspectFill
                }else{
                    self.playerLayer.videoGravity = .resizeAspect
                }
                
                self.playerLayer.frame = CGRect(origin: CGPoint.zero, size: self.shareImageView.frame.size)
                self.shareImageView.layer.addSublayer(self.playerLayer)

                player.play()
                
                self.shareImageView.image = nil
            }
        })
        
    }
    
    
    @IBAction func abbrechenAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func imageRatioAction(_ sender: Any) {
        
        aspectFill = !aspectFill
        
        if selectedAsset.mediaType == .image {
            if self.aspectFill {
                self.shareImageView.contentMode = .scaleAspectFill
            }else{
                self.shareImageView.contentMode = .scaleAspectFit
            }
            
        }else{
            
            if self.aspectFill {
                self.playerLayer.videoGravity = .resizeAspectFill
            }else{
                self.playerLayer.videoGravity = .resizeAspect
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

