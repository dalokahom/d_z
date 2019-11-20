//
//  MainTableViewController.swift
//  PhoneBook
//
//  Created by Дарья Хомякова on 12.11.2019.
//  Copyright © 2019 Дарья Хомякова. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    private var contacts = [Contact]() {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        API.loadContacts { contactsArray in
            self.contacts = contactsArray
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        API.loadContacts { contactsArray in
            self.contacts = contactsArray
        }
        tableView.reloadData()
        
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "\(contacts[indexPath.row].name) \(contacts[indexPath.row].surname!)"
        
        return cell
    }

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
        guard let addContactVC = segue.source as? AddContactVC else { return }
        addContactVC.saveNew()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContact"{
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            let pickedContact = contacts[indexPath.row]
            let editContactVC = segue.destination as! AddContactVC
            editContactVC.pickedContact = pickedContact
            editContactVC.pickedContactIndex = indexPath.row
        }
    }

}

