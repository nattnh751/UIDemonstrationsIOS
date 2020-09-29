//
//  FoodSearch.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/24/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import Foundation
import Moya

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

enum FoodSearch {
    case getFoodWithQuery(String)
}
let API_KEY = "e168d3304469432dacc33cdd825aed1e"
extension FoodSearch: TargetType {

    var baseURL: URL { return URL(string: "https://api.spoonacular.com/")! }
    var method: Moya.Method { return .get }
    var headers: [String : String]? { return nil }
    var task: Task {
      switch self {
        case .getFoodWithQuery(let query):
          var params: [String: Any] = [:]
          params["query"] = query
          params["apiKey"] = API_KEY
//          params["addRecipeInformation"] = "true"
          return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
      
  
  
    var path: String {
      return "recipes/complexSearch"
    }
    
    var sampleData: Data {
        return Data()
    }
}
