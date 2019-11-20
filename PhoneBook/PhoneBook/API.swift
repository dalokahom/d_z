//
//  API.swift
//  PhoneBook
//
//  Created by Дарья Хомякова on 16.11.2019.
//  Copyright © 2019 Дарья Хомякова. All rights reserved.
//

import UIKit

typealias JSON = [String : Any]

enum API {
    
    static var identifier: String { "dalokahom" }
    static var baseURL: String {
        "https://ios-napoleonit.firebaseio.com/data/\(identifier)/"
    }
    static var storageName: String { "contacts" }
    
    static func loadContacts(completion: @escaping ([Contact]) -> Void) {
        let url = URL(string: baseURL + ".json")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSON
            else { return }
            
            let contactsJSON = json[storageName] as! JSON
            var contacts = [Contact]()

            for contact in contactsJSON {
                contacts.append(Contact(id: contact.key, data: contact.value as! JSON))
            }
            
            contacts.sort { $0.name < $1.name }
            
            DispatchQueue.main.async {
                completion(contacts)
            }
        }
        task.resume()
    }
    
    static func createContact(name: String, surname: String, number: String, completion: @escaping (Bool) -> Void) {
        let params = [
            "name": name,
            "surname": surname,
            "number": number,
            ]
        
        let url = URL(string: baseURL + "/\(storageName).json")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(error == nil)
        }
        task.resume()
    }
    
    static func editContact(contactID: String, name: String, surname: String, number: String, completion: @escaping (Bool) -> Void) {
        let params = [
            "name": name,
            "surname": surname,
            "number": number,
        ]
        
        let url = URL(string: baseURL + "/\(storageName)/\(contactID)/.json")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PATCH"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(error == nil)
        }
        task.resume()
    }
    
}
