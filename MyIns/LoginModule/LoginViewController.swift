
//
//  LoginViewController.swift
//  MyIns
//
//  Created by LiYong on 2018/12/5.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit
import AMPopTip


class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var sv: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let popTip = PopTip()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        addTarget()
    }
    
   
    
    
    
    func setupView(){
        
        emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        
        passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        loginButton.layer.cornerRadius = 5
        
        loginButton.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        loginButton.isEnabled = false
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        touches.forEach { (touch) in
            
            let loction = touch.location(in: self.sv)
            
            
            
            if self.loginButton.frame.contains(loction) && !self.loginButton.isEnabled {
                
                popTip.show(text: "Email und Password sollt eintippen", direction: .up, maxWidth: 200, in: self.loginButton, from: CGRect(origin: CGPoint.zero, size: self.loginButton.frame.size), duration: 3)
            }
        }
        
    }
    
    
    func addTarget(){
        
        emailTextField.addTarget(self, action: #selector(checkEmailPassword), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(checkEmailPassword), for: .editingChanged)
        
        
        emailTextField.addTarget(self, action: #selector(emailDidBegein(_:)), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(pswDidBegein(_:)), for: .editingDidBegin)
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
        
        var isPaw = passwordTextField.text?.count ?? 0 > 0
        
        
        if isEmail {
            
            emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            
            let p = KeyChainService.share.getPassword(emailTextField.text!)
            
            if p != nil {
                
                self.passwordTextField.text = p
                isPaw = passwordTextField.text?.count ?? 0 > 0
                
                self.view.endEditing(true)
            }
            
            
            
        }else{
            
            emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        }
        
        
        if isPaw {
            
            passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        }else{
            
            passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        }
        
        
        
        if isEmail && isPaw{
            loginButton.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            loginButton.isEnabled = true
            
            
        }else{
            loginButton.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            loginButton.isEnabled = false
        }
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "registrationViewController" {
            
            let vc = segue.destination as! RegistrationViewController
            vc.loginVC = self
            
        }
    }
    
    
    @IBAction func loginAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if let email = self.emailTextField.text, let password = self.passwordTextField.text {
            
            
            ProgressHUD.show("lade... ")
            
            AuthenticationService.share.login(email, password, success: { (user) in
                
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "relogin"), object: nil)
                
                ProgressHUD.dismiss()
                
                KeyChainService.share.addEmailUndPasswordInKeyChain(email,password)
                
                self.dismiss(animated: true, completion: nil)
                
                
            }) { (error) in
                
                ProgressHUD.showError(error?.localizedDescription)
                
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
