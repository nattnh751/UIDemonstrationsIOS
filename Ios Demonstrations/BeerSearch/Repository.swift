//
//  Repository.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/15/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import Foundation
import Mapper
 
struct Repository: Mappable {
    
  let identifier: Int
    let language: String? // Optional property
    let url: String? // Optional property

    init(map: Mapper) throws {
        try identifier = map.from("id")
        language = map.optionalFrom("language")
        url = map.optionalFrom("url")
    }
}
