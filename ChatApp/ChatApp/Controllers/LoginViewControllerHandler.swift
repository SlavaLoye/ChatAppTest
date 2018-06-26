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
    
    
        // MARK: - handleRegister
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
            
            // MARK: - hadleLogin// создаем Reference или юзера в базе данных
            
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            // image successful authenficated user
            
            // var metadata = StorageMetadata?.self
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("\(imageName).png")
            
            let uploadData = UIImagePNGRepresentation(self.profileImageView.image!)
            
            storageRef.putData(uploadData!, metadata: nil, completion: { (metadata, error) in
                
                if error != nil, metadata != nil {
                    return
                }
                
                if  let profileImageUrl = metadata?.size {
                    let values = [name: name, email: email, "profileImage": profileImageUrl] as [String : Any]
                    self.registeUserIntoDatabaseWithUID(uid: uid, values: values as [String: Any])
                }
            })
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
     func registeUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
               print(error?.localizedDescription ?? 0)
                return
            }
        
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
        
        // меняем фотографию в профайле selected Image - выбранное изображение
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            
            
         // меняем фотографию в профайле selected Image - originalImage (выбранное изображение)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"]  as? UIImage {
            selectedImageFromPicker = originalImage
        } 
        if let selectedImage = selectedImageFromPicker {
           profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
  }


//                storageRef.downloadURL(completion: { (url, error) in
//                    guard let downloadURL = url else { return }


//  В Firebase 5.0 они избавились от downladURL()

//https://stackoverflow.com/questions/50448396/value-of-type-storagemetadata-has-no-member-downloadurl

