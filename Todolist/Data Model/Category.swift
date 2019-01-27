//
//  Category.swift
//  Todolist
//
//  Created by Derek on 2019/1/25.
//  Copyright © 2019 Derek. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    let items = List<Item>()
}
