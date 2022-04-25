//
//  ViewController.swift
//  AgendaColumbus
//
//  Created by Arlen Peña on 24/04/22.
//

import UIKit
import CoreData

class ViewController: UIViewController{

    @IBAction func addContact(_ sender: Any) {
    }
    
    @IBOutlet weak var emptyLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var contactos: [Contacto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        contactos.removeAll()
        dataFromCoreData()
    }
    
    func dataFromCoreData(){
      
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let contexto = appDelegate.persistentContainer.viewContext
      

      let requestData = NSFetchRequest<Contact>(entityName: "Contact")
      
      do{
        let resulFromRequestData = try contexto.fetch(requestData)
        
        resulFromRequestData.forEach { (p) in
          
            contactos.append(Contacto(id: p.id!, name: p.name!, email: p.email!, phone: p.phone!, address: p.address!, notes: p.notes!))
        }
        
      }catch{
        print("Error: \(error)")
      }
        
        if contactos.count == 0 {
            emptyLbl.isHidden = false
            tableView.isHidden = true
        } else{
            emptyLbl.isHidden = true
            tableView.isHidden = false
        }
        
        self.tableView.reloadData()
      
    }
    
   
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = contactos[indexPath.row].name
        cell.detailTextLabel?.text = contactos[indexPath.row].phone
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vcd = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nuevo") as? EditViewController{
            vcd.contactoEditar = contactos[indexPath.row]
            self.navigationController?.pushViewController(vcd, animated: true)
        }
    }
    
}

