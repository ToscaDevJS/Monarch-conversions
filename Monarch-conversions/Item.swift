//
//  Item.swift
//  Monarch-conversions
//
//  Created by Orlando Jesus Abril Tosca on 05/08/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
