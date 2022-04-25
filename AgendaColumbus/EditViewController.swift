//
//  EditViewController.swift
//  AgendaColumbus
//
//  Created by Arlen Peña on 24/04/22.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    
    @IBAction func deleteData(_ sender: Any) {
            let ac = UIAlertController(title: "Important", message: "Delete this contact?", preferredStyle: .alert)
            let aa = UIAlertAction(title: "Ok", style: .destructive) { ok in
                self.deleteContact(el: self.contactoEditar!)
                self.navigationController?.popViewController(animated: true)
            }
            let ab = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(ab)
            ac.addAction(aa)
            self.present(ac, animated: true)
    }
    
    
    @IBAction func editData(_ sender: Any) {
        guard nameTxt.text != "",emailTxt.text != "", phoneTxt.text != "" else {
            let ac = UIAlertController(title: "Important", message: "All fields marked with * are required", preferredStyle: .alert)
            let aa = UIAlertAction(title: "Ok", style: .default, handler: nil)
            ac.addAction(aa)
            self.present(ac, animated: true)
                return
        }
        
        
        self.updateData(el:contactoEditar!)
        
    }
    @IBAction func saveData(_ sender: Any) {
        
        guard nameTxt.text != "",emailTxt.text != "", phoneTxt.text != "" else {
            let ac = UIAlertController(title: "Important", message: "All fields marked with * are required", preferredStyle: .alert)
            let aa = UIAlertAction(title: "Ok", style: .default, handler: nil)
            ac.addAction(aa)
            self.present(ac, animated: true)
                return
        }
        //Saving
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contexto = appDelegate.persistentContainer.viewContext
        
        let contact = Contact(context: contexto)
        contact.id = UUID()
        contact.name = nameTxt.text
        contact.email = emailTxt.text
        contact.phone = phoneTxt.text
        contact.address = addressTxt.text
        contact.notes = notesTxt.text
        
        do{
          try contexto.save()
          let ac = UIAlertController(title: "Important", message: "Contact saved successful.", preferredStyle: .alert)
            let aa = UIAlertAction(title: "Ok", style: .default) { response in
                self.navigationController?.popViewController(animated: true)
            }
          ac.addAction(aa)
          self.present(ac, animated: true)
        }catch{
          print("error: \(error)")
        }
        
    }

    @IBOutlet weak var notesTxt: UITextView!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    var contactoEditar: Contacto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let contacto = contactoEditar{
            saveBtn.isHidden = true
            deleteBtn.isHidden = false
            editBtn.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let contacto = contactoEditar{
            print(contacto.name)
            nameTxt.text = contacto.name
            phoneTxt.text = contacto.phone
            emailTxt.text = contacto.email
            addressTxt.text = contacto.address
            notesTxt.text = contacto.notes
            
        }
    }
    
    func deleteContact(el:Contacto){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contexto = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(el.id)")

        do{
            let record = try contexto.fetch(fetchRequest)
            let objToDelete = record[0] as! NSManagedObject
            contexto.delete(objToDelete)
            do{
                try contexto.save()
            }catch{
                print("Error saving data")
            }
        }catch{
            print("Error requesting data")
        }
  }
    func updateData(el:Contacto){
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
       let contexto = appDelegate.persistentContainer.viewContext
       
       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "id == %@","\(el.id)")
       
       do {
           let record = try contexto.fetch(fetchRequest)
           let recordToUpdate = record[0] as! NSManagedObject
           recordToUpdate.setValue("\(nameTxt.text!)", forKey: "name")
           recordToUpdate.setValue("\(emailTxt.text!)", forKey: "email")
           recordToUpdate.setValue("\(phoneTxt.text!)", forKey: "phone")
           recordToUpdate.setValue("\(addressTxt.text!)", forKey: "address")
           recordToUpdate.setValue("\(notesTxt.text!)", forKey: "notes")
           print("Done!")
           do{
               try contexto.save()
               let ac = UIAlertController(title: "Important", message: "¡Record updated!", preferredStyle: .alert)
               let aa = UIAlertAction(title: "Ok", style: .default){ response in 
                   self.navigationController?.popViewController(animated: true)
               }
               ac.addAction(aa)
               self.present(ac, animated: true, completion: nil)
           }catch{
               print("error")
           }
       }catch{
           print("Error in fetch")
       }
   }

}
