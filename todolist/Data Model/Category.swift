//
//  Category.swift
//  todolist
//
//  Created by Lucy Flores on 24/07/2019.
//  Copyright © 2019 lefleur. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    
    // Forward relationship
    let items = List<Item>()
    
}
