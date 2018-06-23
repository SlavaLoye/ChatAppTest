//
//  ViewController.swift
//  ChatApp
//
//  Created by Вячеслав Лойе on 22.06.2018.
//  Copyright © 2018 Вячеслав Лойе. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogin))
        if Auth.auth().currentUser == nil {
            perform(#selector(handleLogin), with: nil, afterDelay: 0)
        }
    }
    
    @objc func handleLogin() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let login = LoginViewController()
        present(login, animated: true, completion: nil)
    }
}

