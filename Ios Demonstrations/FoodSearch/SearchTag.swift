//
//  File.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/22/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import Foundation
var dietDefinitions: [String] = ["Whole30", "Primal", "Paleo", "Pescetarian", "Vegan", "Ovo-Vegetarian", "Lacto-Vegetarian", "Vegetarian", "Ketogenic" ]
var cusineDefinitions: [String] = ["African", "American", "British", "Cajun", "Caribbean", "Chinese", "European", "French", "German" ]
var intoleranceDefintions: [String] = ["Dairy", "Egg", "Gluten", "Grain", "Peanut", "Seafood", "Sesame", "Shellfish", "Soy" ]


@objc class SearchTag : NSObject {
  @objc var color: UIColor?
  @objc var searchTagId: NSNumber?
  @objc var name: String?
  @objc var type: String?
}

extension SearchTag {
  @objc public func getAllSearchTags() -> [SearchTag] {
    var tags = [SearchTag]()
    var count = 0
    for diet in dietDefinitions {
      count += 1
      let tag = SearchTag()
      tag.name = diet
      tag.searchTagId = NSNumber(value: count)
      tag.type = "Diet Type"
      tag.color = .red
      tags.append(tag)
    }
    for cusinse in cusineDefinitions {
      count += 1
      let cusinseTag = SearchTag()
      cusinseTag.name = cusinse
      cusinseTag.searchTagId = NSNumber(value: count)
      cusinseTag.type = "Cusinse"
      cusinseTag.color = .darkGray
      tags.append(cusinseTag)
    }
    for intolerance in intoleranceDefintions {
      count += 1
      let intoleranceTag = SearchTag()
      intoleranceTag.name = intolerance
      intoleranceTag.searchTagId = NSNumber(value: count)
      intoleranceTag.type = "Intolerance"
      intoleranceTag.color = .black
      tags.append(intoleranceTag)
    }
    return tags
  }
  @objc public func getAllSearchTagsFor(type: String) -> [SearchTag] {
    var tags = [SearchTag]()
    var count = 0
    for diet in dietDefinitions {
      count += 1
      if(type == "Diet Type") {
        let tag = SearchTag()
        tag.name = diet
        tag.searchTagId = NSNumber(value: count)
        tag.type = "Diet Type"
        tag.color = .red
        tags.append(tag)
      }
    }
    for cusinse in cusineDefinitions {
      count += 1
      if(type == "Cusinse") {
        let cusinseTag = SearchTag()
        cusinseTag.name = cusinse
        cusinseTag.searchTagId = NSNumber(value: count)
        cusinseTag.type = "Cusinse"
        cusinseTag.color = .darkGray
        tags.append(cusinseTag)
      }
    }
    for intolerance in intoleranceDefintions {
      count += 1
      if(type == "Intolerance") {
        let intoleranceTag = SearchTag()
        intoleranceTag.name = intolerance
        intoleranceTag.searchTagId = NSNumber(value: count)
        intoleranceTag.type = "Intolerance"
        intoleranceTag.color = .green
        tags.append(intoleranceTag)
      }
    }
    
    return tags.sorted { $0.name ?? "" < $1.name ?? "" }
  }
}
