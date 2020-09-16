//
//  IssueTrackerModel.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/15/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift
 
public struct IssueTrackerModel {
    
  let provider = MoyaProvider<BeerSearch>()
  private static let shared = IssueTrackerModel()
  init() {}

  func findBeer(query: String) -> Single<[Beer]> {
    return provider.rx.request(BeerSearch.getBeer(query)).map(to: [Beer].self, keyPath: "owner")

  }
}
