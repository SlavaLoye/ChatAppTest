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
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?

    let inputsContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
   lazy var  loginRegisterButtonView: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 10
        btn.setTitle("Register", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        //UIColor(r: 83, g: 155, b: 97)
        
        // TapButton
        
        btn.addTarget(self, action: #selector(hadleLoginRegister), for: .touchUpInside)
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
    
    lazy var profileImageView: UIImageView = {
        let pfImage = UIImageView()
        pfImage.image = UIImage(named: "ProfileImage")
        pfImage.layer.borderWidth = 4
        //pfImage.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        pfImage.layer.cornerRadius = 150 / 2
        pfImage.contentMode = .scaleAspectFill
        pfImage.translatesAutoresizingMaskIntoConstraints = false
        
        pfImage.layer.borderColor = UIColor(white: 1.5, alpha: 0.4).cgColor
        pfImage.clipsToBounds = true
        //pfImage.layer.cornerRadius = pfImage.bounds.height / 2
        
        // Подгружаем картинку в ленивом свойстве
        
        pfImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleSelectProfileImageView)))
        pfImage.isUserInteractionEnabled = true
        
        return pfImage
    }()
    
    lazy var loginRegisterSegmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
    
        return sc
    }()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(inputsContainerView)
        self.view.addSubview(loginRegisterButtonView)
        self.view.addSubview(profileImageView)
        self.view.addSubview(loginRegisterSegmentControl)
        
        //добавляем констрейны после добавдение inputsContainerView
        setupInputsContainerViewConstraints()
        registerButtonViewConstraints()
        setupProfileImageViewConstraints()
        setupLoginRegisterSegmentControl()
        self.view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        //UIColor(r: 25, g: 129, b: 46)
    }
    
   
    
    
    // MARK: - handleLoginRegisterChange
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentControl.titleForSegment(at: loginRegisterSegmentControl.selectedSegmentIndex)
        loginRegisterButtonView.setTitle(title, for: .normal)
        
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextField.isHidden = loginRegisterSegmentControl.selectedSegmentIndex == 0 ? true : false
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        
        //emailTextField.isHidden = loginRegisterSegmentControl.selectedSegmentIndex == 0 ? true : false
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        
    }

    
    // MARK: - hadleLogin
    
    @objc func hadleLoginRegister() {
        if loginRegisterSegmentControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
        
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not Valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }
        
    func handleRegister() {
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
            let userReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            
            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error?.localizedDescription ?? 0)
                    return
                }
            })
            self.dismiss(animated: true, completion: nil)
            
        }
    }


    
    // MARK: - setupLoginRegisterSegmentControl
    
    func setupLoginRegisterSegmentControl() {
        
    // MARK: - loginRegisterSegmentControl
        loginRegisterSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    
    }
    
    
    // MARK: - setupInputsContainerViewConstraints
    
    func setupInputsContainerViewConstraints() {
        
    // MARK: - inputsContainerView
        inputsContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
        
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        
        
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
        
        
    // MARK: Constraint - nameTextFieldHeightAnchor
        nameTextFieldHeightAnchor =  nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
    // MARK: Constraint - emailTextField
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 8).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
    // MARK: Constraint - emailTextFieldHeightAnchor
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
    // MARK: Constraint - passwordTextField
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 8).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
    // MARK: Constraint - passwordTextFieldHeightAnchor
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
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
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
      
    }
    
    
    // меняем значки в батареи (heder) (батарея, вайфай и тд)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
