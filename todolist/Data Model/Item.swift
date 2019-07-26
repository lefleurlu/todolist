//
//  Item.swift
//  todolist
//
//  Created by Lucy Flores on 24/07/2019.
//  Copyright © 2019 lefleur. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var item : String = ""
    @objc dynamic var flag : Bool = false
    
    // Inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
