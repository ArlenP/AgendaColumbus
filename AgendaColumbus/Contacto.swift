//
//  Contacto.swift
//  AgendaColumbus
//
//  Created by Arlen Peña on 24/04/22.
//

import Foundation

class Contacto{
  var id: UUID
  var name: String
  var email: String
  var phone: String
  var address: String
  var notes: String
    
    init?(){
        return nil
    }
  
    init(id:UUID,name:String,email:String,phone:String,address:String,notes:String){
    self.id = id
    self.name =  name
    self.email = email
    self.phone = phone
    self.address = address
    self.notes = notes
  }
}
