//
//  Issue.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/15/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import Foundation
import Mapper
 
struct Issue: Mappable {
    
    let identifier: Int
    let number: Int
    let title: String
    let body: String
    
    init(map: Mapper) throws {
        try identifier = map.from("id")
        try number = map.from("number")
        try title = map.from("title")
        try body = map.from("body")
    }
}
