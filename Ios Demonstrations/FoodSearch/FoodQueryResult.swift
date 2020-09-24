//
//  FoodQueryResult.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/24/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import Foundation
import Mapper

struct FoodQueryResult : Mappable {

  var results : [SimpleRecipe]
  var offset : Int
  var number : Int
  var totalResults : Int
  
  init(map: Mapper) throws {
    results = try map.from("results")
    offset = try map.from("offset")
    number = try map.from("number")
    totalResults = try map.from("totalResults")

  }

}
