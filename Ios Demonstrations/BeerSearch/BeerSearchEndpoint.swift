//
//  githubEndpoint.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/15/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import Foundation
import Moya

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

enum BeerSearch {
    case getBeer(String)
}

extension BeerSearch: TargetType {

    var baseURL: URL { return URL(string: "https://api.punkapi.com/v2/")! }
    var method: Moya.Method { return .get }
    var headers: [String : String]? { return nil }
    var task: Task {
      switch self {
        case .getBeer(let query):
            var params: [String: Any] = [:]
            params["beer_name"] = query
            if(query.count > 0) {
              return .requestParameters(parameters: params, encoding: URLEncoding.default)
            } else {
              return .requestPlain
        }
        default:
            return .requestPlain
        }
      
  }
  
    var path: String {
      return "beers"
        
    }
    
    var sampleData: Data {
        return Data()
    }
}
