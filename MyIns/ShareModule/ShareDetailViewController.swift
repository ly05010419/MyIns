//
//  ShareDetailViewController.swift
//  MyIns
//
//  Created by LiYong on 2018/12/8.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit
import Photos

class ShareDetailViewController: UIViewController {
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    public var postImage: UIImage!
    
    var asset: PHAsset!
    
    var aspectFill = true
    
    var imageSize:CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = PHImageRequestOptions()
        
        options.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: options, resultHandler: { image, _ in
            
            if self.aspectFill {
                self.shareImageView.contentMode = .scaleAspectFill
            }else{
                self.shareImageView.contentMode = .scaleAspectFit
            }
            
            self.postImage = image
            
            self.shareImageView.image = self.postImage
            
        })
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func fertigAction(_ sender: Any) {
        self.view.endEditing(true)
        
        guard let image = postImage else{
            ProgressHUD.show("Error! kein Image!!!")
            return
        }
        
        ProgressHUD.show("upload...")
        
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        let imageRatio = image.size.width/image.size.height
        
       
        if asset.mediaType == .image {

            PostService.share.createPostWithImageUndVideo( self.textView.text, imageData,imageRatio, nil, success: {
                ProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
            }) { (error) in
                ProgressHUD.showError(error)
            }
            
        }else{
            let options = PHVideoRequestOptions()
            
            options.deliveryMode = .automatic
            
            
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (AVAsset, AVAudioMix, [AnyHashable : Any]?) in
                
                let videoURL = (AVAsset as! AVURLAsset).url
                
                PostService.share.createPostWithImageUndVideo( self.textView.text, imageData,imageRatio, videoURL, success: {
                    ProgressHUD.dismiss()
                    self.dismiss(animated: true, completion: nil)
                }) { (error) in
                    ProgressHUD.showError(error)
                }
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
