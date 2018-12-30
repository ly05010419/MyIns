//
//  RegistrationViewController.swift
//  MyIns
//
//  Created by LiYong on 2018/12/5.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit
import AMPopTip

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var comformButton: UIButton!
    @IBOutlet weak var sv: UIStackView!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var anmeldungsButton: UIButton!
    
    var loginVC:LoginViewController!
    
    let popTip = PopTip()
    
    private var userImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addTarget()
        addTargetOnAcoountImage()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        touches.forEach { (touch) in
            
            let loction = touch.location(in: self.sv)
            
            
            
            if self.comformButton.frame.contains(loction) && !self.comformButton.isEnabled {
                
                popTip.show(text: "Name Email und Password sollt eintippen", direction: .up, maxWidth: 200, in: self.comformButton, from: CGRect(origin: CGPoint.zero, size: self.comformButton.frame.size), duration: 3)
            }
        }
    }
    
    func addTargetOnAcoountImage(){
        
        accountImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        
        accountImageView.addGestureRecognizer(tap)
    }
    
    @objc func tapAction(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.accountImageView.image = editedImage
            
            self.userImage = editedImage
        }else  if let orginalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.accountImageView.image = orginalImage
            
            self.userImage = orginalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func setupView(){
        
        accountImageView.clipsToBounds = true
        accountImageView.layer.cornerRadius = accountImageView.frame.width/2
        
        accountImageView.layer.borderWidth = 2
        accountImageView.layer.borderColor = UIColor.white.cgColor
        
        emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        userNameTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        userNameTextField.attributedPlaceholder = NSAttributedString(string: userNameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        comformButton.layer.cornerRadius = 5
        
        comformButton.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        comformButton.isEnabled = false
        
        let attributString = NSMutableAttributedString(string: "Haben Sie schon ein Konto? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),NSAttributedString.Key.foregroundColor : UIColor.white])
        
        attributString.append(NSAttributedString(string: " Anmelden!", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17),NSAttributedString.Key.foregroundColor : UIColor.red]))
        
        anmeldungsButton.setAttributedTitle(attributString, for: UIControl.State.normal)
        
    }
    
    
    func addTarget(){
        
        emailTextField.addTarget(self, action: #selector(checkEmailPassword), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(checkEmailPassword), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(checkEmailPassword), for: .editingChanged)
        
         userNameTextField.addTarget(self, action: #selector(nameDidBegein(_:)), for: .editingDidBegin)
        emailTextField.addTarget(self, action: #selector(emailDidBegein(_:)), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(pswDidBegein(_:)), for: .editingDidBegin)
    }
    
    @objc func nameDidBegein(_ sender:UIView){
        
        
        popTip.show(text: "Name sollt gültig", direction: .up, maxWidth: 200, in: sender, from: CGRect(origin: CGPoint.zero, size: sender.frame.size), duration: 3)
    }
    
    @objc func emailDidBegein(_ sender:UIView){
        
        
        popTip.show(text: "Email sollt mit @ gültig", direction: .up, maxWidth: 200, in: sender, from: CGRect(origin: CGPoint.zero, size: sender.frame.size), duration: 3)
    }
    
    @objc func pswDidBegein(_ sender:UIView){
        print(sender)
        
        popTip.show(text: "Password sollt mindestens 6 zeichen gültig", direction: .up, maxWidth: 200, in: sender, from: CGRect(origin: CGPoint.zero, size: sender.frame.size), duration: 3)
    }
    
    @objc func checkEmailPassword(){
        
        let isEmail = emailTextField.text?.count ?? 0 > 0
        
        let isPaw = passwordTextField.text?.count ?? 0 > 0
        
        let isWiederHolung = userNameTextField.text?.count ?? 0 > 0
        
        
        if isEmail {
            emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        }else{
            
            emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        }
        
        
        if isPaw {
            
            passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        }else{
            
            passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        }
        
        if isWiederHolung {
            
            userNameTextField.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        }else{
            
            userNameTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        }
        
        
        
        if isEmail && isPaw && isWiederHolung{
            comformButton.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            comformButton.isEnabled = true
            
        }else{
            comformButton.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            comformButton.isEnabled = false
        }
        
    }
    
    @IBAction func registrationAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        
        if self.userImage == nil {
            
            ProgressHUD.showError("Bitte Foto auswählen")
            return
        }
        
        ProgressHUD.show("Lade...")
        
        if let name = self.userNameTextField.text,let email = emailTextField.text ,let password = passwordTextField.text,let imagedata = self.userImage?.jpegData(compressionQuality: 0.2)  {
            
            
            UserService.share.createUser(name,email, password, imagedata, success: { (FIRUser) in
                
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "relogin"), object: nil)
                
                ProgressHUD.dismiss()
                
                KeyChainService.share.addEmailUndPasswordInKeyChain(email,password)
                
                self.dismiss(animated: true, completion: nil)
              
                
            }) { (error) in
                
                ProgressHUD.showError(error)
            }
            
            
            
        }
 
    }
    
    
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
