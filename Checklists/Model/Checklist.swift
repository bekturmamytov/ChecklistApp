//
//  Checklist.swift
//  Checklists
//
//  Created by Bektur Mamytov on 7/2/23.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
}
