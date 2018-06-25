//
//  NewMessageController.swift
//  ChatApp
//
//  Created by Вячеслав Лойе on 24.06.2018.
//  Copyright © 2018 Вячеслав Лойе. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "Cell"
    
    var users = [User]()
    //var userCell = UserCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // добавляем ячейку для юзеров
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        fetchUser()
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
        
            if let dictionary = snapshot.value as? [String: Any] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                print(user)
                
                // DispatchQueue
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                print(user.name ?? 0)
            }
        }
    }
    
    @objc func handleCancel()  {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        let user = users[indexPath.row]
        cell?.textLabel?.text = user.name
        cell?.detailTextLabel?.text = user.email
       return cell!
    }
}

