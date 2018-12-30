//
//  CamaraViewController.swift
//  MyIns
//
//  Created by LiYong on 2018/12/8.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CamaraViewController: UIViewController,AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var weiterItem: UIBarButtonItem!
    @IBOutlet weak var camaraButton: UIButton!
    @IBOutlet weak var flipButton: UIButton!
    @IBOutlet weak var camaraImageView: UIImageView!
    
    
    var captureSession = AVCaptureSession()
    var photoOutput = AVCapturePhotoOutput()
    var previewLayer:AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCaptureSession()
    }
    
    
    func setupCaptureSession(){
        
        // 1. CaptureSession
        captureSession.sessionPreset = .photo
        
        // 2. Input
        
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        do {
            guard let device = captureDevice else {return}
            let input = try AVCaptureDeviceInput(device: device)
            
            if captureSession.canAddInput(input) {
                
                captureSession.addInput(input)
            }
            
        } catch let error {
            ProgressHUD.showError(error.localizedDescription)
        }
        
        // 3. Output
        
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
        
        if captureSession.canAddOutput(photoOutput) {
            
            captureSession.addOutput(photoOutput)
        }
        
        // 4. Preview Layout
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.frame.size = self.camaraImageView.frame.size
        previewLayer.frame = self.camaraImageView.frame
//        previewLayer.frame.size = CGSize(width: 200, height: 200)
        self.view.layer.insertSublayer(previewLayer, above: self.camaraImageView.layer)
        
        // 5. Starten
        
        captureSession.startRunning()
    }
    
    
    
    @IBAction func swichCamaraAction(_ sender: Any) {
        
        swichCamara()
    }
    
    
    func swichCamara(){
        
        guard let input = captureSession.inputs[0] as? AVCaptureDeviceInput else{return}
        
        captureSession.beginConfiguration()
        
        defer{
            captureSession.commitConfiguration()
        }
        
        
        var newDevice: AVCaptureDevice?
        
        if input.device.position == .back {
            newDevice = getAvailableDevice(AVCaptureDevice.Position.front)
        }else{
            newDevice = getAvailableDevice(AVCaptureDevice.Position.back)
        }
        
        
        var newDeviceInput : AVCaptureDeviceInput!

        do {
            guard let device = newDevice else {return}
            newDeviceInput = try AVCaptureDeviceInput(device: device)
        } catch let error {
            ProgressHUD.showError(error.localizedDescription)
        }
        
        captureSession.removeInput(input)
        
        if captureSession.canAddInput(newDeviceInput){
            captureSession.addInput(newDeviceInput)
        }
        
    }
    
    func getAvailableDevice(_ postion:AVCaptureDevice.Position)->AVCaptureDevice?{
        
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInDualCamera,AVCaptureDevice.DeviceType.builtInTelephotoCamera,AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: postion).devices
        
        for device in devices {
            if device.position == postion {
                return device
            }
        }
        
        return nil
    }
  

    @IBAction func captrueFoto(_ sender: Any) {
        
        if self.camaraImageView.image != nil {
            
            flipButton.isHidden = false
            weiterItem.isEnabled = false
            downloadButton.isHidden = true
            self.camaraImageView.image = nil
            
            self.view.layer.insertSublayer(previewLayer, above: self.camaraImageView.layer)
            
        }else{
            flipButton.isHidden = true
            weiterItem.isEnabled = true
            downloadButton.isHidden = false
            
            takeFoto()
        }
        
    }
   
    func takeFoto(){
        let settings = AVCapturePhotoSettings()
        
        guard let formatType = settings.availablePreviewPhotoPixelFormatTypes.first else {
            return
        }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String:formatType]
        photoOutput.capturePhoto(with: settings, delegate: self)
        
    }
    
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
        
        if let data = photo.fileDataRepresentation(){
            
            self.camaraImageView.image = UIImage(data: data)
            
            self.view.layer.insertSublayer(self.camaraImageView.layer, above: self.previewLayer)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shareDetaiVC" {
            let vc = segue.destination as! ShareDetailViewController
            vc.postImage = self.camaraImageView.image
        }
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        
        saveFoto()
       
    }
    
    
    func saveFoto(){
        
        let library = PHPhotoLibrary.shared()
        
        if let image = self.camaraImageView.image {
            
            library.performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { (sucess, error) in
                if error != nil{
                    ProgressHUD.showError(error?.localizedDescription)
                }else{
                    ProgressHUD.showSuccess("Foto ist gespeichert!")
                }
            }
            
        }
    }
}
