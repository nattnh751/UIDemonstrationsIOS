//
//  Issue.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/15/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import Mapper

struct User: Mappable {
    
    let login: String
    
    init(map: Mapper) throws {
        try login = map.from("login")
    }
}
