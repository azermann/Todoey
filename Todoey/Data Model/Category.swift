//
//  Category.swift
//  Todoey
//
//  Created by Korhan Sönmezsoy on 1.03.2018.
//  Copyright © 2018 Korhan Sönmezsoy. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    let items = List<Item>() // birden fazla item aynı kategoride olabilir
    
}
