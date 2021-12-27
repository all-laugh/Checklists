//
//  Checklist.swift
//  Checklists
//
//  Created by Xiao Quan on 12/23/21.
//

import UIKit

class Checklist: NSObject, Codable {
    var name: String
    var items: [ChecklistItem]
    var iconName: String
    
    init(name: String, items: [ChecklistItem]) {
        self.name = name
        self.items = items
        self.iconName = "checklist"
        super.init()
    }
    
    init(name: String, items: [ChecklistItem], iconName: String) {
        self.name = name
        self.items = items
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        items.filter { !$0.completed }.count
    }
}
