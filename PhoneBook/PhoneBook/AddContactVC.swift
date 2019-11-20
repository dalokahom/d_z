//
//  AddContactVC.swift
//  PhoneBook
//
//  Created by Дарья Хомякова on 12.11.2019.
//  Copyright © 2019 Дарья Хомякова. All rights reserved.
//

import UIKit

class AddContactVC: UITableViewController {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var contactSurname: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    
    var pickedContact: Contact?
    var pickedContactIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UITableView()
        
        if pickedContact != nil{
            contactName.text = pickedContact?.name
            contactSurname.text = pickedContact?.surname
            contactNumber.text = pickedContact?.number
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    func saveNew() {
        if pickedContact == nil{
            API.createContact(name: contactName.text!, surname: contactSurname.text!, number: contactNumber.text!) { result in
                guard result else { return }
            }
        } else {
            let id = pickedContact?.id
            API.editContact(contactID: id!, name: contactName.text!, surname: contactSurname.text!, number: contactNumber.text!) { result in
                guard result else { return }
            }
        }
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Камера", style: .default) { _ in
                self.chooseImage(source: .camera)
            }
            
            let photo = UIAlertAction(title: "Фото", style: .default) { _ in
                self.chooseImage(source: .photoLibrary)
            }
            
            let cancel = UIAlertAction(title: "Отменить", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddContactVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func chooseImage(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePiker = UIImagePickerController()
            imagePiker.delegate = self
            imagePiker.allowsEditing = true
            imagePiker.sourceType = source
            present(imagePiker, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        contactImage.image = info[.editedImage] as? UIImage
        contactImage.contentMode = .scaleAspectFill
        contactImage.clipsToBounds = true
        dismiss(animated: true)
    }
}
