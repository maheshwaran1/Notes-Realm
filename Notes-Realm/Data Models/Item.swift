//
//  Item.swift
//  Notes-Realm
//
//  Created by Maheshwaran on 19/02/22.
//

import UIKit
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
