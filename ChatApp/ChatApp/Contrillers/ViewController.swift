//
//  ViewController.swift
//  ChatApp
//
//  Created by Вячеслав Лойе on 22.06.2018.
//  Copyright © 2018 Вячеслав Лойе. All rights reserved.
//https://www.youtube.com/watch?v=pLyEA6PuqAU&index=1&list=PLZ7bsrwx1wnVtKmnf0SfKY_-yz0aWo2_z

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogin))
    }
    
    @objc func handleLogin() {
        let login = LoginViewController()
        present(login, animated: true, completion: nil)
    
    }
}

