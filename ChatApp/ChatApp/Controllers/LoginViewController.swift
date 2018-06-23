//
//  LoginViewController.swift
//  ChatApp
// Hello World
//  Created by Вячеслав Лойе on 22.06.2018.
//  Copyright © 2018 Вячеслав Лойе. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    let inputsContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
   lazy var  loginRegisterButtonView: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        //UIColor(r: 83, g: 155, b: 97)
        
        // TapButton
        
        btn.addTarget(self, action: #selector(hadleLogin), for: .touchUpInside)
        return btn
    }()
    
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let emailTextField: UITextField = {
        let emailTf = UITextField()
        emailTf.placeholder = "Email"
        emailTf.translatesAutoresizingMaskIntoConstraints = false
        return emailTf
    }()
    let passwordTextField: UITextField = {
        let passwordTf = UITextField()
        passwordTf.placeholder = "Password"
        passwordTf.isSecureTextEntry = true
        passwordTf.translatesAutoresizingMaskIntoConstraints = false
        return passwordTf
    }()
    
    let nameFieldldSeparator: UIView = {
        let sp = UIView()
        sp.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        sp.translatesAutoresizingMaskIntoConstraints = false
        return sp
    }()
    let emailFieldldSeparator: UIView = {
        let esp = UIView()
        esp.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        esp.translatesAutoresizingMaskIntoConstraints = false
        return esp
    }()
    
    let profileImageView: UIImageView = {
        let pfImage = UIImageView()
        pfImage.image = UIImage(named: "ProfileImage")
        pfImage.contentMode = .scaleAspectFill
        pfImage.translatesAutoresizingMaskIntoConstraints = false
        return pfImage
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(inputsContainerView)
        self.view.addSubview(loginRegisterButtonView)
        self.view.addSubview(profileImageView)
        
        //добавляем констрейны после добавдение inputsContainerView
        setupInputsContainerViewConstraints()
        registerButtonViewConstraints()
        setupProfileImageViewConstraints()
        self.view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        //UIColor(r: 25, g: 129, b: 46)
    }
    
    // MARK: - hadleLogin
    
    @objc func hadleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Error")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("Error")
                return
            }
            // создаем Reference
            
            guard let uid = Auth.auth().currentUser?.uid else{
                print("There is no UID to access")
                return
            }
            
            let ref = Database.database().reference(fromURL: "https://chatappdev-52051.firebaseio.com/")
            let userReference = ref.child("user").child(uid)
            let values = ["name": name, "email": email]
            
            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error?.localizedDescription ?? 0)
                    return
                }
            })
            
        }
    }
        
        
        
    func setupInputsContainerViewConstraints() {
        
        // MARK: - inputsContainerView
        inputsContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // MARK: - nameTextField, passwordTextField, mailTextField
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(emailTextField)
        
        // MARK: - nameFiedldSeparator, emailFiedldSeparator
        
        inputsContainerView.addSubview(emailFieldldSeparator)
        inputsContainerView.addSubview(nameFieldldSeparator)
        
        
        // MARK: Constraint - nameTextField
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 8).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        // MARK: Constraint - emailTextField
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 8).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        // MARK: Constraint - passwordTextField
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 8).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        // MARK: Constraint - nameFiedldSeparator
        
        nameFieldldSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameFieldldSeparator.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameFieldldSeparator.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        nameFieldldSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
        // MARK: Constraint - emailFieldldSeparator
        
        emailFieldldSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailFieldldSeparator.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailFieldldSeparator.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        emailFieldldSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
    func registerButtonViewConstraints() {
        loginRegisterButtonView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginRegisterButtonView.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButtonView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButtonView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    func setupProfileImageViewConstraints() {
        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
      
    }
    
    
    // меняем значки в батареи (heder) (батарея, вайфай и тд)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
