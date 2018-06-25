//
//  LoginViewControllerHandler.swift
//  ChatApp
//
//  Created by Вячеслав Лойе on 25.06.2018.
//  Copyright © 2018 Вячеслав Лойе. All rights reserved.
//

import UIKit

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
   @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
    
        picker.allowsEditing = true
    
        present(picker, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        // меняем фотографию в профайле
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            
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
