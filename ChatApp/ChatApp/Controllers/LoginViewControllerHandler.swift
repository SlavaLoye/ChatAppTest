//
//  LoginViewControllerHandler.swift
//  ChatApp
//
//  Created by Вячеслав Лойе on 25.06.2018.
//  Copyright © 2018 Вячеслав Лойе. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result: AuthDataResult?, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            guard let uid = result?.user.uid else {
                return
            }
            
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error ?? "")
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                        }
                        
                        if let profileImageUrl = url?.absoluteString {
                            
                            let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                            
                            self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                        }
                    })
                })
            }
        }
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err ?? "")
                return
            }
            
            let user = User(dictionary: values)
            self.messagesController?.setupNavBarWithUser(user)
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
}

