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
                // print("Error")
                return
            }
            
            // MARK: - hadleLogin// создаем Reference или юзера в базе данных
            
            guard let uid = Auth.auth().currentUser?.uid  else {
                return
            }
            
            // MARK: - image successful authenficated user
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let profileImage = self.profileImageView.image, let  uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil, metadata !=  nil {
//                        let size = metadata?.size
                        print(error ?? "")
                        return
                        
                    }
  
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                        }
                        if let profileImageUrl = url?.absoluteString  {
                            let values = ["name": name, "email": email, "profileImage": profileImageUrl]
                            self.registeUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                        }
                    })
                })
            }
        }
    }
        
    fileprivate func registeUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
              // print(error?.localizedDescription ?? 0)
                return
            }
            
            // оптимизируем шапку имени в навигейшен бар
           // self.messagesController?.fetchUserAndSetupNavBarTitle()
           // self.messagesController?.chekIfUserIsLoogedIn()
            //self.messagesController?.navigationItem.title = values["name"] as? String
            let user = User()
            user.setValuesForKeys(values)
            self.messagesController?.setupNavBarWithUser(user: user)
            
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
// https://stackoverflow.com/questions/49344492/how-can-i-set-profile-pic-against-firebase-user-authentication-with-email
//https://ruvid.net/video/swift-firebase-3-how-to-upload-images-to-firebase-storage-ep-5-b1vrjt7Nvb0.html
