//
//  Item.swift
//  Todolist
//
//  Created by Derek on 2019/1/25.
//  Copyright © 2019 Derek. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated:Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
