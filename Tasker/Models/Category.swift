//
//  Category.swift
//  Tasker
//
//  Created by Devesh Nema on 6/18/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import Foundation

protocol DocumentSerializable {
    init?(dictionary: [String:Any])
}

struct Category
{
    var name: String
    var tasks: [Task]
    var color: String
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "color": color,
            "tasks": tasks,
        ]
    }
}

extension Category : DocumentSerializable
{
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let tasks = dictionary["tasks"] as? [Task],
            let color = dictionary["color"] as? String
            else { return nil }
        self.init(name: name, tasks: tasks, color: color)
    }
}
