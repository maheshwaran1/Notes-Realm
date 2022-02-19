//
//  Category.swift
//  Notes-Realm
//
//  Created by Maheshwaran on 19/02/22.
//

import UIKit
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
