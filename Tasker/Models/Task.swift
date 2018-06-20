//
//  Task.swift
//  Tasker
//
//  Created by Devesh Nema on 6/18/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import Foundation

struct Task
{
    var title: String
    var done: Bool
    var parentCategory: Category
    
    var dictionary: [String: Any] {
        return [
            "title": title,
            "done": done,
            "parentCategory": parentCategory,
        ]
    }
}

extension Task : DocumentSerializable
{
    init?(dictionary: [String : Any]) {
        guard let title = dictionary["title"] as? String,
            let done = dictionary["done"] as? Bool,
            let parentCategory = dictionary["parentCategory"] as? Category
            else { return nil }
        self.init(title: title, done: done, parentCategory: parentCategory)
    }
}
