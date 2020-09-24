//
//  SimpleRecipe.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/24/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import Foundation
import Mapper

struct SimpleRecipe : Mappable {

  var id : Int
  var title : String
  var image : String
  var imageType : String
  
  init(map: Mapper) throws {
    id = try map.from("id")
    title = try map.from("title")
    image = try map.from("image")
    imageType = try map.from("imageType")
  }

}
